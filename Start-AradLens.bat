@echo off
title AradLens - start local
cd /d "%~dp0"
echo.
echo   AradLens - pornire locala
echo.

rem Cauta Python (serverul local de fisiere statice)
set "PY="
py -3 --version >nul 2>nul && set "PY=py -3"
if not defined PY python --version >nul 2>nul && set "PY=python"

if not defined PY (
  echo   Python nu a fost gasit. Se deschide fisierul direct.
  echo   Nota: camera/GPS merg doar prin adresa http://127.0.0.1:8010 ,
  echo   deci instaleaza Python de la https://www.python.org/ si ruleaza din nou.
  start "" "%~dp0index.html"
  exit /b
)

rem Porneste serverul local minimalizat, apoi deschide browserul
start "AradLens server" /min cmd /c "%PY% -m http.server 8010 --bind 127.0.0.1"
timeout /t 1 /nobreak >nul
start "" "http://127.0.0.1:8010/index.html"

echo   Deschis in browser: http://127.0.0.1:8010/index.html
echo   Ca sa opresti serverul, inchide fereastra mica "AradLens server".
echo.
pause
