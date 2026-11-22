import base64
import email
from email import policy
import imaplib
import json
import re
import signal
import socket
import ssl
import sys
from datetime import datetime, timezone
from html.parser import HTMLParser
HOST = "mail.mpei.ru"
BATCH_SIZE = 40
SYNC_WINDOW = 10000
FOLDER_NAMES = {
    "sent": {"sent", "sent items", "sent messages", "отправленные", "отправленные элементы"},
    "trash": {"trash", "deleted", "deleted items", "deleted messages", "корзина",
              "удаленные", "удаленные элементы", "удаленные сообщения"},
}
MAIL_FLAGS = {"read": r"\Seen", "flagged": r"\Flagged"}
class MailError(Exception):
    pass
class TextOnly(HTMLParser):
    def __init__(self):
        super().__init__()
        self.parts = []
        self.hidden = None
    def handle_starttag(self, tag, attrs):
        if tag in ("script", "style"):
            self.hidden = tag
        elif tag in ("br", "p", "div", "li", "tr"):
            self.parts.append("\n")
    def handle_endtag(self, tag):
        if tag == self.hidden:
            self.hidden = None
    def handle_data(self, text):
        if not self.hidden:
            self.parts.append(text)
def text_content(message):
    part = message.get_body(preferencelist=("plain", "html"))
    if part is None:
        return ""
    try:
        value = part.get_content(errors="replace")
    except (LookupError, ValueError):
        value = (part.get_payload(decode=True) or b"").decode("utf-8", "replace")
    if part.get_content_type() == "text/html":
        parser = TextOnly()
        parser.feed(value)
        value = "".join(parser.parts)
    return value.strip()
def checked(response):
    status, data = response
    if status != "OK":
        raise MailError("upstream")
    return data
def response_number(client, name):
    _, data = client.response(name)
    if not data or not data[-1] or not data[-1].isdigit() or int(data[-1]) <= 0:
        raise MailError("upstream")
    return int(data[-1])
def quoted(value):
    if isinstance(value, str):
        value = value.encode("ascii")
    if any(byte in value for byte in (b"\0", b"\r", b"\n")):
        raise MailError("folder")
    return b'"' + value.replace(b"\\", b"\\\\").replace(b'"', b'\\"') + b'"'
def display_folder(value):
    def decode(match):
        encoded = match.group(1).replace(",", "/")
        return base64.b64decode(encoded + "=" * (-len(encoded) % 4)).decode("utf-16-be") if encoded else "&"
    try:
        return re.sub(r"&([A-Za-z0-9+,]*)-", decode, value.decode("utf-8"))
    except (ValueError, UnicodeError):
        return None
def resolve_folder(client, folder, request):
    if folder == "inbox":
        return b"INBOX"
    if folder not in FOLDER_NAMES:
        raise MailError("folder")
    configured = request.get("folderNames", {}).get(folder, "").casefold()
    candidates = {}
    for row in checked(client.list()):
        line, literal = row if isinstance(row, tuple) else (row, None)
        if not isinstance(line, bytes):
            continue
        info = re.fullmatch(rb'\(([^)]*)\)\s+(?:NIL|"(?:[^"\\]|\\.)*")\s+(.+)', line, re.I)
        if not info:
            continue
        flags = set(info.group(1).lower().split())
        if b"\\noselect" in flags:
            continue
        name = literal if literal is not None else info.group(2)
        if name.startswith(b'"') and name.endswith(b'"') and literal is None:
            name = re.sub(rb'\\(["\\])', rb'\1', name[1:-1])
        label = display_folder(name)
        if not label or any(byte in name for byte in (b"\0", b"\r", b"\n")):
            continue
        normalized = label.casefold().replace("ё", "е")
        if configured and configured in (label.casefold(), name.decode("ascii", "replace").casefold()):
            candidates[name] = 3
        elif ("\\" + folder).encode() in flags:
            candidates[name] = 2
        elif normalized in FOLDER_NAMES[folder]:
            candidates[name] = 1
    if not candidates:
        raise MailError("folder")
    priority = max(candidates.values())
    matches = [name for name, rank in candidates.items() if rank == priority]
    if len(matches) != 1:
        raise MailError("folder")
    return matches[0]
