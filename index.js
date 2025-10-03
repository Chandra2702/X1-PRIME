#!/usr/bin/env node
/**
 * multi-tools-unlock-x1 - Node.js port of the batch menu
 * index.js
 */
const { execFileSync, spawnSync } = require("child_process");
const fs = require("fs");
const path = require("path");
const inquirer = require("inquirer");
const chalk = require("chalk");

const root = process.cwd();
const adbFolder = path.join(root, "adb");
const adbExecutable = fs.existsSync(path.join(adbFolder, "adb.exe"))
  ? path.join(adbFolder, "adb.exe")
  : fs.existsSync(path.join(adbFolder, "adb"))
    ? path.join(adbFolder, "adb")
    : "adb"; // fallback ke PATH

function runAdb(args = [], options = {}) {
  try {
    const cmd = adbExecutable;
    // use spawnSync to stream output and not rely on shell
    const res = spawnSync(cmd, args, { stdio: "inherit", ...options });
    if (res.error) {
      console.error(chalk.red(`Error menjalankan adb: ${res.error.message}`));
      return false;
    }
    return res.status === 0;
  } catch (e) {
    console.error(chalk.red(`Exception menjalankan adb: ${e.message}`));
    return false;
  }
}

function listFiles(dir, ext = ".apk") {
  try {
    const full = path.join(root, dir);
    if (!fs.existsSync(full)) return [];
    return fs.readdirSync(full).filter(f => f.toLowerCase().endsWith(ext));
  } catch (e) {
    console.error(chalk.red(`Error membaca folder ${dir}: ${e.message}`));
    return [];
  }
}

function installApksFromFolder(folder) {
  const files = listFiles(folder, ".apk");
  if (files.length === 0) {
    console.log(chalk.yellow(`Tidak ada file .apk di folder ${folder}`));
    return;
  }
  for (const f of files) {
    const apkPath = path.join(root, folder, f);
    console.log(chalk.cyan(`Installing ${apkPath} ...`));
    runAdb(["install", "-r", apkPath]);
  }
}

async function sendFilesMenu() {
  const choices = [
    { name: "File .apk", value: "apk" },
    { name: "File .jpg", value: "jpg" },
    { name: "File .png", value: "png" },
    { name: "File .mp3", value: "mp3" },
    { name: "File .mp4", value: "mp4" },
    { name: "File .mkv", value: "mkv" },
    { name: "Kembali", value: "back" }
  ];
  while (true) {
    const ans = await inquirer.prompt([{
      type: "list",
      name: "sendChoice",
      message: "Pilih tipe file untuk dikirim:",
      choices
    }]);
    if (ans.sendChoice === "back") return;
    switch (ans.sendChoice) {
      case "apk":
        installApksFromFolder(path.join("send","apk"));
        break;
      case "jpg":
        pushFilesToDevice(path.join("send","jpg.png"), "/sdcard/Pictures/");
        break;
      case "png":
        pushFilesToDevice(path.join("send","jpg.png"), "/sdcard/Pictures/");
        break;
      case "mp3":
        pushFilesToDevice(path.join("send","mp3"), "/sdcard/Download/");
        break;
      case "mp4":
        pushFilesToDevice(path.join("send","mp4.mkv"), "/sdcard/Download/");
        break;
      case "mkv":
        pushFilesToDevice(path.join("send","mp4.mkv"), "/sdcard/Download/");
        break;
      default:
        console.log("Pilihan tidak dikenal.");
    }
    console.log(chalk.green("=== SELESAI ==="));
  }
}

function pushFilesToDevice(folderRelative, devicePath) {
  const folder = path.join(root, folderRelative);
  if (!fs.existsSync(folder)) {
    console.log(chalk.yellow(`Folder tidak ditemukan: ${folderRelative}`));
    return;
  }
  const files = fs.readdirSync(folder).filter(f => fs.statSync(path.join(folder,f)).isFile());
  if (files.length === 0) {
    console.log(chalk.yellow(`Tidak ada file di ${folderRelative}`));
    return;
  }
  for (const f of files) {
    const local = path.join(folder, f);
    console.log(chalk.cyan(`Pushing ${local} -> ${devicePath}`));
    runAdb(["push", local, devicePath]);
  }
}

