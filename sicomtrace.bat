@echo off
echo SportIdent COM Port Tracer v0.1 by Szieberth Adam
set n=%1
set pcom=%2
set vcom=%3
set baud=%4

if "%baud%" == "" (set baud=38400)

set log_head=trace_%pcom%

call :strlen log_head_len log_head

set my_dir=%cd%
set my_drive=%cd:~0,3%

set arg_n=0
for %%x in (%*) do set /A arg_n+=1
if not %arg_n% GEQ 3 (goto usage)

set n_ok=0
for /l %%X in (0,1,99) do (
  if %n% == %%X (
    set n_ok=1
    goto break_n_check
  )
)
:break_n_check
if %n_ok% == 0 (goto usage)

set baud_ok=0
if %baud% == 4800 (set baud_ok=1)
if %baud% == 38400 (set baud_ok=1)
if %baud_ok% == 0 (goto usage)

set /a log_n_starts_at = %log_head_len%+1
set last_log_n=0
rem setlocal enabledelayedexpansion
for %%i in (%log_head%.*.log) do (
  set "trace_file=%%i"
  set "log_n=!trace_file:~%log_n_starts_at%,-4!"
  for /f "tokens=* delims=0" %%a in ("!log_n!") do (
    set log_n=%%a)
  if !log_n! GTR !last_log_n! (set "last_log_n=!log_n!")
  )
)

set /a log_n = !last_log_n! + 1
set "fntemp=000%log_n%"
set fn=!fntemp:~-3!
set log_name=%log_head%.%fn%.log
set log_path="%my_dir%\%log_name%"
rem endlocal

cd /D "C:\Program Files (x86)\com0com"
setupc.exe remove %n%
setupc.exe install %n% PortName=%vcom% *
setupc.exe list

echo Traffic will be logged in %log_path%

rem wait 2 seconds
rem http://stackoverflow.com/a/735603/2334951
ping -n 3 127.0.0.1 > nul

cd /D "%my_dir%"
hub4com --baud=%baud% --no-default-fc-route=All:All --bi-route=All:All --trace-file=%log_path% --octs=off --create-filter=trace --add-filters=0:trace  \\.\CNCB%n% %pcom%
goto eof

:usage
echo Usage: sicomtrace.bat ^<n^> ^<pysical_com^> ^<virtual_com^> [baud]
goto eof

rem http://stackoverflow.com/a/5841587/2334951
:strlen <resultVar> <stringVar>
(
    setlocal EnableDelayedExpansion
    set "s=!%~2!#"
    set "len=0"
    for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        if "!s:~%%P,1!" NEQ "" (
            set /a "len+=%%P"
            set "s=!s:~%%P!"
        )
    )
)
(
    endlocal
    set "%~1=%len%"
    exit /b
)

:eof
endlocal
