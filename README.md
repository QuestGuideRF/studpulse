# StudPulse

**Создатель — Домнин Вячеслав Игоревич, студент МЭИ, группа ЭЛ-03-26.**

<a href="https://studpulse.ru/"><img src="public/icons/icon-192.png" alt="StudPulse" width="104" height="104"></a>

StudPulse собирает расписание, оценки, пропуски и почту МЭИ в одном студенческом кабинете. На телефоне можно узнать, где следующая пара, открыть задание, свериться с картой или отметиться по QR. Для старосты и заместителя есть журнал, который сверяет пары с расписанием и сохраняет подтверждённые правки в БАРС. [studpulse.ru](https://studpulse.ru/)

## Содержание

[Скриншоты](#скриншоты)

1. [Возможности для студента](#возможности-для-студента)
2. [Журнал старосты и заместителя](#журнал-старосты-и-заместителя)
3. [Архитектура и стек](#архитектура-и-стек)
4. [Структура проекта](#структура-проекта)
5. [Установка с нуля](#установка-с-нуля)
6. [Конфигурация `.env`](#конфигурация-env)
7. [БАРС: устройство интеграции](#барс-устройство-интеграции)
8. [БАРС: HTTP-запросы и журнал](#барс-http-запросы-и-журнал) · [QR-отметка](#qr-отметка)
9. [Расписание РУЗ и подгруппы](#расписание-руз-и-подгруппы)
10. [Библиотека, Google Drive и резервные копии](#библиотека-google-drive-и-резервные-копии)
11. [Почта МЭИ](#почта-мэи)
12. [Планировщик, Push и офлайн](#планировщик-push-и-офлайн)
13. [API и правила запросов](#api-и-правила-запросов)
14. [Данные, права доступа и безопасность](#данные-права-доступа-и-безопасность)
15. [Обновление, резервирование и восстановление](#обновление-резервирование-и-восстановление)
16. [Диагностика и частые проблемы](#диагностика-и-частые-проблемы)
17. [Проверки и ограничения](#проверки-и-ограничения)

---

## Скриншоты

На снимках — интерфейс StudPulse с демонстрационными данными. Мобильные кадры сняты в размере iPhone 16 (393 × 852 CSS-пикселя). Нажми на снимок, чтобы открыть его в полном размере.

<table>
  <thead><tr><th>Компьютер · расписание на неделю</th><th>Телефон · расписание на день</th></tr></thead>
  <tbody><tr>
    <td valign="top"><a href="image/schedule-week-desktop.webp"><img src="image/schedule-week-desktop.webp" alt="Недельное расписание StudPulse на компьютере" width="630"></a></td>
    <td valign="top"><a href="image/schedule-day-mobile.webp"><img src="image/schedule-day-mobile.webp" alt="Расписание StudPulse на день при ширине iPhone 16" width="194"></a></td>
  </tr></tbody>
</table>

<details>
<summary>Расписание, БАРС и учёба</summary>

<table>
  <thead><tr><th>Экран</th><th>Компьютер</th><th>Телефон</th></tr></thead>
  <tbody>
    <tr><th scope="row">Расписание на день</th><td><a href="image/schedule-day-desktop.webp"><img src="image/schedule-day-desktop.webp" alt="Расписание на день на компьютере" width="360"></a></td><td><a href="image/schedule-day-mobile.webp"><img src="image/schedule-day-mobile.webp" alt="Расписание на день на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Расписание на неделю</th><td><a href="image/schedule-week-desktop.webp"><img src="image/schedule-week-desktop.webp" alt="Расписание на неделю на компьютере" width="360"></a></td><td><a href="image/schedule-week-mobile.webp"><img src="image/schedule-week-mobile.webp" alt="Расписание на неделю на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Оценки</th><td><a href="image/grades-desktop.webp"><img src="image/grades-desktop.webp" alt="Оценки на компьютере" width="360"></a></td><td><a href="image/grades-mobile.webp"><img src="image/grades-mobile.webp" alt="Оценки на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Контрольные мероприятия по предмету</th><td><a href="image/grade-details-desktop.webp"><img src="image/grade-details-desktop.webp" alt="Контрольные мероприятия по предмету на компьютере" width="360"></a></td><td><a href="image/grade-details-mobile.webp"><img src="image/grade-details-mobile.webp" alt="Контрольные мероприятия по предмету на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Пропуски</th><td><a href="image/attendance-desktop.webp"><img src="image/attendance-desktop.webp" alt="Пропуски на компьютере" width="360"></a></td><td><a href="image/attendance-mobile.webp"><img src="image/attendance-mobile.webp" alt="Пропуски на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Отметка по QR</th><td><a href="image/qr-desktop.webp"><img src="image/qr-desktop.webp" alt="Отметка по QR на компьютере" width="360"></a></td><td><a href="image/qr-mobile.webp"><img src="image/qr-mobile.webp" alt="Отметка по QR на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Кабинет БАРС</th><td><a href="image/bars-desktop.webp"><img src="image/bars-desktop.webp" alt="Кабинет БАРС на компьютере" width="360"></a></td><td><a href="image/bars-mobile.webp"><img src="image/bars-mobile.webp" alt="Кабинет БАРС на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Карточка предмета</th><td><a href="image/subjects-desktop.webp"><img src="image/subjects-desktop.webp" alt="Карточка предмета на компьютере" width="360"></a></td><td><a href="image/subjects-mobile.webp"><img src="image/subjects-mobile.webp" alt="Карточка предмета на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Домашние задания</th><td><a href="image/homework-desktop.webp"><img src="image/homework-desktop.webp" alt="Домашние задания на компьютере" width="360"></a></td><td><a href="image/homework-mobile.webp"><img src="image/homework-mobile.webp" alt="Домашние задания на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Карточка задания</th><td><a href="image/homework-details-desktop.webp"><img src="image/homework-details-desktop.webp" alt="Карточка задания на компьютере" width="360"></a></td><td><a href="image/homework-details-mobile.webp"><img src="image/homework-details-mobile.webp" alt="Карточка задания на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Журнал старосты</th><td><a href="image/headman-desktop.webp"><img src="image/headman-desktop.webp" alt="Журнал старосты на компьютере" width="360"></a></td><td><a href="image/headman-mobile.webp"><img src="image/headman-mobile.webp" alt="Журнал старосты на телефоне" width="150"></a></td></tr>
  </tbody>
</table>

</details>

<details>
<summary>Кампус, библиотека и заметки</summary>

<table>
  <thead><tr><th>Экран</th><th>Компьютер</th><th>Телефон</th></tr></thead>
  <tbody>
    <tr><th scope="row">Карта кампуса</th><td><a href="image/map-desktop.webp"><img src="image/map-desktop.webp" alt="Карта кампуса на компьютере" width="360"></a></td><td><a href="image/map-mobile.webp"><img src="image/map-mobile.webp" alt="Карта кампуса на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Карточка аудитории</th><td><a href="image/rooms-desktop.webp"><img src="image/rooms-desktop.webp" alt="Карточка аудитории на компьютере" width="360"></a></td><td><a href="image/rooms-mobile.webp"><img src="image/rooms-mobile.webp" alt="Карточка аудитории на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Карточка преподавателя</th><td><a href="image/teachers-desktop.webp"><img src="image/teachers-desktop.webp" alt="Карточка преподавателя на компьютере" width="360"></a></td><td><a href="image/teachers-mobile.webp"><img src="image/teachers-mobile.webp" alt="Карточка преподавателя на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Библиотека</th><td><a href="image/library-desktop.webp"><img src="image/library-desktop.webp" alt="Библиотека на компьютере" width="360"></a></td><td><a href="image/library-mobile.webp"><img src="image/library-mobile.webp" alt="Библиотека на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Папка библиотеки</th><td><a href="image/library-folder-desktop.webp"><img src="image/library-folder-desktop.webp" alt="Папка библиотеки на компьютере" width="360"></a></td><td><a href="image/library-folder-mobile.webp"><img src="image/library-folder-mobile.webp" alt="Папка библиотеки на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Карточка материала</th><td><a href="image/materials-desktop.webp"><img src="image/materials-desktop.webp" alt="Карточка материала на компьютере" width="360"></a></td><td><a href="image/materials-mobile.webp"><img src="image/materials-mobile.webp" alt="Карточка материала на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Мои заметки</th><td><a href="image/notes-desktop.webp"><img src="image/notes-desktop.webp" alt="Мои заметки на компьютере" width="360"></a></td><td><a href="image/notes-mobile.webp"><img src="image/notes-mobile.webp" alt="Мои заметки на телефоне" width="150"></a></td></tr>
  </tbody>
</table>

</details>

<details>
<summary>Почта и уведомления</summary>

<table>
  <thead><tr><th>Экран</th><th>Компьютер</th><th>Телефон</th></tr></thead>
  <tbody>
    <tr><th scope="row">Входящие</th><td><a href="image/mail-desktop.webp"><img src="image/mail-desktop.webp" alt="Входящие на компьютере" width="360"></a></td><td><a href="image/mail-mobile.webp"><img src="image/mail-mobile.webp" alt="Входящие на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Отправленные</th><td><a href="image/mail-sent-desktop.webp"><img src="image/mail-sent-desktop.webp" alt="Отправленные на компьютере" width="360"></a></td><td><a href="image/mail-sent-mobile.webp"><img src="image/mail-sent-mobile.webp" alt="Отправленные на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Черновики</th><td><a href="image/mail-drafts-desktop.webp"><img src="image/mail-drafts-desktop.webp" alt="Черновики на компьютере" width="360"></a></td><td><a href="image/mail-drafts-mobile.webp"><img src="image/mail-drafts-mobile.webp" alt="Черновики на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Корзина</th><td><a href="image/mail-trash-desktop.webp"><img src="image/mail-trash-desktop.webp" alt="Корзина на компьютере" width="360"></a></td><td><a href="image/mail-trash-mobile.webp"><img src="image/mail-trash-mobile.webp" alt="Корзина на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Открытое письмо</th><td><a href="image/mail-letter-desktop.webp"><img src="image/mail-letter-desktop.webp" alt="Открытое письмо на компьютере" width="360"></a></td><td><a href="image/mail-letter-mobile.webp"><img src="image/mail-letter-mobile.webp" alt="Открытое письмо на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Новое письмо</th><td><a href="image/mail-compose-desktop.webp"><img src="image/mail-compose-desktop.webp" alt="Новое письмо на компьютере" width="360"></a></td><td><a href="image/mail-compose-mobile.webp"><img src="image/mail-compose-mobile.webp" alt="Новое письмо на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Уведомления</th><td><a href="image/notifications-desktop.webp"><img src="image/notifications-desktop.webp" alt="Уведомления на компьютере" width="360"></a></td><td><a href="image/notifications-mobile.webp"><img src="image/notifications-mobile.webp" alt="Уведомления на телефоне" width="150"></a></td></tr>
  </tbody>
</table>

</details>

<details>
<summary>Рейтинг и достижения</summary>

<table>
  <thead><tr><th>Экран</th><th>Компьютер</th><th>Телефон</th></tr></thead>
  <tbody>
    <tr><th scope="row">Рейтинг БАРС</th><td><a href="image/rating-bars-desktop.webp"><img src="image/rating-bars-desktop.webp" alt="Рейтинг БАРС на компьютере" width="360"></a></td><td><a href="image/rating-bars-mobile.webp"><img src="image/rating-bars-mobile.webp" alt="Рейтинг БАРС на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Рейтинг группы</th><td><a href="image/rating-group-desktop.webp"><img src="image/rating-group-desktop.webp" alt="Рейтинг группы на компьютере" width="360"></a></td><td><a href="image/rating-group-mobile.webp"><img src="image/rating-group-mobile.webp" alt="Рейтинг группы на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Карточка участника</th><td><a href="image/rating-student-desktop.webp"><img src="image/rating-student-desktop.webp" alt="Карточка участника на компьютере" width="360"></a></td><td><a href="image/rating-student-mobile.webp"><img src="image/rating-student-mobile.webp" alt="Карточка участника на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Достижения</th><td><a href="image/achievements-desktop.webp"><img src="image/achievements-desktop.webp" alt="Достижения на компьютере" width="360"></a></td><td><a href="image/achievements-mobile.webp"><img src="image/achievements-mobile.webp" alt="Достижения на телефоне" width="150"></a></td></tr>
  </tbody>
</table>

</details>

<details>
<summary>Вход, настройки и офлайн</summary>

<table>
  <thead><tr><th>Экран</th><th>Компьютер</th><th>Телефон</th></tr></thead>
  <tbody>
    <tr><th scope="row">Вход</th><td><a href="image/login-desktop.webp"><img src="image/login-desktop.webp" alt="Вход на компьютере" width="360"></a></td><td><a href="image/login-mobile.webp"><img src="image/login-mobile.webp" alt="Вход на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Настройки</th><td><a href="image/settings-desktop.webp"><img src="image/settings-desktop.webp" alt="Настройки на компьютере" width="360"></a></td><td><a href="image/settings-mobile.webp"><img src="image/settings-mobile.webp" alt="Настройки на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Офлайн-режим</th><td><a href="image/offline-desktop.webp"><img src="image/offline-desktop.webp" alt="Офлайн-режим на компьютере" width="360"></a></td><td><a href="image/offline-mobile.webp"><img src="image/offline-mobile.webp" alt="Офлайн-режим на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Конфиденциальность</th><td><a href="image/privacy-desktop.webp"><img src="image/privacy-desktop.webp" alt="Конфиденциальность на компьютере" width="360"></a></td><td><a href="image/privacy-mobile.webp"><img src="image/privacy-mobile.webp" alt="Конфиденциальность на телефоне" width="150"></a></td></tr>
    <tr><th scope="row">Правила использования</th><td><a href="image/terms-desktop.webp"><img src="image/terms-desktop.webp" alt="Правила использования на компьютере" width="360"></a></td><td><a href="image/terms-mobile.webp"><img src="image/terms-mobile.webp" alt="Правила использования на телефоне" width="150"></a></td></tr>
  </tbody>
</table>

</details>

## Возможности для студента

При первом заходе StudPulse открывает страницу входа. После успешного входа и при повторном открытии главной страницы с действующей сессией открывается расписание. Прямая ссылка на защищённый раздел открывает этот раздел, пока сессия действует. [Веб-маршруты](public/index.php)

| Раздел | Что делает | Источник / условия |
|---|---|---|
| **Расписание** (`/schedule`) | Пары по датам, тип занятия, время, преподаватель, аудитория, учебная неделя, ссылки на материалы. | РУЗ МЭИ (`ts.mpei.ru`); группа берётся из подтверждённого профиля. |
| **Подгруппы** | Выбор своих занятий среди параллельных групп, в том числе для английского, физики и инженерной графики. | Настройки пользователя, данные РУЗ; доступность зависит от названий и разметки занятий. |
| **Оценки** (`/grades`) | Нажмите на предмет, чтобы открыть оценки за контрольные мероприятия (КМ), текущий балл и результаты промежуточной аттестации (ПА), которые передал БАРС. | Действующая университетская сессия. |
| **Кабинет БАРС** (`/bars`) | Доступные категории личного кабинета: сводки, ведомости, рейтинг, посещаемость и другие ссылки, реально обнаруженные у конкретного пользователя. | Серверный адаптер БАРС; часть разделов может отсутствовать в университетском аккаунте. |
| **Пропуски** (`/attendance`) | Сводка пропусков и таблицы посещаемости; при невозможности разобрать итоговые колонки допускается показ исходных информационных блоков. | БАРС; формат страниц меняется со стороны источника. |
| **Рейтинг** (`/rating`) | Личный рейтинг БАРС, рейтинг группы и достижения. Нажатие на участника открывает карточку. | Видимость оценок и пропусков выбирает участник. Полученные значки видят одногруппники. |
| **Домашние задания** (`/homework`) | Создание, редактирование, сроки, отметки выполнения, комментарии, примеры и вложения. | Локальная MySQL и частично групповая область доступа. |
| **Заметки** (`/notes`) | Личные заметки, прикреплённые файлы, связь с материалами, возможность поделиться заметкой. | Локальное хранилище и MySQL; правила видимости проверяет сервер. |
| **Библиотека** (`/library`) | Материалы по предметам и занятиям, личные/групповые записи, файлы, предпросмотр и скачивание, привязка к парам. | MySQL + приватное файловое хранилище; для копий и синхронизации — Google Drive. |
| **Кампус** (`/map`) | Карта в 2D и 3D, корпуса, общежития, кафедры, спорт и столовые. Кнопка «Карта» есть в расписании. | MapLibre, OpenFreeMap и каталог `config/campus.php`. |
| **Почта МЭИ** (`/mail`) | Входящие, отправленные, корзина, черновики, поиск и вложения. Кнопка «Прочитать всё» отмечает письма открытой папки. | Включённая на сервере почта и обычный вход в StudPulse учётной записью БАРС. |
| **Уведомления** (`/notifications`) | Напоминания о заданиях, обновления БАРС, сообщения группы, прочтение/удаление, Web Push. | MySQL + PHP CLI worker и браузерная подписка Push. |
| **Настройки** (`/settings`) | Оформление, порядок меню, подгруппы, категории уведомлений, сессии, токены, Google Drive, экспорт и удаление аккаунта. | Для экспорта и удаления нужна свежая браузерная сессия. |

**Интерфейс.** Светлая, тёмная и системная темы, акцентные цвета, неоновый режим, мобильная навигация и PWA.

**Календарь.** Расписание доступно как `.ics` (`GET /api/v1/calendar.ics`), а в API есть создание и отзыв отдельных ссылок календарной подписки. Ссылки подписки следует считать секретными.

**Карта.** Точки с координатами отображаются на карте. Адреса и категории хранятся в config/campus.php.

### Почта МЭИ и рейтинг группы

- **Почта МЭИ** открывается по адресу /mail. При включённой интеграции она подключается во время обычного входа через БАРС. Есть входящие, отправленные, корзина, черновики и вложения. Кнопка **«Прочитать всё»** ставит отметку прочтения письмам открытой папки Exchange, включая сообщения на других страницах списка. Кнопка **«Ответить с цитатой»** заполняет получателя и тему и добавляет текст исходного сообщения. Ответ можно сохранить как черновик.
- **Новое письмо** отображается в верхней плашке с отправителем и темой. Нажатие открывает письмо. Счётчик непрочитанных виден во входящих и в профиле БАРС. Значок установленного приложения обновляется на устройствах с поддержкой Badging API.
- **Рейтинг группы** берёт состав и оценки из БАРС. Староста или заместитель может нажать **«Обновить ведомость»**, чтобы подтянуть данные и увидеть оценки студентов без аккаунта StudPulse.
- Откройте карточку одногруппника, чтобы посмотреть его значки за семестр. «Мастер пересдач», «Камбэк» и остальные достижения видны всем участникам группы. В своей карточке можно скрыть оценки и детали пропусков.
- Крылья отмечают первое место, купюры — второе, алмазная кирка — третье. Эти знаки видны в списке участников и в профиле при любой теме, в том числе в режиме «Неон».
- В карточке участника графики показывают пропуски без уважительной причины по дисциплинам. Ниже видны все доступные оценки по предметам. Для оценок доступны текущий балл, промежуточная аттестация, итог и контрольные мероприятия. Видимость зависит от настроек участника и прав просмотра ведомости.
- Во вкладке **«Достижения»** есть 29 значков с условиями получения и прогрессом. «Уважаемый» выдаётся с 21 подтверждённого пропуска по уважительной причине за семестр. Новое достижение создаёт уведомление, если включена категория **«Новые оценки, пропуски БАРС и достижения»**. Push открывает эту вкладку. Рейтинг поддерживает неоновые акценты выбранного цвета.
- **QR-отметка.** Нажмите **«QR»** в расписании, разрешите доступ к камере и наведите её на код преподавателя. Требуется действующая сессия БАРС. После подтверждения карточка показывает время регистрации и другие сведения, которые вернул БАРС. [QR-отметка](#qr-отметка)

Исходники [почта](app/Http/MpeiMailController.php), [уведомления](app/Http/NotificationController.php), [отчёт группы](app/Domain/GroupRatingReport.php), [QR](app/Bars/BarsQr.php).

### Типовые сценарии

**Перед парой.** Откройте расписание, найдите аудиторию и преподавателя, нажмите **«Материалы»** у нужного занятия. С подтверждённой группой сервер проверяет доступ к семестру и подгруппе. При отсутствии подтверждённого членства запрос материалов требует подключения Google Drive с разрешением `drive.file` или `drive`. После этого проверьте задания в разделе **«Домашние задания»**. [Проверки материалов](app/Http/MaterialsController.php) · [Разрешения Drive](app/Integrations/DriveLibrary.php)

**После занятия:** отметить выполненное задание → загрузить конспект в библиотеку (если есть права) → при необходимости подключить Google Drive для копирования/синхронизации.

**Когда обновились оценки или пропуски.** Откройте соответствующий раздел и посмотрите, когда StudPulse получил сведения. Если данные расходятся, сверьтесь с кабинетом БАРС.

## Журнал старосты и заместителя

`/headman` — рабочее место пользователей, чьи **реальные** полномочия в журнале своей группы подтверждаются университетской сессией БАРС. Одного выбора роли в настройках или знания номера группы недостаточно. Сервер сверяет пользователя, журнал, группу и учебный период.

В разделе доступны локальные черновики и операции с университетским журналом.

- **Локальные записи StudPulse:** список занятий группы, черновики расписания и посещаемости, объявления, материалы и проверки прав (`HeadmanController`, таблицы `headman_*`, `class_meetings`). Они не становятся официальной записью БАРС только из-за сохранения в MySQL.
- **Прямая работа с журналом БАРС:** получение пар и списков студентов, открытие формы, создание/редактирование доступной пары, сохранение отсутствующих, сравнение с РУЗ, перенос недостающих занятий и удаление при наличии соответствующего действия в БАРС (`BarsJournalController`, `BarsTrainingJournal`).

Доступные операции зависят от содержимого университетской формы и состояния занятия (например, согласованные/закрытые занятия не должны произвольно изменяться). При создании занятия выбираются лист, время, вид занятия, преподаватель и тема; идентификаторы берутся из **текущих допустимых вариантов формы БАРС**, а не из свободно введённых значений.

**Сценарий старосты.** Откройте **«Журнал»** и нажмите **«Проверить»**. Сверка показывает недостающие пары и расхождения по преподавателям у редактируемых занятий. Кнопка **«Исправить всё»** обрабатывает список расхождений, если преподавателя из РУЗ удаётся однозначно сопоставить с записью БАРС. Закрытые занятия и предусмотренные для отдельных дисциплин отметки «Не определена» или «Вакансия» исключаются. [Сверка расписания](app/Bars/BarsJournalSchedule.php) · [Экран журнала](public/assets/js/journal-period.js)

**Синхронизация.** Выберите период кнопкой **«Синхронизировать»**. Для каждой пары сервер проверяет предмет, время, вид занятия и преподавателя. Он создаёт запись автоматически, если форма БАРС и подтверждённые отметки предыдущей пары дают все необходимые данные. Если требуется ручное заполнение, откройте нужную пару, проверьте поля и посещаемость, затем нажмите **«Сохранить в БАРС»**. [Перенос пары](app/Bars/BarsTrainingJournal.php) · [Форма занятия](public/assets/js/pages-journal-bars.js)

**Сохранение в БАРС:** HTTP-операция не считается успешной только потому, что сервер ответил `200`. Клиент проверяет JSON-признак успеха, адрес возврата именно к нужному журналу, а при неопределённом результате перечитывает журнал. Это защищает от ложного отображения сохранения. Одновременно реализация зависит от HTML/форм БАРС и должна проверяться на разрешённом тестовом сценарии.

**Объявления:** серверные маршруты публикации, редактирования и вложений предусмотрены; уведомления участников зависят от подтверждённого состава группы и их предпочтений.

## Архитектура и стек

- **Backend:** PHP **8.2+**, собственные контроллеры и маршрутизатор, PDO (`pdo_mysql`), MySQL **8.0.x**.
- **Frontend:** HTML, CSS, нативные ES-модули JavaScript. Нет обязательного Node.js-сервера для выполнения приложения.
- **Внешние сервисы:** БАРС, РУЗ, Exchange МЭИ, Google OAuth и Drive, службы доставки Web Push.
- **Фоновая обработка:** PHP CLI (`bin/cron.php`), Bash-обёртка с блокировкой и повторными проходами.
- **PWA/offline:** `manifest.webmanifest`, Service Worker, Cache Storage и IndexedDB для ограниченных локальных снимков.
- **Почта МЭИ.** PHP управляет сессиями, кешем, черновиками и отправкой. Python-модуль scripts/mpei-mail.py работает с Exchange через IMAP и проверяет TLS.

```mermaid
flowchart LR
    B[Браузер / PWA] -->|HTTPS, /api/v1| P[PHP: public/index.php + Router]
    P --> A[Auth / Access / Controllers]
    A --> D[(MySQL 8.0)]
    A --> F[Приватные файлы STORAGE_PATH]
    A --> C[БАРС, bars.mpei.ru]
    A --> R[РУЗ, ts.mpei.ru/api]
    A --> G[Google OAuth + Drive]
    A --> M[Python IMAP и отправка SMTP]
    W[PHP CLI: bin/cron.php] --> D
    W --> G
    W --> M
    W --> N[Web Push]
```

**Маршрут запроса:** `public/index.php` → `Request` → `Router` → аутентификация и scope → контроллер → доменная логика/адаптер → PDO или внешний сервис → JSON в формате `data`/`error`/`meta`. Фронтенд получает **данные**, а не доступ к университетским cookie на сервере.

Оценки, пропуски и полномочия для журнала приходят из БАРС. Расписание приходит из РУЗ. Задания, заметки и состояние интеграций хранятся в MySQL StudPulse.

## Структура проекта

```text
studpulse/
├── api/
│   ├── routes.php             # таблица API: метод, маршрут, scope, обработчик
│   └── openapi.php            # динамическое OpenAPI-описание
├── app/
│   ├── Bars/                  # клиент, HTML-парсеры, БАРС, журнал и статистика
│   ├── Database/              # PDO, сверка MySQL с database/schema.sql
│   ├── Domain/                # задания, библиотека, права, заметки, настройки
│   ├── Http/                  # контроллеры, маршрутизация, HTTP-ошибки
│   ├── Integrations/          # РУЗ, Drive, синхронизация, Web Push, SMTP
│   ├── Security/              # сессии, криптография, ограничения запросов
│   ├── views/                 # shell, страница 404
│   ├── Config.php             # чтение/валидация параметров окружения
│   └── bootstrap.php          # инициализация приложения
├── bin/
│   ├── preflight.php          # PHP/БД/закрытое хранилище
│   ├── cron.php               # один цикл фоновых задач
│   ├── maintenance.php        # очистка истёкших записей и файлов удалённых аккаунтов
│   ├── mpei-ca.php             # проверка цепочки сертификатов почты
│   ├── academic-setup.php     # административная настройка периода
│   └── verify-membership.php # подтверждение членства с основанием
├── config/campus.php         # каталог мест МЭИ
├── database/
│   ├── schema.sql             # схема MySQL
│   └── group-rating-upgrade.sql # обновление старой схемы рейтинга
├── public/
│   ├── index.php             # единственная HTTP-входная точка
│   ├── .htaccess             # Apache rewrite
│   ├── manifest.webmanifest
│   ├── service-worker.js
│   ├── offline-shell.html
│   ├── icons/                 # PNG и SVG для браузера и PWA
│   └── assets/                # CSS, JS, локальные зависимости
├── scripts/
│   ├── worker-php.sh         # выбор PHP CLI
│   ├── mpei-ca.sh             # подготовка сертификатов
│   └── mpei-mail.py           # операции IMAP через TLS
├── install.sh                # установка и команда для cron
├── setup-worker.sh           # проверка окружения и создание каталогов хранилища
├── grant-worker-permissions.sh
├── start-worker.sh           # один проход, непрерывный цикл, статус или остановка
├── stop-worker.sh            # корректная остановка worker
├── storage/                  # закрытые файлы и логи; НЕ webroot
├── composer.json
└── README.md
```

Основные точки входа собраны в [веб-маршрутизаторе](public/index.php), [таблице API](api/routes.php) и [планировщике](bin/cron.php). PHP читает настройки через [Config](app/Config.php), а установщик сверяет [схему MySQL](database/schema.sql) через [preflight](bin/preflight.php).

## Установка с нуля

### Требования

- Linux-хостинг с PHP **8.2+** для веба и CLI; PHP-модули: `pdo`, `pdo_mysql`, `mbstring`, `fileinfo`, `openssl`, `sodium`, `curl`, `zip`, `dom`, `json`.
- MySQL **8.0.x**, учётная запись БД с правами на все таблицы собственной базы.
- HTTPS и сертификат для публичного развёртывания.
- Веб-сервер Apache с rewrite или Nginx; **document root — `studpulse/public/`**, не корень репозитория.
- Для установки и запуска планировщика нужны Bash, `flock` и GNU `timeout`. Для почты добавьте `python3` с модулем `ssl` и разрешите `proc_open` для PHP.
- Достаточно дискового пространства для приватных оригиналов и импорта из Drive; реальное ограничение загрузки задаёт хостинг.

### 1. Разместить файлы и настроить веб-корень

Укажите `studpulse/public/` как корень сайта. Для Apache включите `mod_rewrite` и разрешите правила из [public/.htaccess](public/.htaccess). После настройки проверьте, что `/.env`, `/database/schema.sql` и `/storage/` недоступны по HTTP.

<details>
<summary>Пример для Nginx и PHP-FPM</summary>

Замените домен, путь к проекту, сертификаты и сокет PHP-FPM на значения своего сервера.

```nginx
server {
    listen 443 ssl;
    server_name studpulse.example.org;
    root /srv/studpulse/public;

    ssl_certificate /etc/ssl/studpulse/fullchain.pem;
    ssl_certificate_key /etc/ssl/studpulse/privkey.pem;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
        index index.php;
    }

    location = /index.php {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root/index.php;
        fastcgi_param HTTP_AUTHORIZATION $http_authorization;
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
    }

    location = /service-worker.js {
        add_header Cache-Control "no-cache, max-age=0, must-revalidate";
        try_files $uri =404;
    }

    location ~ /\. { return 404; }
    location ~ \.php(?:/|$) { return 404; }

    location ~ \.(?:mjs|webmanifest)$ {
        types {
            text/javascript mjs;
            application/manifest+json webmanifest;
        }
        try_files $uri =404;
    }

}
```

Для запроса через основной маршрутизатор используется `public/index.php`. Статические файлы отдаёт Nginx. Проверьте конфигурацию командой `nginx -t` перед перезагрузкой службы.

</details>

Для локальной разработки подходит встроенный PHP-сервер, но не используйте его для production:

```bash
cd studpulse
php -S 127.0.0.1:8080 -t public public/index.php
```

### 2. Создать базу MySQL

Создайте отдельную БД `studpulse` (или другое имя) с кодировкой `utf8mb4`, затем импортируйте **именно** файл `database/schema.sql` из того же архива:

```bash
mysql -h 127.0.0.1 -u studpulse_user -p studpulse < database/schema.sql
```

Имя базы/пользователя замените на свои. На хостинге можно импортировать схему через phpMyAdmin. Не импортируйте поверх действующей базы без резервной копии; `schema.sql` здесь — полная схема, а не набор миграций между версиями.

### 3. Подготовить конфигурацию

Создайте `.env` вручную в корне проекта по примеру из раздела [«Конфигурация .env»](#конфигурация-env). Укажите MySQL, адрес сайта и параметры используемых интеграций.

Генерация 32 случайных байт и их кодирование Base64 (запустить **дважды** — отдельно для каждого ключа):

```bash
php -r 'echo base64_encode(random_bytes(32)), PHP_EOL;'
```

Ограничьте доступ к `.env` командой `chmod 600 .env`.

### 4. Проверить совместимость и запустить сайт

```bash
php bin/preflight.php --php-only
bash install.sh
php bin/preflight.php
```

При успешной проверке появляются `StudPulse schema OK` и `Private storage OK`. `SSO BLOCKED_EXTERNAL; production readiness not certified` сообщает о статусе официального SSO. Вход через веб-интерфейс БАРС, получение расписания и доступ к Google Drive проверяются отдельно под вашей учётной записью.

### 5. Настроить внешние интеграции

Для входа через МЭИ установите `BARS_PROVIDER_MODE=official`. Для Google Drive зарегистрируйте OAuth Client ID и Client Secret и укажите точный адрес возврата, например `https://studpulse.example.org/auth/google/callback`. Для Push можно указать свою пару VAPID. При пустых переменных StudPulse создаёт ключ в `STORAGE_PATH/push/vapid.key`. Почта подключается во время следующего обычного входа через БАРС, если её включили на сервере. [Конфигурация почты](#почта-мэи)

### 6. Настроить планировщик

См. [«Планировщик, Push и офлайн»](#планировщик-push-и-офлайн). Для production обязательно выбрать **один** механизм периодического выполнения, чтобы не создавать конкурирующие циклы. Действующий worker не заменяет веб-сервер.

### 7. Контрольные проверки

1. `GET /health/live` возвращает `{"status":"alive"}` — **это только liveness**, не проверка БД/БАРС.
2. `GET /api/openapi.json` возвращает OpenAPI-спецификацию.
3. `/login` показывает форму БАРС в режиме `official`.
4. После входа `/schedule` получает пары именно из РУЗ, `/grades` и `/attendance` — из БАРС.
5. Задание/заметка создаётся и читается **с той же учётной записью**.
6. Файлы недоступны анонимно, а чужая группа не открывается без подтверждения членства.
7. Для старосты проверяется право в БАРС, а не только видимость кнопки.
8. `bash start-worker.sh --once` выполняет один проход в том же режиме, что и cron.
9. `GET /health/ready` доступен системному администратору. `database: "ready"` означает успешный запрос к MySQL. Значение `productionReady: false` задано в коде и ожидается даже при исправной базе. [Проверки состояния](public/index.php)

## Конфигурация `.env`

Пример локальной конфигурации с выключенными интеграциями. Создайте свой `.env` и заполните реквизиты подключения и ключи.

```dotenv
APP_ENV=development
APP_BASE_URL=http://127.0.0.1:8080
FRONTEND_ORIGIN=http://127.0.0.1:8080
DATABASE_URL=mysql://studpulse_user:CHANGE_ME@127.0.0.1:3306/studpulse
SESSION_SECRET=BASE64_OF_32_RANDOM_BYTES
TOKEN_ENCRYPTION_KEY=ANOTHER_BASE64_OF_32_RANDOM_BYTES
TOKEN_KEY_ID=key-1
SESSION_DAYS=30
SESSION_IDLE_DAYS=7
COOKIE_SAMESITE=Lax
BARS_PROVIDER_MODE=unavailable
STORAGE_PATH=storage
MPEI_MAIL_ENABLED=false
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GOOGLE_REDIRECT_URI=
WEB_PUSH_VAPID_PUBLIC_KEY=
WEB_PUSH_VAPID_PRIVATE_KEY=
```

В качестве `SESSION_SECRET` и `TOKEN_ENCRYPTION_KEY` вставьте **реальные, разные Base64-кодировки 32 случайных байт**, а не строки-заглушки; иначе валидация не пройдёт. Для **production** укажите `APP_ENV=production`, HTTPS в обоих origin и `BARS_PROVIDER_MODE=official`. Локальный режим `development`/`test` ограничен loopback-хостом и loopback-клиентом.

| Параметры | Назначение |
|---|---|
| `APP_ENV`, `APP_BASE_URL`, `FRONTEND_ORIGIN` | Режим приложения и разрешённый origin. |
| `DATABASE_URL` | DSN-подобный URL подключения к MySQL 8.0. Спецсимволы в логине/пароле должны кодироваться в URL. |
| `SESSION_SECRET`, `TOKEN_ENCRYPTION_KEY`, `TOKEN_KEY_ID` | CSRF/HMAC, шифрование university/Google-сессий и идентификатор ключа. Изменение ключей влияет на существующие подключения. |
| `SESSION_DAYS`, `SESSION_IDLE_DAYS` | Максимальная жизнь и idle-период сессии, допустимый диапазон каждого — 1–30 дней. |
| `BARS_PROVIDER_MODE` | `official` для БАРС, `unavailable` для запуска без БАРС. |
| `GOOGLE_CLIENT_*`, `GOOGLE_REDIRECT_URI` | OAuth 2.0 для Drive; без них подключение не работает. |
| `WEB_PUSH_VAPID_*` | Ключи доставки Web Push. |
| `STORAGE_PATH` | Приватные файлы, почтовые сертификаты и логи. Относительный путь считается от корня проекта. Можно указать абсолютный путь с пробелами. Каталог должен находиться за пределами `public/`. |
| `MPEI_MAIL_ENABLED`, `MPEI_MAIL_CA_FILE`, `MPEI_MAIL_PYTHON` | Включение почты, исходная цепочка сертификатов и команда Python. |
| `MPEI_MAIL_SENT_FOLDER`, `MPEI_MAIL_TRASH_FOLDER`, `MPEI_MAIL_SAVE_SENT` | При необходимости задают имена папок Exchange и управляют сохранением копии отправленного письма. |
| `STUDPULSE_NOTIFY_INTERVAL`, `PHP_CLI_PATH` | Переменные окружения shell для цикла и выбора PHP CLI. Передавайте их при запуске. |

На виртуальном хостинге REG.RU выберите PHP 8.2 или новее в настройках сайта, проверьте корень `public/` и создайте отдельную базу в панели. Установщик сначала пробует `/opt/php/8.2/bin/php`, затем ищет другие варианты. Если нужна конкретная версия, передайте `PHP_CLI_PATH` при запуске. Для регулярной работы используйте планировщик хостинга или `crontab`.

## БАРС: устройство интеграции

### Источники и ответственность

| Данные | Источник | Основные классы |
|---|---|---|
| Вход, 2FA, университетский профиль, группа | `bars.mpei.ru/bars_web/` | `BarsAuthController`, `BarsClient`, `BarsHtml` |
| Предметы, оценки, КМ, сводки | Авторизованные страницы БАРС | `BarsOfficialAdapter`, `BarsHtml`, `BarsSections` |
| Посещаемость/пропуски | Страницы БАРС, в том числе «Посещение занятий»/«Сводка» | `BarsOfficialAdapter`, `BarsStatistics`, `BarsSections` |
| QR-отметка | Страница подтверждения `QR/Presence/Confirm` | `StudyController`, `BarsOfficialAdapter`, `BarsClient`, `BarsQr` |
| Личный рейтинг | Доступные страницы рейтинга БАРС | `BarsOfficialAdapter`, `BarsStatistics` |
| Права и состав группы старосты | Разделы `SG/StudyGroup`/`SG/Student` БАРС | `BarsJournal`, `BarsClient`, `Auth` |
| Пары журнала, отсутствующие, изменения | Разделы `SG/TrainingJournal` и `SG/Lesson` БАРС | `BarsTrainingJournal`, `BarsLesson`, `BarsJournalController` |
| Расписание студентов/преподавателей | РУЗ (`ts.mpei.ru/api`), **не БАРС** | `MpeiSchedule`, `ScheduleSubgroups` |
| Задания, заметки, объявления, материалы | Собственная БД и файловое хранилище | Контроллеры `app/Http`, классы `app/Domain` |

### Последовательность входа

1. Пользователь вводит логин и пароль МЭИ на `/login`; браузер посылает JSON на `POST /api/v1/auth/bars/login` **своему** серверу StudPulse.
2. `BarsAuthController` проверяет формат, применяет rate limit, ищет допустимое восстановление прежней университетской сессии. При необходимости `BarsClient` выполняет вход в БАРС по HTTPS.
3. Если БАРС требует двухфакторное подтверждение, сервер создаёт связанный с браузером временный flow (`sp_bars_flow`, хеши и шифрованное состояние в `bars_auth_flows`, срок 10 минут). Пользователь выбирает канал/вводит код, браузер обращается к `/send-code` и `/code`.
4. БАРС возвращает доступные профили студента. При нескольких профилях вызывается `/profile` с идентификатором, предложенным БАРС. Нельзя выбирать произвольного пользователя/группу.
5. Сервер проверяет университетский профиль, создаёт или обновляет учётную запись StudPulse и связанную запись БАРС (`users`, `bars_accounts`, `provider_connections`). Сессионные данные источника находятся в зашифрованных `provider_credentials`, а не в JavaScript.
6. StudPulse выдаёт **собственную** браузерную сессию `sp_session` и CSRF-токен. Последующие запросы получают учебные данные через сервер StudPulse, а не напрямую из браузера к `bars.mpei.ru`.
7. Если адаптер обнаруживает форму входа или истёкшие учётные данные, StudPulse просит заново войти в БАРС. Команды выхода отзывают текущую браузерную сессию или все сессии в зависимости от выбранного действия.

`BarsClient` обращается к `bars.mpei.ru` через cURL и проверяет TLS-сертификат. Клиент ограничивает размер ответа и отклоняет перенаправления на другие домены. Cookie БАРС остаются на сервере. HTML разбирается через DOM/XPath, поэтому после изменения разметки может потребоваться обновить парсер.

### Поток чтения учебных данных

```mermaid
sequenceDiagram
    participant U as Студент
    participant F as StudPulse JS
    participant P as PHP / Auth
    participant C as BarsClient
    participant S as БАРС
    U->>F: Открывает «Оценки» / «Пропуски»
    F->>P: GET /api/v1/grades или /attendance
    P->>P: Проверка сессии и scope
    P->>P: Чтение разрешённого кеша
    opt Требуется обновить
        P->>C: Cookie БАРС из защищённого серверного хранилища
        C->>S: GET разрешённой страницы своего профиля
        S-->>C: HTML
        C-->>P: DOM и нормализованные поля
        P->>P: Сохранение снимка/времени наблюдения
    end
    P-->>F: JSON: данные + source/observedAt/stale
    F-->>U: Таблица/карточки и предупреждения
```

**Кеш.** `BarsOfficialAdapter::read()` хранит снимки в зашифрованном состоянии `provider_credentials`. Обычное чтение может использовать снимок до двух минут. При серверном сбое некоторые разделы возвращают снимок возрастом до суток с признаком `stale`. Записи журнала проверяются в действующей университетской сессии. [Адаптер БАРС](app/Bars/BarsOfficialAdapter.php)

**Пропуски.** `getAttendance()` сначала читает доступный раздел посещаемости, затем при отсутствии надёжной сводки может дополнительно обратиться к разделу `summary`. `BarsStatistics::attendance()` обрабатывает табличные блоки, признаки отсутствия и итоговые колонки. Если источник отдал таблицу, но парсер не распознал счётчики, UI не должен без доказательств показывать ноль пропусков: показывается исходная информация и/или предупреждение о недоступности агрегата.

**Личный рейтинг.** `getRating()` открывает «Учебный рейтинг» студента и при отсутствии раздела использует доступные блоки его ведомости. Групповой рейтинг читает ведомость и личные снимки. Полученные значки берутся из `group_rating_profiles.achievements_json` и входят в карточку одногруппника в обоих режимах видимости. [Сборка рейтинга](app/Domain/GroupRating.php)

**Ведомость группы.** По кнопке **«Обновить ведомость»** StudPulse проверяет права старосты или заместителя и полученный из БАРС состав группы. Затем он отправляет форму отчёта `POST /bars_web/R/StudyGroupControlWeekAndCurrentScoreBySemesterID/Main` как `multipart/form-data`, с полями `StudyGroupName` и `SemesterID`. Ссылку на временный XLSX из ответа сервер открывает по HTTPS через `GET /bars_web/WebDocGenerator/GetTemporaryFile` в той же сессии БАРС.

В XLSX названия предметов берутся из строки «Дисциплина». В MySQL сохраняются состав группы и разобранные оценки КН, текущий балл (ТБ) и итоговый балл (ИБ) для текущего семестра. Рейтинг и карточки участников читают сохранённые данные из `group_rating_reports`. Средний балл рассчитывается по заполненным ТБ. При сбое обновления сохраняются предыдущие оценки совпадающих участников. [Загрузка отчёта](app/Bars/BarsClient.php) · [Разбор](app/Bars/BarsGroupGradeReport.php) · [Хранение](app/Domain/GroupRatingReport.php)

**Посещаемость группы.** При том же обновлении StudPulse отправляет `POST /bars_web/R/StudyGroupAttendanceSheetBySemesterID/Main` с группой и семестром. В скачанном XLSX колонки «Проп., часов» и «Ув. пр., часов» показывают все пропущенные часы и часы по уважительной причине. StudPulse сверяет итоги с часами по дисциплинам и сопоставляет полные имена с текущим составом группы. В MySQL сводка хранится в `group_rating_reports.roster` рядом с оценками. При неудачном обновлении сохраняется последняя полученная сводка. В карточке участника используется более свежая сводка из ведомости или личного раздела БАРС с учётом видимости и прав на просмотр. [Разбор посещаемости](app/Bars/BarsGroupAttendanceReport.php)

**Права.** Роль старосты/заместителя и доступ к конкретному журналу устанавливаются по разделам `SG` и совпадению университетской сессии/профиля/группы/семестра. Локальное членство — отдельная сущность: его можно подтверждать административно только на основании проверяемого источника.

## БАРС: HTTP-запросы и журнал

StudPulse обращается к страницам и формам веб-интерфейса БАРС на `https://bars.mpei.ru`. Значения `studentID`, `sgID`, `tjID`, `asID` и `lesID` берутся из ответов текущей университетской сессии. Подтверждённого публичного контракта для этих запросов нет. [Клиент БАРС](app/Bars/BarsClient.php)

### Вход и студенческий кабинет

| Метод | Путь БАРС | Зачем вызывается | Обработка |
|---|---|---|---|
| `POST` | `/bars_web/` | Вход с `Account`, `Password`, `RememberMe` | JSON-запрос, HTML страницы входа/следующего шага, парсер `BarsHtml::authState`. |
| `GET` | `/bars_web/` | Определение состояния 2FA | HTML, поиск подтверждения и доступного канала. |
| `GET` | `/bars_web/Auth/JSON_SendAF2_Code?tid={provider}&_={timestamp}` | Запрос кода 2FA | JSON, ожидается `success === true`; значения provider ограничены `1`, `2`, `3`. |
| `POST` | `/bars_web/Auth/LoginCode` | Подтверждение одноразового кода: `Account`, `AF2_Code`, `RememberMe` | JSON-тело запроса, HTML-ответ, повторное определение статуса авторизации. |
| `GET` | `/bars_web/ST/Student/ListStudent` | Список доступных студенческих профилей | HTML, проверка сессии и выбранного профиля. |
| `GET` | `/bars_web/ST_Study/Main/Main?studentID={studentId}` | Главная учебная страница студента | HTML: профиль, навигация, ведомость/оценки, допустимые ссылки. |
| `GET` | Найденные ссылки разделов `/bars_web/ST...` с `studentID={studentId}` | «Сводка», «Посещение занятий», «Рейтинг» и другие пункты | `BarsSections::path()` проверяет адрес, путь и идентификатор профиля. Парсер собирает `blocks`, `links` и `ratings`. |
| `GET` | `/bars_web/ST_AdEd/AdEdProgram/ListAdEdProgram?studentID={studentId}` | Дополнительное образование | Ссылка на раздел, если страница доступна пользователю. |
| `GET` | `/bars_web/US_Q/QuestionnaireAnswer/ListQuestionnaireAnswer?ac=...` | Доступные анкеты | Формирование ссылки в `BarsOfficialAdapter`; наличие данных зависит от БАРС. |

Набор вкладок зависит от профиля. Сервер читает ссылки из текущего HTML, пропускает разрешённые маршруты и показывает найденные разделы в **«Кабинете БАРС»**. [Список правил](app/Bars/BarsSections.php)

### Проверка роли и доступ к журналу группы

| Метод | Путь БАРС | Использование |
|---|---|---|
| `GET` | `/bars_web/SG/StudyGroup/ListStudyGroup` | Найти доступную учебную группу по подтверждённому коду. |
| `GET` | `/bars_web/SG/StudyGroup/EditStudyGroup?sgID={group}` | Проверить старосту/ответственного за журнал в группе. |
| `GET` | `/bars_web/SG/TrainingJournal/ListStudyGroup__TrainingJournals?sgID={group}` | Получить журналы осеннего/весеннего семестра нужного академического года. |
| `GET` | `/bars_web/SG/TrainingJournal/EditTrainingJournal?tjID={journal}` | Убедиться, что у пользователя открыт журнал и вкладка занятий. |
| `GET` | `/bars_web/SG/Student/ListStudyGroup__Students?sgID={group}` | Состав группы для допустимых операций журнала. |

`BarsJournal::currentPeriod()`/`periods()` вычисляют учебный период; `BarsClient::journalAccess()` перепроверяет фактически открытый журнал. Доступ к одному URL не даёт права изменять другой семестр/группу.

### Занятия и посещаемость журнала

| Метод | Путь БАРС | Назначение |
|---|---|---|
| `GET` | `/bars_web/SG/Lesson/_PartialListTrainingJournal_Lessons?tjID={journal}&query={urlencoded JSON}` | Постраничное получение пар, фильтр дат, типы занятий и статусы; HTML таблицы. |
| `GET` | `/bars_web/SG/Lesson/CreateLesson?ownerID={journal}&uip=tj` | Получить форму создания и актуальные допустимые варианты полей. |
| `POST` | Тот же `CreateLesson` | Сохранить новую пару; `multipart/form-data`; проверка ответа и повторное чтение. |
| `GET` | `/bars_web/SG/Lesson/EditLesson?lesID={lesson}&uip=tj` | Открыть разрешённую форму изменения пары/отсутствующих. |
| `POST` | Тот же `EditLesson` | Сохранить изменения и отметки посещаемости. |
| `GET` | `/bars_web/SG/Lesson/DeleteLesson?lesID={lesson}&uip=tj` | Получить допустимое действие удаления и скрытые поля формы. |
| `POST` | Путь удаления, полученный из формы | Удалить пару, если БАРС разрешает действие. |
| `GET` | `/bars_web/SG/Lesson/JSON_AttendanceSheetLesson__StudentListInfo?asID={sheet}` | Список студентов и данные листа посещаемости в форме. |
| `GET` | `/bars_web/SG/Lesson/JSON_Lesson_Default?asID={sheet}&ltID={type}` | Значения формы по листу и типу занятия. |
| `GET` | `/bars_web/Journal/JSON/JSON_Employee?...` | Поиск допустимых преподавателей (параметры формируются обработчиком). |

Фильтр списка занятий формируется на сервере. Ниже пример значения параметра `query` до URL-кодирования.

```json
{
  "ID": "<journal id>",
  "State": null,
  "SortOrder": null,
  "Page": "",
  "PageSize": "100",
  "SearchText": "",
  "FilterStartDate": "09.11.2026",
  "FilterEndDate": "09.11.2026",
  "DisplayModeFilter": { "Value": "LIS_1;LIS_2;LIS_3;LT_1;LT_2;LT_3;LT_4;1;" }
}
```

Это демонстрация структуры, подтверждённой `BarsTrainingJournal::range()`; конкретный идентификатор, диапазон и размер страницы зависят от запроса (для многодневного списка может использоваться `PageSize=500`).

**Пример основных полей отправки занятия** (значения **только из текущей формы конкретного журнала**, идентификаторы ниже не являются готовыми значениями для реального сохранения):

```text
AttendanceSheetID                      = [разрешённый лист из формы]
Date                                   = DD.MM.YYYY
LessonTimeID                           = [разрешённое время]
LessonTypeID                           = [разрешённый вид занятия]
Theme                                  = [тема занятия]
Lesson_EmployeeID                      = [список выбранных ID преподавателей]
LessonInfoStatusID                     = [допустимый статус]
AttendanceSheetLessonStudentListSerialized = JSON со списком студентов/пропусков
+ скрытые поля, реально полученные из формы БАРС
```

`AttendanceSheetLessonStudentListSerialized` формируется с ключом `AttendanceSheetLessonStudents`; внутри по каждому листу находятся `AttendanceSheetID`, `Students`, `Show`, `Checked`; для студента — `StudentID` и, если он отсутствует, `LessonSkipReasonID`. Студенты сопоставляются с текущим roster, а не с произвольными ФИО. Закрытые занятия, неполные отметки и неподтверждённые ответы требуют ручной проверки.

**Заголовки и cookie (описание, не готовый запрос):** общий клиент указывает `Accept: text/html, application/json`, `Accept-Language: ru`, корректный `Referer` на `https://bars.mpei.ru/bars_web/...`; для AJAX-форм добавляет `X-Requested-With: XMLHttpRequest`, `Cache-Control: no-cache`. Для POST присутствуют `Origin: https://bars.mpei.ru` и `Content-Type: application/json` (вход) либо `multipart/form-data` (формы журнала). Upstream cookies хранятся и передаются через серверный cURL cookie jar **от имени вошедшего пользователя**. Нельзя копировать чужие `auth_bars`, `ses_bars`, anti-CSRF cookie или выводить их в документацию/логи.

**Ответы и ошибки:** HTML-пути проверяются на отсутствие редиректа к странице входа и на соответствие ожидаемому журналу; JSON-ответы чтения должны быть массивами/объектами допустимой формы. POST сохранения должен дать `success: true` и корректный `url` с нужным `tjID`; если нет уверенности, возвращается ошибка типа `BARS_WRITE_UNCONFIRMED` или `BARS_DELETE_UNCONFIRMED` — после чего следует открыть официальный журнал и проверить результат **до повторной отправки**.

### QR-отметка

1. Браузер считывает код локально через `BarcodeDetector` или `jsQR`. В `POST /api/v1/attendance/qr` уходит только строка из кода в поле `raw`. Камера работает на HTTPS или localhost. [Сканер](public/assets/js/pages-qr.js)
2. StudPulse проверяет браузерную сессию, CSRF, привязку к собственному профилю БАРС и ограничивает запросы восемью отметками в минуту на пользователя. Сервер принимает только HTTPS-ссылку на `bars.mpei.ru/bars_web/QR/Presence/Confirm` с `qrID` и `s`. [Маршрут](api/routes.php) · [Контроллер](app/Http/StudyController.php) · [Адаптер БАРС](app/Bars/BarsOfficialAdapter.php)
3. StudPulse открывает `GET /bars_web/QR/Presence/Confirm?qrID=…&s=…` с сохранёнными cookie БАРС этого пользователя. Регистрацию выполняет БАРС. StudPulse разбирает ответ HTML и подтверждает операцию при совпадении QR ID и явном сообщении об успешной или уже выполненной регистрации. Поддерживаются короткое «Участие успешно подтверждено» и ответ с именем студента и временем регистрации. [HTTP-клиент](app/Bars/BarsClient.php) · [Разбор ответа](app/Bars/BarsQr.php)
4. Карточка показывает время регистрации из сообщения БАРС, преподавателя из блока QR ID и сведения о занятии, если БАРС их прислал. При отсутствии времени регистрации отображается время получения подтверждения с соответствующей подписью. [Карточка результата](public/assets/js/pages-qr.js)

При `BARS_QR_EXPIRED` откройте камеру снова и наведите её на текущий код. При `BARS_LOGIN_REQUIRED` восстановите сессию через **«Войти в БАРС»**. При `BARS_QR_UNCONFIRMED` или потере ответа проверьте раздел **«QR-регистрации»** в профиле БАРС перед повтором. Запрос мог дойти до БАРС до сбоя.

## Расписание РУЗ и подгруппы

Источником служит HTTPS JSON API `https://ts.mpei.ru/api`, а не парсер HTML БАРС:

| Метод | Путь | Назначение |
|---|---|---|
| `GET` | `/search?term={group}&type=group` | Поиск точного идентификатора учебной группы. |
| `GET` | `/schedule/group/{id}?start=YYYY.MM.DD&finish=YYYY.MM.DD&lng=1` | Пары группы за целые недели. |
| `GET` | `/search?term={surname}&type=person` | Поиск преподавателя. |
| `GET` | `/schedule/person/{id}?start=...&finish=...&lng=1` | Расписание однозначно найденного преподавателя. |

`MpeiSchedule` проверяет точное соответствие кода группы; преподаватель должен определяться однозначно. Ответ нормализуется в занятия с временем, аудиторией, преподавателем и видом работы. `ScheduleSubgroups` фильтрует/объединяет параллельные занятия по выбранным настройкам; оригинальное расписание нужно сохранять для проверки журнала, где фильтр студенческой подгруппы может скрыть другие пары группы.

Расписание РУЗ считается свежим пять минут. При сетевой ошибке сервер может вернуть снимок возрастом до суток и отметить его как устаревший. Даты занятий рассчитываются в `Europe/Moscow`. `GET /api/v1/schedule` принимает `from` и `to` в формате `YYYY-MM-DD` с диапазоном до 92 дней. [Клиент РУЗ](app/Integrations/MpeiSchedule.php) · [Маршрут расписания](app/Http/StudyController.php)

## Библиотека, Google Drive и резервные копии

### Локальная модель

`materials`, `material_files`, `material_lessons`, `subjects` и связанные таблицы обеспечивают карточки материалов, файлы и привязку к конкретным занятиям. Приватные оригиналы хранятся **не** в публичном веб-каталоге, доступ к скачиванию проверяется через API. Существуют личные и групповые области; групповой доступ зависит от действующего подтверждённого членства. В подключённой групповой библиотеке материалы располагаются по дереву Drive, включая вложенные и пустые папки.

StudPulse не ограничивает размер файла библиотеки и общий объём материалов владельца. Браузер отправляет файлы партиями. Возможность загрузки зависит от веб-сервера, хостинга и свободного места на диске. SHA-256 используется при загрузке и восстановлении. Файл в БД имеет статус `available` или `deleted`.

### Папки в Google Drive

В разделе «Настройки» подключите Google Drive и выберите общую папку группы. При первой двусторонней синхронизации StudPulse создаёт недостающие папки по дисциплинам из базы и расписания, затем индексирует всё дерево, включая пустые папки и файлы в корне. Можно создать на Диске любую подпапку и запустить синхронизацию, чтобы увидеть её в библиотеке. Переименование и перенос внутри общей папки отслеживаются по идентификатору Drive. Файлы, добавленные на сайте из открытой папки, отправляются в ту же папку на Диске.

Личная папка StudPulse для копий также группируется по предметам. Для файлов с ограничением по подгруппе сохраняются отдельные области доступа. Набор из трёх папок по категориям больше не создаётся.

### OAuth и разрешения

Кнопка «Отключить» в настройках перемещает личную папку StudPulse в корзину Google Drive перед отзывом доступа. Сервер сверяет владельца, идентификатор и служебную метку папки. Подключённые общие папки группы сохраняются.

`GoogleDrive::start()` использует OAuth 2.0 Authorization Code с PKCE (S256) и запросом offline-доступа. Для стандартной библиотеки требуются области `drive.appdata` и `drive.file`; для полного двустороннего обхода **общей выбранной папки** нужно дополнительное разрешение `drive`, которое пользователь подтверждает отдельно. Callback: `/auth/google/callback`. Access/refresh tokens шифруются на сервере. Не копируйте секреты OAuth в frontend.

### Двусторонняя синхронизация

- Подключение общей папки выполняет пользователь с проверенным правом управления в группе.
- Кнопка «Синхронизировать всё» регистрирует запуск; `DriveSync` и `DriveSyncWorker` выполняют сканирование, сверку и действия порциями, запоминая позицию в `drive_sync_*`.
- Для больших библиотек работу продолжает планировщик после закрытия браузера. Для следующих проходов предусмотрен Google Drive Changes API, если имеется требуемая область доступа.
- В интерфейсе доступны статус, события и журнал синхронизации, остановка будущих шагов и разрешение конфликтов. Обратите внимание на различие «остановлен следующий шаг» и «откачена уже совершённая операция».
- Google Docs/Sheets/Slides импортируются в загружаемые офисные форматы (DOCX/XLSX/PPTX). Копии и версии связываются с локальными записями; удалённые/изменённые файлы могут требовать подтверждения или восстановления.
- Действия Drive зависят от прав конкретного Google-аккаунта, доступа к файлу, свободного места и корректной работы OAuth. Ошибка Google **не должна** приводить к бесконтрольному удалению оригинала из StudPulse.

Личная резервная копия содержит заметки. StudPulse шифрует её и сохраняет в `appDataFolder`. Предпросмотр показывает, какие заметки будут созданы, а подтверждение добавляет их как новые личные записи. Для восстановления физического файла библиотеки используется отдельная очередь. Она сверяет доступность, размер и контрольную сумму копии, привязанной к файлу в Drive. [Резервные копии](app/Domain/Backup.php) · [Восстановление файлов](app/Integrations/DriveSyncWorker.php)

## Почта МЭИ

При обычном входе в БАРС StudPulse привязывает почту к новой браузерной сессии, если настроен почтовый модуль. Отдельной формы входа в почту нет. Для IMAP используется короткий университетский логин, для интерфейса — адрес вида `login@mpei.ru`. Учётные данные шифруются на сервере и привязываются к ID сессии. Почтовое подключение действует до окончания сессии, максимум 30 дней. Если Exchange отклонил пароль, снова войдите через БАРС. [Создание сессии](app/Http/BarsAuthController.php) · [Подключения почты](app/Integrations/MpeiMailConnections.php)

| Операция | Как работает |
|---|---|
| Чтение и синхронизация | PHP запускает `scripts/mpei-mail.py` через `proc_open`. Python работает с `mail.mpei.ru:993` по IMAP поверх TLS. Открытие папки использует локальный кеш и ставит её на синхронизацию. |
| Папки и письма | Папки и записи кеша разделены по владельцу, почтовому ящику и папке. В пределах папки письма идентифицируются по `UIDVALIDITY` и UID. Фоновая загрузка читает письма без отметки «прочитано». |
| Черновики | Текст и части вложений хранятся в зашифрованном виде. Черновик можно открыть снова из соответствующей папки. |
| Отправка | PHP отправляет через `mail.mpei.ru:25` с обязательным TLS. Сохранение копии в «Отправленных» выполняется через IMAP. |
| Новые письма | Планировщик проверяет входящие, добавляет уведомления в MySQL и передаёт их Web Push. В открытом приложении баннер также появляется по результатам опроса уведомлений. |
| Отключение почты | Удаляются почтовые подключения пользователя, кеш выбранного ящика и его черновики. Дочерние строки писем и частей вложений удаляются каскадно. |

Письма, флаги, корзина, вложения и отправка обслуживаются [MpeiMailController](app/Http/MpeiMailController.php). Кеш и черновики хранятся через [MpeiMailCache](app/Integrations/MpeiMailCache.php) и [MpeiMailDrafts](app/Integrations/MpeiMailDrafts.php).

В `.env` задайте `MPEI_MAIL_ENABLED=true`. Если требуется, укажите путь к исходному PEM или P7B в `MPEI_MAIL_CA_FILE` и команду Python в `MPEI_MAIL_PYTHON`. Установщик проверяет уже установленную цепочку, заданный файл и файлы в домашнем каталоге. При необходимости он загружает университетский P7B по HTTPS, проверяет сертификаты и сохраняет PEM в `STORAGE_PATH/mail/mpei-ca-chain.pem`. Подлинность сервера и имя `mail.mpei.ru` проверяются при TLS-соединении. [Установка цепочки](scripts/mpei-ca.sh) · [Проверка сертификатов](bin/mpei-ca.php) · [IMAP](scripts/mpei-mail.py)

```bash
bash setup-worker.sh
php bin/preflight.php --mail-runtime
```

`MPEI Mail Python / TLS CA OK` подтверждает, что выбранный Python прочитал цепочку. Сетевой тест установщика отдельно выводит `IMAP mail.mpei.ru:993 / … / Verification: OK`. Вход в почтовый ящик проверяется при работе под учётной записью студента.

## Планировщик, Push и офлайн

### Что выполняется фоном

`bin/cron.php` собирает напоминания, проверяет оценки и пропуски БАРС, ищет новые письма и отправляет Web Push. Затем планировщик продвигает очередь Drive и при наличии времени обновляет почтовый кеш. `AcademicWatch` берёт до пяти просроченных задач за проход, выделяет 25 секунд на пакет и до восьми секунд на задачу. Если до общего дедлайна осталось меньше восьми секунд, следующая задача ждёт следующего запуска. Очередь и возраст самой старой задачи видны в логе. [Планировщик](bin/cron.php) · [Проверка БАРС](app/Bars/AcademicWatch.php)

Обёртка `start-worker.sh` после прохода запускает ежедневную очистку по времени UTC. Она удаляет истёкшие сессии, OAuth-состояния, служебные записи и физические файлы удалённых аккаунтов. После ошибки очистка повторится на следующем проходе. Запуск вручную доступен через `php bin/maintenance.php --purge-expired`. [Очистка](bin/maintenance.php)

### Запуск в Linux

```bash
cd /path/to/studpulse

# Проверка PHP и модулей
php bin/preflight.php --php-only

# Установка после создания .env и импорта схемы
bash install.sh

# Один проход и проверка статуса
bash start-worker.sh --once
bash start-worker.sh --status

# Непрерывный запуск в консоли
bash start-worker.sh

# Цикл в фоне, если хостинг его разрешает
storage_path="$(php bin/preflight.php --storage-path)"
nohup bash start-worker.sh >> "$storage_path/logs/notifications.log" 2>&1 </dev/null &

# Проверка и остановка
tail -n 50 "$storage_path/logs/notifications.log"
bash stop-worker.sh
```

`start-worker.sh` использует общий `flock` для коротких и непрерывных запусков. Обёртка хранит PID, блокировку и отметку о ежедневной очистке в `storage/notifications/` внутри проекта, чтобы уже настроенные `--status` и `--stop` работали с той же блокировкой. Интервал цикла по умолчанию 60 секунд, допустимый диапазон от 30 до 99 999 секунд. Настройка передаётся как переменная окружения процесса.

```bash
STUDPULSE_NOTIFY_INTERVAL=120 PHP_CLI_PATH=/usr/bin/php8.2 bash start-worker.sh
```

PHP CLI выбирается через `scripts/worker-php.sh`. Скрипт проверяет расширения и при необходимости пробует загрузить `sodium` через `-d extension=sodium`. На виртуальном хостинге используйте короткие запуски `bash start-worker.sh --once` через cron. `--once` запускает те же проверки, пользуется общей блокировкой и выполняет ежедневную очистку.

`bash install.sh` выводит готовую строку cron с расписанием раз в пять минут. `bash install.sh --cron` регистрирует её, если доступен `crontab`. Существующее задание для этого скрипта установщик оставляет для ручной сверки. Если на хостинге уже настроен минутный запуск, сохраните его периодичность и обновите существующую команду при необходимости. При смене `STORAGE_PATH` снова получите строку cron и замените прежнюю, чтобы путь журнала и путь данных совпадали.

`install.sh` получает путь из конфигурации PHP, хранит `install.lock` в корне `STORAGE_PATH` и пишет вывод cron в `STORAGE_PATH/logs/worker-cron.log`. `setup-worker.sh` создаёт там каталоги `files`, `logs`, `mail` и `notifications`. Затем `preflight.php` сверяет с `database/schema.sql` столбцы, их типы, допустимость NULL, значения по умолчанию, состав и уникальность индексов и внешние ключи.

### Push-уведомления

Открытый StudPulse проверяет непрочитанные уведомления при загрузке страницы, при возврате в приложение и каждые 30 секунд. Баннер нового письма показывает отправителя и тему, открывает само письмо и запоминает показанный баннер в текущей вкладке. Для баннера достаточно подключить почту МЭИ.

Для установки на iPhone откройте сайт в Safari, в меню **«Поделиться»** выберите **«На экран „Домой“»** и добавьте StudPulse. Ярлык использует PNG 180×180. Если старый ярлык сохранил прежнюю иконку, удалите ярлык и добавьте его заново.

Браузер запрашивает разрешение на Push отдельно на каждом устройстве. Подписка сохраняется в `push_subscriptions`; сервер шлёт сигнал через Web Push, а Service Worker обрабатывает получение/нажатие. Уведомления не гарантированы при запрете ОС/браузера, истекшей подписке или недоступности Push-сервиса. На iPhone для полноценной доставки PWA может потребоваться установка сайта на экран «Домой» и выдача разрешения.

Новые достижения вычисляются при обновлении оценок и пропусков. В снимке рейтинга хранятся уже полученные значки за семестр, поэтому фоновые проверки с теми же результатами не создают новые уведомления. Несколько значков, полученных за одну проверку, приходят вместе. Параметр показа подробностей в Push применяется и к достижениям. [Достижения](app/Domain/GroupRating.php) · [Доставка Push](app/Integrations/WebPush.php)

### Офлайн

Service Worker кеширует офлайн-оболочку и выбранные статические ресурсы; IndexedDB хранит привязанные к пользователю снимки расписания, оформления и части домашних заданий. Сетевые ошибки переводят в режим ограниченного офлайн-чтения. **Создание официальной записи в БАРС, загрузка в Drive и другие серверные изменения офлайн не выполняются.** При смене аккаунта приватные браузерные кеши должны очищаться/переизолироваться.

## API и правила запросов

К путям в таблице прибавьте `/api/v1`. За списком маршрутов и их прав обращайтесь к `api/routes.php`, за примерами параметров — к `GET /api/openapi.json`. Запросы входа и чтение текущей сессии описаны в роутере отдельно. [Маршруты](api/routes.php) · [OpenAPI](api/openapi.php) · [Роутер](app/Http/Router.php)

| Группа | Основные маршруты |
|---|---|
| Сессия и БАРС | `GET /session`, `POST /auth/bars/login`, `POST /auth/bars/send-code`, `POST /auth/bars/code`, `POST /auth/bars/profile`, `POST /auth/bars/cancel`, `POST /auth/logout`, `POST /auth/logout-all`, `POST /auth/refresh` |
| Учёба | `GET /schedule`, `GET /schedule/subgroups`, `GET /schedule/teacher`, `GET /subjects`, `GET /grades`, `GET /rating`, `GET /attendance`, `POST /attendance/qr`, `GET /bars/sections`, `GET /bars/section`, `GET /calendar.ics` |
| Календари | `GET/POST /calendar/subscriptions`, `DELETE /calendar/subscriptions/{id}` |
| Задания | `GET/POST /homework`, `GET/PATCH/DELETE /homework/{id}`, `POST /homework/{id}/complete`, `POST /homework/{id}/comments`, `POST /homework/{id}/examples`, `POST /homework/{id}/attachments` |
| Заметки | `GET/POST /notes`, `GET/PATCH/DELETE /notes/{id}`, `POST /notes/{id}/attachments`, `POST /notes/{id}/share` |
| Библиотека | `GET /library`, `GET /library/subjects`, `GET /library/groups`, `GET /library/lesson`, `POST /materials`, `GET/PATCH/DELETE /materials/{id}`, `POST /materials/{id}/files`, `GET/DELETE /files/{id}`, `GET /files/{id}/preview` |
| Групповой рейтинг | `GET /rating/group`, `GET /rating/group/me`, `GET /rating/group/students/{id}`, `POST /rating/group/report`, `PATCH /rating/group/visibility` |
| Почта | `GET /mail`, `GET /mail/inbox`, `GET /mail/contacts`, `POST /mail/sync`, `POST /mail/read-all`, `GET /mail/message`, `PATCH /mail/message/flags`, `POST /mail/message/move`, `GET /mail/attachment`, `POST /mail/send`, `GET /mail/drafts`, `GET/POST/DELETE /mail/drafts/{id}`, `DELETE /mail/connection` |
| Уведомления | `GET /notifications`, `GET /notifications/unread`, `POST /notifications/refresh`, `PATCH /notifications/{id}/read`, `DELETE /notifications/{id}`, `POST /push/subscriptions`, `POST /push/test` |
| Журнал БАРС | `GET /headman/bars/day`, `GET /headman/bars/form`, `GET /headman/bars/teachers`, `GET /headman/bars/attendance`, `GET /headman/bars/check`, `GET /headman/bars/sync-subjects`, `POST /headman/bars/save`, `POST /headman/bars/sync`, `POST /headman/bars/delete`, `POST /headman/bars/correct-teacher` |
| Локальная работа с группой | `GET/POST /headman/classes`, `GET /headman/roster`, `GET /headman/local-roster`, `POST /headman/classes/drafts`, `POST /headman/attendance/drafts`, `GET /announcements`, `POST /headman/announcements` |
| Google | `GET /integrations/google`, `POST /integrations/google/connect`, `GET/POST /integrations/google/sync`, `POST /integrations/google/sync/folder`, `GET /integrations/google/sync/runs/{id}`, `POST /integrations/google/sync/runs/{id}/stop`, `POST /integrations/google/backup`, `POST /integrations/google/restore/preview`, `POST /integrations/google/restore`, `POST /integrations/google/disconnect` |
| Пользователь | `GET/PATCH /settings`, `PATCH /profile`, `GET /sessions`, `DELETE /sessions/{id}`, `GET/POST /tokens`, `DELETE /tokens/{id}`, `GET /privacy/export`, `POST /privacy/delete` |

Для списка уведомлений `unread=1` оставляет непрочитанные записи. `type=mpei_mail` показывает уведомления о почте, `type=rating_achievement` — об учебных достижениях. Страницы списка задаются `limit` и `cursor`. [Фильтры](app/Http/NotificationController.php)

### Авторизация, CSRF и идемпотентность

- В браузере используется HttpOnly cookie `sp_session`. Для токенизированных сценариев предусмотрен `Authorization: Bearer sp_...` со scope и сроком действия.
- `GET /api/v1/session` возвращает сведения о сессии/пользователе и CSRF. Для защищённых изменяющих запросов через браузер требуется CSRF (`X-CSRF-Token`) и проверяется Origin.
- Изменяющие запросы из таблицы маршрутов требуют `Idempotency-Key` длиной 16–100 символов (буквы, цифры, `_`, `-`). Ключ действует сутки и связан с содержимым запроса и контекстом доступа. Шаги входа через БАРС обрабатываются отдельно до этой проверки.
- Уровни rate limit контролируются по IP, пользователю, токену и типу операции. Попытки входа/2FA имеют отдельные ограничения.
- Ответы содержат `data`, `error`, `meta` и correlation ID; при сбоях может возвращаться `Retry-After`. Код `403` говорит о недостатке прав, `401` — об истёкшей/недействительной авторизации, `409` — в том числе о конфликте или незавершённой операции.

Чтение непрочитанных уведомлений о почте с текущей браузерной сессией.

```http
GET /api/v1/notifications?type=mpei_mail&unread=1&limit=20 HTTP/1.1
Accept: application/json
Cookie: sp_session=[сессионная cookie вашего браузера]
```

Сохранение личной заметки с демонстрационными значениями.

```http
POST /api/v1/notes HTTP/1.1
Content-Type: application/json
X-CSRF-Token: [токен из собственной сессии]
Idempotency-Key: example_create_note_20261123
Origin: https://example.org
Cookie: sp_session=[сессионная cookie]

{"title":"Вопрос к консультации","body":"Уточнить условие второй задачи"}
```

В реальном запросе браузер передаёт собственную сессионную cookie и доверенный `Origin`. В скриншотах и отчётах скрывайте cookie, токены и пароль.

## Данные, права доступа и безопасность

### Основные группы таблиц MySQL

- **Идентичность и сессии:** `users`, `user_profiles`, `user_sessions`, `api_tokens`, `bars_accounts`, `bars_auth_flows`, `provider_connections`, `provider_credentials`, `oauth_states`.
- **Университетская структура:** `universities`, `academic_groups`, `terms`, `group_memberships`, `subgroup_memberships`, `subjects`, `teachers`, `rooms`, `student_subgroups`.
- **Учёба и пользовательский контент:** `homework*`, `personal_notes`, `materials`, `material_files`, `material_lessons`, `assessments`, `class_meetings`, `group_announcements`.
- **Академические данные:** `bars_rating_points` хранит историю рейтинга, `bars_academic_watch` — очередь фоновых проверок, `group_rating_profiles` хранит снимки оценок, сводки пропусков и полученные значки за текущий семестр. `group_rating_reports` хранит ведомости по группе и семестру. Кеш отдельных разделов БАРС хранится зашифрованным в `provider_credentials`.
- **Drive:** `google_connections`, `google_drive_folders`, `google_drive_copies`, `google_backup_jobs`, `drive_sync_roots`, `drive_sync_entries`, `drive_sync_runs`, `drive_sync_events`, `drive_sync_versions`, `drive_sync_folders`, `drive_sync_repairs`.
- **Почта:** `mpei_mail_connections` связано с браузерными сессиями. `mpei_mail_folders` и `mpei_mail_messages` хранят кеш, `mpei_mail_drafts` и `mpei_mail_draft_parts` — черновики и их вложения.
- **Настройки и доставка:** `user_preferences`, `notifications`, `push_subscriptions`, `push_deliveries`, `calendar_subscriptions`.
- **Служебные записи:** `idempotency_keys`, `rate_limits`, `sync_runs`, `audit_events`, `content_reports`, `headman_class_drafts`, `headman_attendance_drafts`.

Связи, составные ключи и индексы описаны в схеме. Привязка к пользователю, группе и семестру дополнительно проверяется в запросах контроллеров. [Схема](database/schema.sql) · [Проверки доступа](app/Domain/Access.php)

### Модель прав

- **Студент** получает доступ к собственному профилю, учебным данным, заметкам и разрешённым материалам.
- **Подтверждённый участник группы** может видеть предназначенное этой группе содержимое действующего учебного периода.
- **Староста/заместитель** получают дополнительные операции, но только после проверки роли и доступного журнала БАРС.
- **API-токены** обладают явным набором scopes; нельзя расширять права только указанием `headman:write` в запросе.
- **Системный администратор** имеет отдельные защищённые служебные действия; `/health/ready` не открыт анонимно.

### Безопасная эксплуатация

1. Не помещайте `.env`, дампы БД, логи с конфиденциальными данными и `storage/` в public webroot или публичный Git-репозиторий.
2. Изолируйте токены Google, БАРС и сессии разных пользователей; не передавайте cookie между аккаунтами.
3. Включите HTTPS; проверяйте точный `FRONTEND_ORIGIN`, CSRF, idempotency и права для каждой записи.
4. Перед изменением официального журнала проверяйте группу, семестр, редактируемость пары и ответ БАРС; не делайте автоматический повтор неопределённого POST.
5. Защитите резервные копии и исключите из них по возможности ключи/секреты; проверьте восстановление на отдельной установке.
6. Не используйте предоставленные кем-то реальные токены из Network: если они были опубликованы, завершите соответствующие сессии и замените секреты.
7. Перед публикацией архива или репозитория исключите рабочий `.env`. Параметры для своей установки можно взять из примера в этом README.

## Обновление, резервирование и восстановление

Сохраните копию исходников, MySQL, приватного хранилища и `.env` с действующими ключами. Перед согласованным снимком приостановите фоновые задачи и запись на сайт. В примере имя базы и учётная запись условные.

```bash
umask 077
backup_dir="$HOME/studpulse-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -- "$backup_dir"
storage_path="$(php bin/preflight.php --storage-path)"
mysqldump --single-transaction --no-tablespaces -h 127.0.0.1 -u studpulse_user -p studpulse > "$backup_dir/database.sql"
tar -C "$storage_path" -czf "$backup_dir/storage.tar.gz" .
cp -- .env "$backup_dir/.env"
```

Проверьте, что дамп импортируется в отдельную тестовую базу. Если в рабочей базе ещё есть старый столбец `group_rating_profiles.visibility` или значение `hidden` в настройках рейтинга, примените [SQL-миграцию](database/group-rating-upgrade.sql) перед запуском новой версии.

```bash
mysql -h 127.0.0.1 -u studpulse_user -p studpulse < database/group-rating-upgrade.sql
```

Скрипт удаляет устаревший столбец и переводит режим `hidden` в `average`. У этих участников в рейтинге появятся имя, средний балл и полученные значки. Скрипт также добавляет недостающие поля для пропусков и значков. Его можно повторно выполнить на той же базе.

Загрузите код и запустите `bash install.sh`. Если `preflight.php` показывает расхождения, проверьте версию схемы. `database/schema.sql` предназначен для импорта в пустую базу. Для проверки запустите `bash start-worker.sh --once`, откройте расписание и проверьте нужные интеграции, затем возобновите регулярный запуск.

Для отката верните согласованные версии кода, базы, хранилища и `.env`. Разворачивайте дамп и архив в подготовленной базе и отдельном каталоге. Верните ключ шифрования, с которым создавались данные, затем проверьте вход и загрузку файлов перед переключением сайта.

**Экспорт и удаление аккаунта.** Оба действия требуют свежей браузерной сессии. Экспорт в настройках включает профиль, настройки, заметки, задания, материалы, рейтинг, уведомления, сведения о сессиях, почтовые заголовки и черновики. Из этого JSON исключены ключи, токены, тела писем, двоичные файлы и актуальные данные внешних сервисов. Экспорт Google Drive для восстановления заметок по-прежнему использует отдельный формат.

Перед удалением StudPulse предупреждает о потере личных и общих материалов, которыми владеет пользователь. Приложение переносит распознанную личную папку и подтверждённые копии StudPulse в корзину Google Drive перед отключением аккаунта. Пользовательская общая папка Google Drive сохраняется, а её синхронизация и ожидающие задания останавливаются. Сайт показывает предупреждение, если Google не подтвердил очистку. Материалы блокируются сразу, после чего сервер удаляет физические файлы. Ежедневная задача повторяет очистку оставшихся файлов. Записи в БАРС, архивы Google Drive и независимо сохранённые копии у других участников остаются в соответствующих сервисах.

## Диагностика и частые проблемы

| Симптом | Что проверить |
|---|---|
| `SERVER_CONFIGURATION`, «нужна .env» | Путь, синтаксис, `APP_ENV`, HTTPS/localhost и параметры `Config::validate()`. |
| Установщик просит создать `.env` | Создайте файл вручную в корне проекта. Заполните его по примеру из раздела конфигурации и повторите установку. |
| `DB_*`, отсутствует таблица/столбец | Сверьте `DATABASE_URL`, версию MySQL и права пользователя. Ошибка MySQL 1146 при очистке почты означает, что в выбранной базе отсутствует нужная таблица. |
| `Schema mismatch` | Выполните `php bin/preflight.php` и сравните перечисленные расхождения с `database/schema.sql`. Для чистой установки импортируйте актуальную схему в пустую базу. |
| `BARS_LOGIN_REQUIRED` или просроченный код 2FA | Войдите в БАРС заново. Шаг 2FA привязан к браузеру и действует десять минут. |
| Пустые оценки или пропуски | Возможно, БАРС изменил HTML, скрыл раздел или отдал неполную таблицу. Сверьте с официальным кабинетом, журналы ошибок и `observedAt/stale`. |
| Нет кнопок журнала | БАРС не подтвердил статус старосты/заместителя либо нет подходящего журнала семестра. |
| «Сохранение в БАРС не подтверждено» | Откройте официальный журнал и вручную убедитесь в результате перед повторной отправкой. |
| Пары не совпадают с журналом | Группа, подгруппа, тип занятия, параллельный поток, время и подтверждение предыдущих отметок. |
| Нет расписания РУЗ | Поиск группы/преподавателя не дал однозначного ID, недоступен `ts.mpei.ru` или просрочен кеш. |
| Файлы не уходят в Drive | Google OAuth/refresh token, разрешения `drive.file`/`drive`, выбранная папка, owner, лог конфликта и worker. |
| Push не приходит | HTTPS, разрешение ОС/браузера, PWA на iOS, VAPID, действующая подписка, `sodium`/`openssl`, запуск worker. |
| Worker не запускается | Проверьте `php bin/preflight.php --php-only`, `PHP_CLI_PATH`, наличие `flock` и `timeout`. Скрипту нужен доступ на запись в `storage/notifications` проекта. |
| Cron пишет лог в старый каталог | Выполните `php bin/preflight.php --storage-path`, затем `bash install.sh`. Обновите команду существующего задания и проверьте `STORAGE_PATH/logs/worker-cron.log`. |
| Не работает почта МЭИ | Проверьте `MPEI_MAIL_ENABLED`, доступность Python и цепочку `MPEI_MAIL_CA_FILE`. Запустите `bash setup-worker.sh` и проверьте результат сетевого теста. Если Exchange отклоняет пароль, заново войдите в БАРС. |
| Новое письмо есть только в списке уведомлений | Откройте приложение с действующим почтовым подключением. Баннер показывает недавние непрочитанные письма. Уже показанные баннеры запоминаются в текущей вкладке. |

**Диагностические команды:**

```bash
php -v
php -m
php bin/preflight.php --php-only
php bin/preflight.php
bash start-worker.sh --status
bash start-worker.sh --once
php bin/maintenance.php --purge-expired
```

Ошибки веб-приложения пишутся в `STORAGE_PATH/logs/app-YYYY-MM-DD.log`. Вывод cron при установке через `install.sh` попадает в `STORAGE_PATH/logs/worker-cron.log`. Перед передачей журнала скройте персональные данные.

## Проверки и ограничения

| Проверка | Где выполнена |
|---|---|
| Сверка схемы и очистка почтового кеша | Локальная MySQL 8.0. Проверены удаление одного ящика, удаление всех ящиков пользователя, каскады и откат при отсутствующей таблице. |
| Установка с отдельным хранилищем | Bash с тестовой заменой `crontab`. Проверены путь с пробелами и апострофом, журнал, повторная установка и обнаружение прежнего задания. Путь из PHP проверен отдельно. |
| Ведомость группы | HTML и XLSX. На тестовой MySQL проверены сохранение отчёта, повторное обновление и видимость оценок. |
| Достижения и первые три места | На тестовой MySQL проверены показ сохранённых значков, ограничения доступа между группами и повторный запуск SQL. В Edge на ширинах 320 и 1280 пикселей проверено оформление списка и карточек в светлой, тёмной и неоновой темах. |
| QR | Локальные HTML-примеры, включая повторную отметку, неожиданный ответ, просроченный код и истёкшую сессию. |
| Мобильный интерфейс | Chromium на мобильном размере с тестовыми ответами. Проверены баннер письма, счётчик и раскрытие оценок. |

После развёртывания проверьте вход в БАРС, Exchange, доступ к выбранной папке Drive, запуск cron в панели хостинга и установку на физическом iPhone. Запись в университетский журнал и QR проводят в действующей сессии с нужными полномочиями.

---

Автор: legenda

Telegram: [@LEGENDA_SD](https://t.me/LEGENDA_SD)
