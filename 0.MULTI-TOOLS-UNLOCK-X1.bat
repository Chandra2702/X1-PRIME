echo off
setlocal enabledelayedexpansion
IF EXIST "%~dp0\adb" SET PATH=%PATH%;"%~dp0\adb"
mode con lines=25 cols=55
chcp 65001>nul
title MULTI-TOOLS-UNLOCK-X1
:awal
color 0F
cls
echo ==============================================
echo =             MULTI UNLOCK TOOLS             =
echo =             FirsMedia X1-PRIME             =
echo =             by Andriy Chandra              =
echo ==============================================
echo #   Langkah-langkah yg harus diperhatikan    #
echo ----------------------------------------------
echo # - PC dan STB wajib 1 SSID WIFI yang sama   #
echo # - Pilih Connect input ip WIFI yg ada di STB#
echo # - Muncul PopUp di STB centang dan izinkan  #
echo ==============================================
echo 1. Connect/Hubungkan                             
echo 2. Install Launcher
echo 3. Unlock X1 Prime-C OS9
echo 4. Unlock X1 Prime-C OS11
echo 5. Izinkan Widget ATV
echo 6. Install APK Massal
echo 7. Send Files To TV/STB
echo 0. Exit             
echo ==============================================
set/p "input=Masukan Pilihan = " 
if %input%==1 goto connect
if %input%==2 goto launcher
if %input%==3 goto cos9
if %input%==4 goto cos11
if %input%==5 goto widget
if %input%==6 goto apk
if %input%==7 goto send
if %input%==0 goto exit
cls
echo Silahkan Pilih Menu Yang Benar...
echo.
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto awal
:connect
cls
echo ==============================================
echo =             Connect/Hubungkan              =
echo ==============================================
set/p input=Masukan Alamat ip :
adb\adb connect %input%
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto awal
:launcher
cls
echo ==============================================
echo =           Menginstall Launcher             =
echo ==============================================
for /f "delims=|" %%f in ('dir /b "launcher\"*.apk') do @"adb\adb.exe"  install "launcher\%%f"
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto awal
:cos9
cls
echo ==============================================
echo =        Mengunlock X1 PRIME-C OS9           =
echo ==============================================
for /f "delims=|" %%f in ('dir /b "unlock\OS9\"*.apk') do @"adb\adb.exe"  install "unlock\OS9\%%f"
adb\adb shell pm uninstall --user 0 com.google.android.play.games
adb\adb shell pm uninstall --user 0 com.google.android.music
adb\adb shell pm uninstall --user 0 com.google.android.tv
adb\adb shell pm uninstall --user 0 com.google.android.videos
adb\adb shell pm uninstall --user 0 com.hisilicon.hardwaretest
adb\adb shell pm uninstall --user 0 com.hikeymasterprovision
adb\adb shell pm uninstall --user 0 com.playreadyprovision
adb\adb shell pm uninstall --user 0 com.tvstorm.launcher.jiuzhou
adb\adb shell pm uninstall --user 0 com.tvstorm.tv.upgrader.jiuzhou
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto awal
:cos11
cls
echo ==============================================
echo =       Mengunlock X1 PRIME-C OS11           =
echo ==============================================
for /f "delims=|" %%f in ('dir /b "unlock\OS11\"*.apk') do @"adb\adb.exe"  install "unlock\OS11\%%f"
adb\adb shell pm uninstall --user 0 com.tvstorm.adjustscreenoffset.linknet.jiuzhou.hybrid2.ui3
adb\adb shell pm uninstall --user 0 com.tvstorm.administrator.linknet.jiuzhou.hybrid2.ui3
adb\adb shell pm uninstall --user 0 com.tvstorm.customizer.linknet.jiuzhou.hybrid2.ui3
adb\adb shell pm uninstall --user 0 com.tvstorm.hiddenmenu.linknet.jiuzhou.hybrid2.ui3
adb\adb shell pm uninstall --user 0 com.tvstorm.linknetcable.linknet.jiuzhou.hybrid2.ui3
adb\adb shell pm uninstall --user 0 com.tvstorm.launcher3.linknet.jiuzhou.hybrid2.ui3
adb\adb shell pm uninstall --user 0 com.tvstorm.tv.upgrader.linknet.jiuzhou.hybrid2.ui3
adb\adb shell pm uninstall --user 0 com.tvstorm.linknetiptv.linknet.jiuzhou.hybrid2.ui3
adb\adb shell pm uninstall --user 0 com.tvstorm.pvr.linknet.jiuzhou.hybrid2.ui3
adb\adb shell pm uninstall --user 0 com.tvstorm.service.linknet.jiuzhou.hybrid2.ui3
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto awal
:apk
cls
echo ==============================================
echo =              Menginstall APK               =
echo ==============================================
for /f "delims=|" %%f in ('dir /b "send\apk\"*.apk') do @"adb\adb.exe"  install "send\apk\%%f"
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto awal
:widget
cls
echo ==============================================
echo =            Izinkan Widget ATV              =
echo ==============================================
adb\adb shell appwidget grantbind --package ca.dstudio.atvlauncher.pro --user 0
echo Success
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto awal
:send
cls
echo ==============================================
echo =            Send Files To TV/STB            =
echo ==============================================
echo #   Langkah-langkah yg harus diperhatikan    #
echo ==============================================
echo # - Copy File apk/jpg/png/mp3/mp4/mkv        #
echo #   ke Folder send                           #
echo ==============================================
echo PLEASE SELECT MENU
echo -
echo 1. File .apk
echo 2. File .jpg
echo 3. File .png
echo 4. File .mp3
echo 5. File .mp4
echo 6. File .mkv
echo 0. Kembali
echo ==============================================
set/p "input=Masukan Pilihan = " 
if %input%==1 goto fileapk
if %input%==2 goto filejpg
if %input%==3 goto filepng
if %input%==4 goto filemp3
if %input%==5 goto filemp4
if %input%==6 goto filemkv
if %input%==0 goto awal
cls
echo Silahkan Pilih Menu Yang Benar...
timeout 3 >nul
goto send
:fileapk
cls
echo.
echo ==============================================
echo =             Send File .apk                 =
echo ==============================================
for /f "delims=|" %%f in ('dir /b "send\apk\"*.apk') do @"adb\adb.exe"  push "send\apk\%%f" /sdcard/Download/
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto send
:filejpg
cls
echo.
echo ==============================================
echo =             Send File .jpg                 =
echo ==============================================
for /f "delims=|" %%f in ('dir /b "send\jpg.png\"*.jpg') do @"adb\adb.exe"  push "send\jpg.png\%%f" /sdcard/Pictures/
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto send
:filepng
cls
echo.
echo ==============================================
echo =             Send File .png                 =
echo ==============================================
for /f "delims=|" %%f in ('dir /b "send\jpg.png\"*.png') do @"adb\adb.exe"  push "send\jpg.png\%%f" /sdcard/Pictures/
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto send
:filemp3
cls
echo.
echo ==============================================
echo =             Send File .mp3                 =
echo ==============================================
for /f "delims=|" %%f in ('dir /b "send\mp3\"*.mp3') do @"adb\adb.exe"  push "send\mp3\%%f" /sdcard/Download/
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto send
:filemp4
cls
echo.
echo ==============================================
echo =             Send File .mp4                 =
echo ==============================================
for /f "delims=|" %%f in ('dir /b "send\mp4.mkv\"*.mp4') do @"adb\adb.exe"  push "send\mp4.mkv\%%f" /sdcard/Download/
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto send
:filemkv
cls
echo.
echo ==============================================
echo =             Send File .mkv                 =
echo ==============================================
for /f "delims=|" %%f in ('dir /b "send\mp4.mkv\"*.mkv') do @"adb\adb.exe"  push "send\mp4.mkv\%%f" /sdcard/Download/
echo.
echo ==================SELESAI=====================
echo ============Otomatis Akan Kembali=============
timeout 3 >nul
goto send
:exit
exit