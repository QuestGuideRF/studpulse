<?php $forbidden=http_response_code()===403;$title=$forbidden?'Доступ закрыт':'Страница не найдена';?>
<!doctype html>
<html lang="ru" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="robots" content="noindex">
  <title><?=$title?> · StudPulse</title>
  <link rel="icon" href="/icons/icon.svg?v=2" type="image/svg+xml">
  <link rel="stylesheet" href="/assets/css/app.css?v=39">
  <script src="/assets/js/error-theme.js?v=28"></script>
</head>
<body>
  <main class="error-page">
    <section class="card" aria-labelledby="error-title">
      <a class="brand" href="/"><img class="brand-mark" src="/icons/icon.svg?v=2" alt="" width="40" height="40">StudPulse</a>
      <p class="error-code"><?=$forbidden?'403':'404'?></p>
      <h1 id="error-title"><?=$title?></h1>
      <p class="muted mt-sm"><?=$forbidden?'У этого аккаунта нет доступа к странице.':'Проверьте адрес или перейдите в один из разделов.'?></p>
      <nav class="row" aria-label="Навигация StudPulse">
        <a class="btn primary" href="/">На главную</a>
        <a class="btn" href="/schedule">Расписание</a>
        <a class="btn text" href="/login">Вход</a>
      </nav>
    </section>
  </main>
</body>
</html>
