@echo off
setlocal EnableExtensions
title AradLens - server local
cd /d "%~dp0"

set "PORT=8010"
set "URL=http://127.0.0.1:%PORT%/index.html"

echo.
echo   AradLens - pornire locala
echo.

rem 1) Daca serverul ruleaza deja, deschide doar browserul.
netstat -ano | findstr ":%PORT%" | findstr "LISTENING" >nul 2>nul
if not errorlevel 1 (
  echo   Serverul ruleaza deja pe portul %PORT%.
  start "" "%URL%"
  goto end_ok
)

rem 2) Gaseste Python (py launcher, apoi python, apoi python3).
set "PY_CMD="
set "PY_ARGS="
where py >nul 2>nul
if not errorlevel 1 (
  py -3 --version >nul 2>nul
  if not errorlevel 1 (
    set "PY_CMD=py"
    set "PY_ARGS=-3"
  )
)
if not defined PY_CMD (
  where python >nul 2>nul
  if not errorlevel 1 (
    python --version >nul 2>nul
    if not errorlevel 1 set "PY_CMD=python"
  )
)
if not defined PY_CMD (
  where python3 >nul 2>nul
  if not errorlevel 1 (
    python3 --version >nul 2>nul
    if not errorlevel 1 set "PY_CMD=python3"
  )
)
if not defined PY_CMD goto nopython

rem 3) Porneste serverul intr-o fereastra minimizata.
set "SERVER_FILE=%~dp0dev_server.py"
if exist "%SERVER_FILE%" (
  start "AradLens server" /min "%PY_CMD%" %PY_ARGS% "%SERVER_FILE%"
) else (
  echo   dev_server.py lipseste; pornesc server static fara proxy /api.
  start "AradLens server" /min "%PY_CMD%" %PY_ARGS% -m http.server %PORT% --bind 127.0.0.1
)

rem 4) Asteapta pana cand portul asculta (maximum 8 secunde).
set /a WAIT=0
:wait
netstat -ano | findstr ":%PORT%" | findstr "LISTENING" >nul 2>nul
if not errorlevel 1 goto ready
set /a WAIT+=1
if %WAIT% GEQ 8 goto notready
timeout /t 1 /nobreak >nul
goto wait

:ready
start "" "%URL%"
echo   Deschis in browser: %URL%
echo   Pentru oprire, inchide fereastra "AradLens server".
echo   Serverul local prelucreaza si /api (proxy spre API-ul AradLens).
echo.
pause
exit /b 0

:notready
echo   Serverul nu a pornit in 8 secunde.
echo   Verifica daca Python este instalat si daca portul %PORT% este liber.
echo   Deschid fisierul direct; camera/GPS nu vor functiona fara server.
start "" "%~dp0index.html"
echo.
pause
exit /b 1

:nopython
echo   Python nu a fost gasit.
echo   Instaleaza Python de la https://www.python.org/ si ruleaza din nou.
echo   Fara server, camera/GPS nu merg; se deschide fisierul direct.
start "" "%~dp0index.html"
echo.
pause
exit /b 1

:end_ok
echo.
pause
exit /b 0