def fields(client, sequence, *, uid=False, preview=False):
    query = "(UID FLAGS INTERNALDATE BODY.PEEK[HEADER.FIELDS (FROM TO SUBJECT CONTENT-TYPE CONTENT-TRANSFER-ENCODING)]"
    if preview:
        query += " BODY.PEEK[TEXT]<0.4096>"
    query += ")"
    response = client.uid("FETCH", sequence, query) if uid else client.fetch(sequence, query)
    rows = []
    metadata = b""
    header = body = b""
    for piece in checked(response):
        if isinstance(piece, tuple):
            prefix, payload = piece
            metadata += b" " + prefix
            if b"HEADER.FIELDS" in prefix.upper():
                header = payload
            else:
                body = payload
        elif isinstance(piece, bytes) and piece.endswith(b")"):
            metadata += b" " + piece
            key = re.search(rb"\bUID (\d+)\b", metadata)
            if key and header:
                msg = email.message_from_bytes(header, policy=policy.default)
                stamp = imaplib.Internaldate2tuple(metadata)
                date = datetime(*stamp[:6]).astimezone(timezone.utc).isoformat() if stamp else None
                flags = set(flag.lower() for flag in imaplib.ParseFlags(metadata))
                row = {"uid": int(key.group(1)), "subject": str(msg.get("Subject") or "Без темы")[:180],
                       "from": str(msg.get("From") or "")[:300], "to": str(msg.get("To") or "")[:300],
                       "date": date, "unread": b"\\seen" not in flags, "flagged": b"\\flagged" in flags}
                if preview and (msg.get_content_type() in ("text/plain", "text/html") or msg.get_content_maintype() == "multipart"):
                    partial = email.message_from_bytes(header.rstrip(b"\r\n") + b"\r\n\r\n" + body, policy=policy.default)
                    row["preview"] = " ".join(text_content(partial).split())[:180]
                rows.append(row)
            metadata = header = body = b""
    return rows
def parts(message, prefix="", depth=0):
    if depth < 12 and message.get_content_maintype() == "multipart" and message.is_multipart():
        for index, child in enumerate(message.iter_parts(), 1):
            if index > 100:
                break
            path = "{}.{}".format(prefix, index) if prefix else str(index)
            yield from parts(child, path, depth + 1)
    elif message.get_filename() or message.get_content_disposition() == "attachment" or message.get_content_maintype() != "text":
        yield prefix or "1", message
def read_message(client, uid, part=None):
    headers = fields(client, str(uid), uid=True)
    if not headers:
        raise MailError("missing")
    chunks = bytearray()
    limit = 128 * 1024 * 1024
    chunk_size = 1024 * 1024
    while len(chunks) <= limit:
        query = "(BODY.PEEK[]<{}.{}>)".format(len(chunks), chunk_size)
        data = checked(client.uid("FETCH", str(uid), query))
        payload = next((piece[1] for piece in data if isinstance(piece, tuple)), None)
        if payload is None:
            raise MailError("missing")
        chunks.extend(payload)
        if len(payload) < chunk_size:
            break
    if len(chunks) > limit:
        raise MailError("size")
    msg = email.message_from_bytes(bytes(chunks), policy=policy.default)
    attachments = []
    for index, (section, item) in enumerate(parts(msg)):
        if index >= 100:
            break
        name = str(item.get_filename() or ("message.eml" if item.get_content_type() == "message/rfc822" else "attachment"))
        if part == section:
            payload = item.get_payload(decode=True)
            if payload is None and item.get_content_type() == "message/rfc822" and item.is_multipart():
                payload = next(item.iter_parts()).as_bytes(policy=policy.SMTP)
            return {"name": name}, payload or b""
        attachments.append({"part": section, "name": name, "downloadable": True})
    if part is not None:
        raise MailError("attachment")
    text = text_content(msg)
    return dict(headers[0], text=text[:512 * 1024], attachments=attachments, textTruncated=len(text) > 512 * 1024), None
def search_uids(client, criteria):
    result = checked(client.uid("SEARCH", None, *criteria))
    return sorted({int(uid) for uid in (result[0] or b"").split() if uid.isdigit()}, reverse=True)
def sync_folder(client, request, validity, next_uid):
    saved = request.get("cursor", {})
    initial = saved.get("validity") != validity or not saved.get("nextUid")
    previous_next = next_uid if initial else saved["nextUid"]
    before = next_uid if initial else saved.get("scanBefore", 0)
    scanning = bool(before) or request.get("rescan", False)
    new = previous_next < next_uid
    if new:
        first, last = previous_next, min(next_uid - 1, previous_next + SYNC_WINDOW - 1)
    elif scanning:
        last = (before or next_uid) - 1
        first = max(1, last - SYNC_WINDOW + 1)
    else:
        last = next_uid - 1
        first = max(1, last - SYNC_WINDOW + 1)
    uids = [uid for uid in search_uids(client, ["UNDELETED", "UID", "{}:{}".format(first, last)])
            if first <= uid <= last] if last >= first else []
    if new:
        uids.reverse()
    remaining = len(uids) > BATCH_SIZE
    uids = uids[:BATCH_SIZE]
    items = fields(client, ",".join(map(str, uids)), uid=True, preview=True) if uids else []
    if new:
        if remaining:
            last = uids[-1]
        previous_next = last + 1
    elif remaining:
        first = uids[-1]
    elif not scanning and uids:
        first = uids[-1]
    if not new and scanning:
        before = first if first > 1 else 0
    unread = search_uids(client, ["UNSEEN", "UNDELETED"]) if request.get("folder") == "inbox" else None
    return {"uidValidity": validity, "nextUid": previous_next, "scanBefore": before,
            "scanCompleted": scanning and not new and not before, "range": [first, last],
            "uids": uids, "items": items, "unread": len(unread) if unread is not None else None,
            "more": bool(before) or previous_next < next_uid}
