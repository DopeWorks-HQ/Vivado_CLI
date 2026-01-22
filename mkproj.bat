@echo off
if "%~1"=="" (
  echo usage: mkproj.bat ^<project_name^>
  exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0mkproj.ps1" "%~1"
