const fs = require('fs-extra');
const winresourcer = require('winresourcer');
const path = require('path');
const {execFile} = require('child_process');
const program = require('commander');
const archiver = require('archiver');

const WAMP_PATH = path.resolve(__dirname, '../xampp');
const APP_PATH = path.resolve(__dirname, '../');
const skipSliksvn = new Set(['xuanxuan']);

console.log('APP_PATH', APP_PATH);
console.log('WAMP_PATH', WAMP_PATH);

program
    .version('1.0.0')
    .alias('node ./index.js')
    .option('-t, --targets <targets>', 'like zentao, xuanxuan, all, chanzhi, ranzhi or *', '*')
    .option('-a, --arch <arch>', 'like win32, win64 or *', '*')
    .option('-f, --fast', false)
    .option('-e, --example', false)
    .parse(process.argv);

let targets = program.targets || '*';
if (!targets || targets === '*') {
    targets = ['zentao', 'xuanxuan', 'all', 'chanzhi', 'ranzhi'];
} else {
    targets = targets.split(',');
}
let platforms = program.arch || '*';
if (!platforms || platforms === '*') {
    platforms = ['win32', 'win64'];
} else {
    platforms = platforms.split(',');
}
const isFastMode = program.fast;
const includeExample = program.example;
const examplePath = includeExample && fs.pathExistsSync(path.join(WAMP_PATH, 'example-app')) ? path.join(WAMP_PATH, 'example-app') : null;

console.log('Targets', targets);
console.log('Platforms', platforms);
console.log('FastMode', isFastMode);

// 创建 zip 文件
const createZipFromDir = (file, dir, destDir = false) => {
    return new Promise((resolve, reject) => {
        const output = fs.createWriteStream(file);
        const archive = archiver('zip', {
            zlib: {level: 9}
        });
        archive.on('error', reject);
        archive.on('end', resolve);
        archive.pipe(output);
        archive.directory(dir, destDir);
        archive.finalize();
    });
};

const copyLanguageFiles = () => {
    console.log('Copy languages files to common folder...');
    return fs.copy(path.join(APP_PATH, 'languages'), path.join(WAMP_PATH, 'common', 'runner', 'languages'));
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
        const targetPath = path.join(APP_PATH, 'release', isWin32 ? `wamp_${target}_win32` : `wamp_${target}`);
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

            if (platform === 'win32' && fs.existsSync(path.join(WAMP_PATH, `${target}-win32`))) {
                console.log(`\tCopy target special win32 files`);
                fs.copySync(path.join(WAMP_PATH, `${target}-win32`), targetPath);
            }
        }

        if (skipSliksvn.has(target)) {
            fs.removeSync(path.join(targetPath, 'sliksvn'));
        }

        console.log(`\tCopy target exe file`);
        fs.copySync(path.join(APP_PATH, `start-${platform}.exe`), targetExeFile);

        console.log(`\tReplace exe icon`);
        replaceIcon(targetExeFile, path.join(targetPath, 'runner', 'icon.ico')).then(() => {
            if (includeExample) {
                const exampleDirPath = path.join(APP_PATH, 'release/examples', isWin32 ? `wamp_${target}_win32_example` : `wamp_${target}_example`);
                if (!isFastMode) {
                    fs.emptyDirSync(exampleDirPath);
                }
                fs.copySync(targetPath, exampleDirPath);
                if (examplePath) {
                    const exampleAppName = target === 'xuanxuan' ? 'xxb' : target;
                    fs.copySync(examplePath, path.join(exampleDirPath, exampleAppName));
                }
                if (target === 'zentao') {
                    fs.copySync(examplePath, path.join(exampleDirPath, 'zentaoep'));
                    fs.copySync(examplePath, path.join(exampleDirPath, 'zentaopro'));
                } else if (target === 'xuanxuan' && fs.pathExistsSync(path.join(WAMP_PATH, 'xxd'))) {
                    fs.copySync(path.join(WAMP_PATH, 'xxd'), path.join(exampleDirPath, 'xxd'));
                }
            }
            return createZipFromDir(`${targetPath}.zip`, targetPath);
        }).then(resolve).catch(reject);
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
