const fs = require('fs-extra');
const winresourcer = require('winresourcer');
const path = require('path');
const {execFile} = require('child_process');

const WAMP_PATH = path.resolve(__dirname, '../xampp');
const APP_PATH = path.resolve(__dirname, '../');

console.log('APP_PATH', APP_PATH);
console.log('WAMP_PATH', WAMP_PATH);

let targets = process.argv[2] || '*';
if (!targets || targets === '*') {
    targets = ['zentao', 'xuanxuan', 'all', 'chanzhi', 'ranzhi'];
} else {
    targets = targets.split(',');
}
let platforms = process.argv[3] || '*';
if (!platforms || platforms === '*') {
    platforms = ['win32', 'win64'];
} else {
    platforms = platforms.split(',');
}
const isFastMode = !!process.argv[4];

console.log('Targets', targets);
console.log('Platforms', platforms);
console.log('FastMode', isFastMode);

const copyLanguageFiles = () => {
    console.log('Copy languages files to common folder...');
    return fs.copy(path.join(APP_PATH, 'languages'), path.join(WAMP_PATH, 'common', 'languages'));
};

const replaceIcon = (targetExeFile, iconFile) => {
    return new Promise((resolve, reject) => {
        // return resolve();
        winresourcer({
            operation: "Update", // one of Add, Update, Extract or Delete
            exeFile: targetExeFile,
            resourceType: "Icongroup",
            resourceName: "MAINICON",
            lang: '0', // Required, except when updating or deleting 
            resourceFile: iconFile // Required, except when deleting
        }, (err) => {
            if(err) {
                console.log('ERROR: replaceIcon error', err);
                reject(err);
            } else {
                console.log('replaceIcon ok');
                resolve();
            }
        });
    });
};

const buildTarget = (target, platform = 'win64') => {
    console.log(`Build target: ${target} - ${platform}...`);
    return new Promise((resolve, reject) => {
        const isWin32 = platform === 'win32';
        const targetPath = path.join(WAMP_PATH, isWin32 ? `wamp-${target}-win32` : `wamp-${target}`);
        const targetExeFile = path.join(targetPath, 'start.exe');

        if (!isFastMode) {
            console.log(`\tClear path ${targetPath}`);
            fs.emptyDirSync(targetPath);
        }

        console.log(`\tCopy common files`);
        fs.copySync(path.join(WAMP_PATH, 'common'), targetPath);
        fs.copySync(path.join(WAMP_PATH, `common-${platform}`), targetPath);

        if (!isFastMode) {
            console.log(`\tCopy wamp files`);
            fs.copySync(path.join(WAMP_PATH, isWin32 ? 'common-wamp-win32' : 'common-wamp'), targetPath);

            console.log(`\tCopy target special files`);
            fs.copySync(path.join(WAMP_PATH, target), targetPath);
        }

        console.log(`\tCopy target exe file`);
        fs.copySync(path.join(APP_PATH, `start-${platform}.exe`), targetExeFile);

        console.log(`\tReplace exe icon`);
        return replaceIcon(targetExeFile, path.join(targetPath, 'runner', 'icon.ico')).then(resolve).catch(reject);
    });
};

const build = async () => {
    console.log('\nBuild begin:\n----------------------------------------');

    await copyLanguageFiles();

    for (let i = 0; i < targets.length; ++i) {
        const target = targets[i];
        for (let j = 0; j < platforms.length; ++j) {
            const platform = platforms[j];
            await buildTarget(target, platform);
        }
    }

    console.log('----------------------------------------\nBuild finished.');
};

build();
