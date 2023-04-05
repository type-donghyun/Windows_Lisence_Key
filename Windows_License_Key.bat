@ECHO OFF
::_____________________________________________________________________________________________________________________________________________________________
:: 관리자 권한 요청

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

IF %errorlevel% neq 0 (
	GOTO UACPrompt
) ELSE (
	GOTO gotAdmin
)

:UACPrompt
	ECHO SET UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	ECHO UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

	"%temp%\getadmin.vbs"
	EXIT /B

:gotAdmin
	IF EXIST "%temp%\getadmin.vbs" (
		DEL "%temp%\getadmin.vbs"
	)
	PUSHD "%CD%"
	CD /D "%~dp0"

::_____________________________________________________________________________________________________________________________________________________________

Title Windows License Key
FOR /f "tokens=4-6" %%a in ('systeminfo') do (
	IF "%%a" equ "Windows" (
		SET OSname=%%a
		SET version=%%b
		SET edition=%%c
	)
)

CHCP 65001 > nul

IF %OSname% equ Windows (
	GOTO :dowork
) ELSE (
	COLOR 04
	ECHO 운영체제가 Windows가 아닙니다.
	TIMEOUT /t 2 > nul
	GOTO :workend
)

IF %version% equ 10 (
	GOTO :dowork
) ELSE IF %version% equ 11 (
	GOTO :dowork
) ELSE (
	COLOR 04
	ECHO Windows 버전이 10/11이 아닙니다.
	TIMEOUT /t 2 > nul
	GOTO :workend
)

:dowork
IF %edition% equ Pro (
	ECHO Windows %version% %edition%가 감지되었습니다.
	SLMGR /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
) ELSE IF %edition% equ Home (
	ECHO Windows %version% %edition%이 감지되었습니다.
	SLMGR /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
) ELSE (
	COLOR 04
	ECHO 활성화할 수 없는 Windows 버전입니다: %edition%
	TIMEOUT /t 2 > nul
	GOTO :workend
)

SLMGR /skms kms.digiboy.ir
SLMGR /ato

CHCP 65001 > nul
CLS
COLOR 02
ECHO ▣ Windows 정품 활성화
ECHO.
CHOICE /c 12 /n /t 3 /d 2 /m "라이센스 정보와 만료 날짜를 확인하시겠습니까? [1] Yes [2] No"

CLS
IF %errorlevel% equ 1 (
	SLMGR /xpr
	SLMGR /dlv
)

:workend
ECHO 작업을 종료합니다.
TIMEOUT /t 3 > nul
