echo 1
#assemble boot.s file
as --64 boot/boot.s -o compiled/boot.o

echo 2
#compile kernel.c file
if (as --64 $1 -o compiled/kernel.o) ; then
    echo 3
    #linking the kernel with kernel.o and boot.o files
    if (ld -m elf_x86_64 -T boot/linker.ld compiled/kernel.o compiled/boot.o -o compiled/MyOS.bin -nostdlib) ; then
        echo 4
        #check MyOS.bin file is x86 multiboot file or not
        grub-file --is-x86-multiboot compiled/MyOS.bin

        #building the iso file
        mkdir -p isodir/boot/grub
        cp compiled/MyOS.bin isodir/boot/MyOS.bin
        cp boot/grub.cfg isodir/boot/grub/grub.cfg
        grub-mkrescue -o compiled/MyOS.iso isodir

        #run the qemu
        qemu-system-x86_64 -cdrom compiled/MyOS.iso
    fi
fi