def copy_uid(client, uid):
    _, values = client.response("COPYUID")
    for value in values or ():
        if value:
            match = re.fullmatch(rb"(\d+) (\d+) (\d+)", value.strip())
            if match and int(match.group(2)) == uid:
                return {"validity": int(match.group(1)), "uid": int(match.group(3))}
    return None
def move_message(client, request, folder, can_move, can_copy):
    uid = request["uid"]
    destination = "inbox" if folder == "trash" else "trash"
    target = quoted(resolve_folder(client, destination, request))
    copy = request.get("pendingCopy")
    if can_move and not copy:
        imaplib.Commands.setdefault("MOVE", ("SELECTED",))
        checked(client.uid("MOVE", str(uid), target))
        return {"saved": True, "folder": destination, "copy": copy_uid(client, uid)}
    if not copy:
        checked(client.uid("COPY", str(uid), target))
        copy = copy_uid(client, uid) or {"copied": True}
    try:
        checked(client.uid("STORE", str(uid), "+FLAGS.SILENT", r"(\Deleted)"))
        if can_copy:
            checked(client.uid("EXPUNGE", str(uid)))
    except (MailError, OSError, imaplib.IMAP4.error):
        return {"saved": False, "folder": destination, "copy": copy}
    return {"saved": True, "folder": destination, "copy": copy}
def operate(client, request):
    action = request["action"]
    if action == "sent-folder":
        return {"folder": display_folder(resolve_folder(client, "sent", request))}, None
    folder = request.get("folder", "inbox")
    if action == "delete" and folder != "trash":
        raise MailError("folder")
    target = resolve_folder(client, folder, request)
    checked(client.select("INBOX" if folder == "inbox" else quoted(target), readonly=action not in ("flags", "move", "delete")))
    validity = response_number(client, "UIDVALIDITY")
    next_uid = response_number(client, "UIDNEXT")
    base = {"uidValidity": validity, "uidNext": next_uid}
    capabilities = {cap.decode("ascii") if isinstance(cap, bytes) else cap for cap in getattr(client, "capabilities", ())}
    if ((action in ("message", "move", "sync") and not capabilities.intersection({"MOVE", "UIDPLUS"}))
            or (action == "delete" and "UIDPLUS" not in capabilities)):
        status, values = client.capability()
        if status == "OK":
            capabilities.update(cap for value in values if value for cap in value.decode("ascii", "ignore").upper().split())
    can_move = "MOVE" in capabilities
    can_copy = "UIDPLUS" in capabilities
    if action == "sync":
        return dict(sync_folder(client, request, validity, next_uid), canMove=can_move or can_copy), None
    if action == "poll":
        cursor = request["nextUid"]
        items = []
        if request["validity"] == validity and 0 < cursor < next_uid:
            found = checked(client.uid("SEARCH", None, "UID", "{}:{}".format(cursor, next_uid - 1)))
            uids = sorted({int(uid) for uid in (found[0] or b"").split() if uid.isdigit() and cursor <= int(uid) < next_uid})
            batch = uids[:BATCH_SIZE]
            if batch:
                items = fields(client, ",".join(map(str, batch)), uid=True)
                if len(uids) > BATCH_SIZE:
                    base["uidNext"] = batch[-1] + 1
        unread = len(search_uids(client, ["UNSEEN", "UNDELETED"]))
        return dict(base, items=items, more=base["uidNext"] < next_uid, unread=unread), None
    if action == "bodies":
        if request["validity"] != validity:
            raise MailError("changed")
        items = []
        for uid in request["uids"]:
            try:
                content, _ = read_message(client, uid)
                items.append(content)
            except MailError as error:
                if str(error) not in ("size", "missing"):
                    raise
                items.append({"uid": uid, "skipped": True})
        return {"items": items}, None
    if action not in ("message", "attachment", "flags", "move", "delete"):
        raise MailError("upstream")
    if request["validity"] != validity:
        raise MailError("changed")
    if action == "delete":
        if not can_copy:
            raise MailError("delete_unsupported")
        message_uid = request["uid"]
        uid = str(message_uid)
        if message_uid in search_uids(client, ["UID", uid]):
            checked(client.uid("STORE", uid, "+FLAGS.SILENT", r"(\Deleted)"))
            checked(client.uid("EXPUNGE", uid))
            if message_uid in search_uids(client, ["UID", uid]):
                raise MailError("delete_incomplete")
        return {"saved": True}, None
    if action in ("flags", "move"):
        uid = str(request["uid"])
        if action == "move":
            pending = request.get("pendingCopy")
            criteria = ["UID", uid] if pending else ["UID", uid, "UNDELETED"]
            if request["uid"] not in search_uids(client, criteria):
                if pending:
                    return {"saved": True, "folder": "inbox" if folder == "trash" else "trash", "copy": pending}, None
                raise MailError("missing")
            return move_message(client, request, folder, can_move, can_copy), None
        if not fields(client, uid, uid=True):
            raise MailError("missing")
        flag = MAIL_FLAGS.get(request["flag"])
        if not flag or not isinstance(request["value"], bool):
            raise MailError("upstream")
        mode = "+FLAGS.SILENT" if request["value"] else "-FLAGS.SILENT"
        checked(client.uid("STORE", uid, mode, "(" + flag + ")"))
        return {"saved": True}, None
    result, binary = read_message(client, request["uid"], request.get("part"))
    if action == "message":
        result["canMove"] = can_move or can_copy
    return result, binary