async function mainMenu() {
  while (true) {
    console.clear();
    console.log(chalk.white.bgBlue("=============================================="));
    console.log(chalk.bold("=             MULTI UNLOCK TOOLS             ="));
    console.log(chalk.bold("=             FirsMedia X1-PRIME             ="));
    console.log(chalk.bold("=             by Andriy Chandra              ="));
    console.log(chalk.white.bgBlue("=============================================="));
    console.log("#   Langkah-langkah yg harus diperhatikan    #");
    console.log("----------------------------------------------");
    console.log("# - PC dan STB wajib 1 SSID WIFI yang sama   #");
    console.log("# - Pilih Connect input ip WIFI yg ada di STB#");
    console.log("# - Muncul PopUp di STB centang dan izinkan  #");
    console.log("==============================================");
    const ans = await inquirer.prompt([{
      type: "list",
      name: "menu",
      message: "Pilih menu:",
      choices: [
        { name: "1. Connect/Hubungkan", value: "connect" },
        { name: "2. Install Launcher", value: "launcher" },
        { name: "3. Unlock X1 Prime-C OS9", value: "cos9" },
        { name: "4. Unlock X1 Prime-C OS11", value: "cos11" },
        { name: "5. Izinkan Widget ATV", value: "widget" },
        { name: "6. Install APK Massal", value: "apk" },
        { name: "7. Send Files To TV/STB", value: "send" },
        { name: "0. Exit", value: "exit" }
      ]
    }]);

    switch (ans.menu) {
      case "connect":
        await handleConnect();
        break;
      case "launcher":
        installApksFromFolder("launcher");
        await pauseAutoReturn();
        break;
      case "cos9":
        installApksFromFolder(path.join("unlock","OS9"));
        runUninstallList(cos9Uninstalls);
        await pauseAutoReturn();
        break;
      case "cos11":
        installApksFromFolder(path.join("unlock","OS11"));
        runUninstallList(cos11Uninstalls);
        await pauseAutoReturn();
        break;
      case "widget":
        runAdb(["shell", "appwidget", "grantbind", "--package", "ca.dstudio.atvlauncher.pro", "--user", "0"]);
        console.log(chalk.green("Success"));
        await pauseAutoReturn();
        break;
      case "apk":
        installApksFromFolder(path.join("send","apk"));
        await pauseAutoReturn();
        break;
      case "send":
        await sendFilesMenu();
        break;
      case "exit":
        console.log("Bye!");
        process.exit(0);
      default:
        console.log("Pilihan tidak valid");
    }
  }
}

async function handleConnect() {
  const ans = await inquirer.prompt([{
    type: "input",
    name: "ip",
    message: "Masukan Alamat ip :",
    validate: v => v && v.trim() !== "" ? true : "Isi IP terlebih dahulu"
  }]);
  console.log(chalk.cyan(`Menghubungkan ke ${ans.ip} ...`));
  runAdb(["connect", ans.ip]);
  await pauseAutoReturn();
}

function pauseAutoReturn(seconds = 3) {
  return new Promise(resolve => {
    console.log(chalk.gray(`\n=========== Otomatis Akan Kembali (${seconds}s) =============`));
    setTimeout(resolve, seconds * 1000);
  });
}

function runUninstallList(packages) {
  for (const pkg of packages) {
    console.log(chalk.cyan(`Uninstall: ${pkg}`));
    runAdb(["shell", "pm", "uninstall", "--user", "0", pkg]);
  }
}

// lists from batch file
const cos9Uninstalls = [
  "com.google.android.play.games",
  "com.google.android.music",
  "com.google.android.tv",
  "com.google.android.videos",
  "com.hisilicon.hardwaretest",
  "com.hikeymasterprovision",
  "com.playreadyprovision",
  "com.tvstorm.launcher.jiuzhou",
  "com.tvstorm.tv.upgrader.jiuzhou"
];

const cos11Uninstalls = [
  "com.tvstorm.adjustscreenoffset.linknet.jiuzhou.hybrid2.ui3",
  "com.tvstorm.administrator.linknet.jiuzhou.hybrid2.ui3",
  "com.tvstorm.customizer.linknet.jiuzhou.hybrid2.ui3",
  "com.tvstorm.hiddenmenu.linknet.jiuzhou.hybrid2.ui3",
  "com.tvstorm.linknetcable.linknet.jiuzhou.hybrid2.ui3",
  "com.tvstorm.launcher3.linknet.jiuzhou.hybrid2.ui3",
  "com.tvstorm.tv.upgrader.linknet.jiuzhou.hybrid2.ui3",
  "com.tvstorm.linknetiptv.linknet.jiuzhou.hybrid2.ui3",
  "com.tvstorm.pvr.linknet.jiuzhou.hybrid2.ui3",
  "com.tvstorm.service.linknet.jiuzhou.hybrid2.ui3"
];

(async () => {
  try {
    await mainMenu();
  } catch (e) {
    console.error(chalk.red("Fatal error:"), e);
    process.exit(1);
  }
})();
