@echo off
setlocal

:: Set RGBDS directory
set RGBDS=C:\Users\Alexander\Downloads\rgbds-0.8.0-win64

:: Set source directory where .png files are located
set SRC_DIR=C:\Users\Alexander\Desktop\Code\Projects\pokered

:: Convert each .png file in the source directory and its subdirectories to .2bpp
for /r "%SRC_DIR%\gfx" %%f in (*.png) do (
    echo Converting "%%f" to .2bpp
    "%RGBDS%\rgbgfx.exe" -o "%%~dpnf.2bpp" "%%f"
)

echo Conversion complete!
pause