def main():
    socket.setdefaulttimeout(7)
    if hasattr(signal, "SIGALRM"):
        signal.signal(signal.SIGALRM, lambda *_: timeout())
        signal.alarm(35)
    if len(sys.argv) == 3 and sys.argv[1] in ("--check", "--probe"):
        if sys.version_info < (3, 6):
            sys.exit(1)
        try:
            context = ssl.create_default_context(cafile=sys.argv[2])
        except OSError:
            print("IMAP TLS: PEM не удалось прочитать или разобрать.", file=sys.stderr)
            sys.exit(1)
        if sys.argv[1] == "--probe":
            try:
                with socket.create_connection((HOST, 993), timeout=7) as transport:
                    with context.wrap_socket(transport, server_hostname=HOST) as tls:
                        print("IMAP {}:993 / {} / Verification: OK".format(HOST, tls.version()))
            except ssl.SSLError as error:
                code = getattr(error, "verify_code", None)
                reason = getattr(error, "reason", None)
                message = "проверка сертификата не пройдена" if code is not None else "не удалось согласовать защищённое соединение"
                print("IMAP TLS: {} ({}).".format(message, code if code is not None else reason or "SSL"), file=sys.stderr)
                sys.exit(1)
            except (OSError, MailError) as error:
                print("IMAP {}:993 недоступен ({}, код {}).".format(HOST, type(error).__name__, getattr(error, "errno", None)), file=sys.stderr)
                sys.exit(1)
        return
    request = json.load(sys.stdin)
    login = request["login"]
    if not re.fullmatch(r"[A-Za-z0-9._-]{1,64}", login):
        raise MailError("auth")
    try:
        context = ssl.create_default_context(cafile=request.get("caFile") or None)
    except (OSError, ssl.SSLError):
        raise MailError("ca")
    client = imaplib.IMAP4_SSL(HOST, 993, ssl_context=context)
    try:
        secret = ("\0" + login + "\0" + request["password"]).encode("utf-8")
        try:
            client.authenticate("PLAIN", lambda _: secret)
        except imaplib.IMAP4.abort:
            raise
        except imaplib.IMAP4.error as error:
            if re.search(r"authenticationfailed|authenticate failed|logon failure|invalid credentials|authentication failed", str(error), re.I):
                raise MailError("auth")
            raise MailError("upstream")
        result, binary = operate(client, request)
        sys.stdout.buffer.write((json.dumps({"data": result}, ensure_ascii=False) + "\n").encode("utf-8", "replace"))
        if binary is not None:
            sys.stdout.buffer.write(binary)
    finally:
        try:
            client.logout()
        except (imaplib.IMAP4.error, OSError, MailError):
            pass
def timeout():
    raise MailError("network")
if __name__ == "__main__":
    try:
        main()
    except MailError as error:
        print(json.dumps({"error": str(error)}))
    except ssl.SSLError:
        print('{"error":"tls"}')
    except OSError:
        print('{"error":"network"}')
    except (ValueError, KeyError, TypeError, imaplib.IMAP4.error):
        print('{"error":"upstream"}')
