@echo off
chcp 65001 >nul
echo ===================================================
echo       Windows 11 비밀번호 해제 및 설정 스크립트
echo ===================================================
echo.

:: 1. Windows Hello 로그인 전용 모드 해제 (레지스트리 변경)
echo [1단계] 레지스트리 설정을 변경합니다...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device" /v DevicePasswordLessBuildVersion /t REG_DWORD /d 0 /f >nul 2>&1

:: 레지스트리 변경 결과 확인
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device" /v DevicePasswordLessBuildVersion | find "0x0" >nul
if %errorlevel% equ 0 (
    echo  - [성공] DevicePasswordLessBuildVersion 값이 0으로 변경되었습니다.
) else (
    echo  - [실패] 레지스트리 변경 실패. 반드시 마우스 우클릭 후 '관리자 권한으로 실행'을 눌러주세요.
    echo.
    pause
    exit /b
)
echo.

:: 2. 로컬 계정 비밀번호 해제
echo [2단계] 'USER' 계정의 비밀번호를 공란으로 처리합니다...
:: 관리자 권한 실행 시 기존 비밀번호를 검증할 필요 없이 즉시 공란("")으로 덮어쓸 수 있습니다.
net user "USER" "" >nul 2>&1

if %errorlevel% equ 0 (
    echo  - [성공] USER 계정의 비밀번호가 성공적으로 해제되었습니다.
) else (
    echo  - [실패] 비밀번호 해제 실패. 계정명을 다시 확인해주세요.
)

echo.
echo ===================================================
echo 모든 작업이 완료되었습니다. 아무 키나 누르면 종료됩니다.
echo ===================================================
pause >nul
