const util = require('util');
const exec = util.promisify(require('child_process').exec);
const fs = require("fs")

var path = process.argv[2]
var data = JSON.parse(String(fs.readFileSync(path + "/data.json")))

path = "../" + path
var hostname = data.entry
var tolink = data.link

    ; (async function main() {
        await qexec(`rm -r /home/kali/Documents/asmOS/BODY/compiled/*`) // clean
        await qexec(`as --32 boot/boot.s -o compiled/boot.o`) // bootloader
        for (var i = 0; i < tolink.length; i++) {
            var special = tolink[i].slice(0, -2)
            if (special.includes("/")) {
                special = special.split(/\//g).pop();
                console.log(special)
            }

            await qexec(`as --32 ${path}/${tolink[i]} -o compiled/${special}.o`) // all other files

        }

        for (var i = 0; i < tolink.length; i++) {
            if (tolink[i].includes("/"))
                tolink[i] = tolink[i].split(/\//g).pop();
        }

        await qexec(`as --32 ${path}/${hostname} -o compiled/kernel.o`) // kernel
        // link
        await qexec(`ld -m elf_i386 -T boot/linker.ld compiled/kernel.o ${tolink.map(x => `compiled/${x.slice(0, -2)}.o`).join(" ")} compiled/boot.o -o compiled/MyOS.bin -nostdlib`)

        await qexec(`grub-file --is-x86-multiboot compiled/MyOS.bin`)
        await qexec(`mkdir -p isodir/boot/grub`)
        await qexec(`cp compiled/MyOS.bin isodir/boot/MyOS.bin`)
        await qexec(`cp boot/grub.cfg isodir/boot/grub/grub.cfg`)
        await qexec(`grub-mkrescue -o compiled/MyOS.iso isodir`)
        await qexec(`qemu-system-x86_64 -cdrom compiled/MyOS.iso`)
    })()

async function qexec(cm) {
    try {
        const { stdout, stderr } = await exec(cm, { cwd: '/home/kali/Documents/asmOS/BODY/' });
        if (stdout != "")
            console.log('stdout:', stdout);
        if (stderr != "")
            console.log('stderr:', stderr);
    } catch (e) {
        console.error(e); // should contain code (exit code) and signal (that caused the termination).
        process.exit(0)
    }
}
