<!doctype html>
<html lang="ru" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
  <meta name="theme-color" content="#181818">
  <meta name="description" content="StudPulse — учебное пространство студента: расписание, домашние задания и материалы.">
  <title>StudPulse</title>
  <link rel="icon" href="/icons/icon.svg?v=2" type="image/svg+xml">
  <link rel="apple-touch-icon" href="/icons/icon.svg?v=2">
  <link rel="manifest" href="/manifest.webmanifest">
  <link rel="stylesheet" href="/assets/css/app.css?v=39">
  <?php if(($path??'')==='/login'):?>
  <link rel="modulepreload" href="/assets/js/pages-account.js?v=49">
  <link rel="modulepreload" href="/assets/js/api.js?v=37">
  <link rel="modulepreload" href="/runtime-config.js">
  <?php else:?>
  <link rel="stylesheet" id="study-styles" href="/assets/css/study.css?v=52">
  <?php endif;?>
  <script type="module" src="/assets/js/app.js?v=91"></script>
</head>
<body>
  <a class="skip" href="#main">Перейти к содержимому</a>
  <div id="app"><div class="boot" role="status"><?php if(($path??'')!=='/login'):?><img class="brand-mark" src="/icons/icon.svg?v=2" alt="" width="40" height="40"><?php endif;?><p>Загрузка…</p><div class="skeleton"></div></div></div>
  <div id="toasts" aria-live="polite" aria-atomic="true"></div>
  <dialog id="modal" aria-labelledby="modal-title"></dialog>
  <noscript>Для интерактивных функций нужен JavaScript. <a href="https://bars.mpei.ru/BARS_Web" rel="noreferrer">Официальный БАРС МЭИ</a></noscript>
</body>
</html>
