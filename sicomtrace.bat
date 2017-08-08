@echo off
echo SICOMTRACE v0.2.1 by Szieberth Adam

setlocal

set prog_dir=%~dp0

rem at least two arguments are required

set arg_n=0
for %%x in (%*) do set /A arg_n+=1
if %arg_n% GEQ 2 (goto body)
set exitcode=1


:usage

echo Usage: SICOMTRACE.BAT ^<SI_STATION_COM^> ^<BAUD^> ^<VIRTUAL_COM_PAIR^> [TCP_PORT]
goto end


:body

set exitcode=0
set sistationcom=%1
set baud=%2
set virtcompair=%3
set port=%4

rem handle Baudrate argument
if %baud% == 38400 (goto baud_ok)
if %baud% == 4800 (goto baud_ok)
echo Invalid Baudrate!  Please set it to 4800 or 38400!
set exitcode=2
goto end
:baud_ok

rem handle TCP server port argument
if "%port%" == "" (goto port_ok)
if %port% gtr 0 if %port% leq 65535 (goto port_ok)
echo Invalid Port!  Please set it between 0 and 65535!
set exitcode=3
goto end
:port_ok

call :lognum lognum sistationcom
set "logname=%sistationcom%_%lognum%.log"

goto hub4comcall

Now it is time to call hub4com which does all the job. Note that this batch file
only prepares the parameters. You may freely edit them manually if you need more
virtual COM ports or want to accept more TCP clients.

Call "hub4com --help=tcp" for more information.

Attention! Communication is impossible without the "--octs=off" option!


:hub4comcall

set callstr=^
%prog_dir%\hub4com.exe ^
--baud=%baud% ^
--octs=off ^
--no-default-fc-route=All:All ^
--trace-file=%logname% ^
--create-filter=trace --add-filters=0:trace ^
\\.\%sistationcom% ^
--route=0:All ^
\\.\%virtcompair% ^
--route=1:0

if "%port%" neq "" (
  set callstr=%callstr% ^
--use-driver=tcp ^
%port% ^
--route=2:0
)

echo.
echo HUB4COM CALL STRING:
echo %callstr%
echo.
call %callstr%
goto end


:lognum <resultVar> <lognameVar>

rem this function determines the suffix number of the log file
rem to avoid accidental overwriting of previously logged data
rem in case of a restart

(
  setlocal EnableDelayedExpansion
  set "logbasename=!%~2!"
  call :strlen lognamelen logbasename
  set /a log_n_starts_at = !lognamelen!+1
  set "last_log_n=0"
  set "log_n=0"
  for %%i in (!%~2!_??.log) do (
    set "trace_file=%%i"
    for /f "tokens=1" %%a in ("!log_n_starts_at!") do (
      set "log_n=!trace_file:~%%a,-4!"
    )
    rem http://stackoverflow.com/a/17584764/2334951
    set "not_numeric="&for /f "delims=0123456789" %%i in ("!log_n!") do (
      set "not_numeric=%%i"
    )
    if not defined not_numeric (
      for /f "tokens=* delims=0" %%a in ("!log_n!") do (set log_n=%%a)
      if !log_n! GTR !last_log_n! (set "last_log_n=!log_n!")
      )
    )
  )
  set /a log_n = !last_log_n! + 1
  set "fntemp=00!log_n!"
  set "fn=!fntemp:~-2!"
)
(
  endlocal
  set "%~1=%fn%"
  exit /b
)


:strlen <resultVar> <stringVar>

rem this function returns the length of a string
rem http://stackoverflow.com/a/5841587/2334951

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


:end
endlocal
exit /b %exitcode%
exit
