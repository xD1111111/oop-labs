@echo off
chcp 65001 >nul
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter is not installed or is not in PATH.
  echo Install Flutter SDK: https://docs.flutter.dev/get-started/install/windows/desktop
  pause
  exit /b 1
)
flutter create --platforms=windows .
if errorlevel 1 goto :failed
flutter pub get
if errorlevel 1 goto :failed
flutter run -d windows
if errorlevel 1 goto :failed
pause
exit /b 0
:failed
echo Build or launch failed. Run flutter doctor -v to see missing components.
pause
exit /b 1
