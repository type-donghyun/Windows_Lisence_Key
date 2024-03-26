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

Title Windows License Activate
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
IF /I %edition% equ Pro (
    ECHO Windows %version% %edition%가 감지되었습니다.
    ECHO.
    ECHO [1] 조직의 정품 인증 서비스를 사용하여 Windows 정품 인증
    ECHO [2] 디지털 라이선스를 사용하여 정품 인증
    GOTO :pro
) ELSE IF /I %edition% equ Home (
    ECHO Windows %version% %edition%이 감지되었습니다.
    ECHO.
    ECHO [1] 조직의 정품 인증 서비스를 사용하여 Windows 정품 인증
    ECHO [2] 디지털 라이선스를 사용하여 정품 인증
    GOTO :home
) ELSE (
    COLOR 04
    ECHO 활성화할 수 없는 Windows 버전입니다: %edition%
    TIMEOUT /t 2 > nul
    GOTO :workend
)

:pro
CHOICE /c 12
CLS
IF %errorlevel% equ 1 (
    ECHO 조직의 정품 인증 서비스를 사용하여 Windows 정품 인증중
    cscript //nologo %windir%\system32\slmgr.vbs /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
    GOTO :activate
) ELSE IF %errorlevel% equ 2 (
    ECHO 디지털 라이선스를 사용하여 정품 인증중
    cscript //nologo %windir%\system32\slmgr.vbs /ipk NF6HC-QH89W-F8WYV-WWXV4-WFG6P
    GOTO :activate
) ELSE (
    COLOR 04
    ECHO 선택된 옵션이 잘못되었습니다.
    TIMEOUT /t 2 > nul
    GOTO :workend
)

:home
CHOICE /c 12
CLS
IF %errorlevel% equ 1 (
    cscript //nologo %windir%\system32\slmgr.vbs /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
    GOTO :activate
) ELSE IF %errorlevel% equ 2 (
    ECHO 아직 여기는 미구현 ㅎㅎ ㅈㅅ
    GOTO :activate
) ELSE (
    COLOR 04
    ECHO 선택된 옵션이 잘못되었습니다.
    TIMEOUT /t 2 > nul
    GOTO :workend
)

:activate

cscript //nologo %windir%\system32\slmgr.vbs /skms kms.digiboy.ir
cscript //nologo %windir%\system32\slmgr.vbs /ato
cscript //nologo %windir%\system32\slmgr.vbs /xpr
ECHO.
ECHO 라이선스 정보와 만료 날짜를 확인
ECHO [1] Yes
ECHO [2] No
CHOICE /c 12 /n /t 3 /d 2 

CLS
IF %errorlevel% equ 1 (
    SLMGR /dlv
)

:workend
CLS
ECHO 작업을 종료합니다.
TIMEOUT /t 3 > nul
