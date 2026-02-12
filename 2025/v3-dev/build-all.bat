@echo off
setlocal enabledelayedexpansion

:: Create build directory if it doesn't exist
if not exist "build" mkdir build

:: Initialize counters
set /a success_count=0
set /a total_count=0

:: Find all game directories with init.luau
echo Scanning for games...
for /d %%G in (src\Experiences\*) do (
    if exist "%%G\Main.luau" (
        set /a total_count+=1
        set "game_name=%%~nxG"
        
        echo.
        echo [!total_count!] Building: !game_name!
        echo ----------------------------------------
        
        :: Build the game
        darklua process "%%G\Main.luau" "build\!game_name!.luau" --config darklua.json
        
        if !errorlevel! equ 0 (
            set /a success_count+=1
            echo SUCCESS: !game_name!.luau
            
            :: Get file size
            for %%F in ("build\!game_name!.luau") do (
                set size=%%~zF
                set /a size_kb=!size!/1024
                echo    Size: !size_kb! KB
            )
        ) else (
            echo FAILED: !game_name!
        )
    )
)

echo.
echo ==========================================
echo               BUILD SUMMARY
echo ==========================================
echo Total games found: %total_count%
echo Successful builds: %success_count%
set /a failed_count=%total_count%-%success_count%
echo Failed builds: %failed_count%
echo.

if %failed_count% gtr 0 (
    echo Some builds failed. Check output above.
) else (
    echo All builds completed successfully!
)

:: List all built files
if %success_count% gtr 0 (
    echo Built files:
    for %%F in (build\*.luau) do (
        echo    %%~nxF
    )
    echo.
)

pause