# gros

Grace's operating system :-)

### What's in the box
This repository is intended to keep track of the process of learning to write an operating system. I know close to nothing on this subject matter so this should be fun.

Lecture material is mostly provided on an informal basis by [stewartpark](https://github.com/stewartpark) and reading materials from college courses, Wikipedia, and superuser/stackoverflow/other sources of information.

### [WIP] The learning process
#### Learning Assembly

It helped a lot to write a simple program in C and then whiteboard the corresponding assembly instructions.

- [loop.asm](https://github.com/phenomeno/gros/blob/master/loop.asm)
- [fibonacci.c](https://github.com/phenomeno/gros/blob/master/fibonacci.c)
- [fibo.asm](https://github.com/phenomeno/gros/blob/master/fibo.asm)

Execution Instructions:
```
nasm -f macho64 loop.asm
gcc loop.o
./a.out
```

Debugging:
```
lldb a.out
b main        ; breakpoint at main label
r             ; run
register read ; see values held in register
```

#### Bootloader

The system BIOS will load the bootloader program from an external source of memory into the RAM address: `0000:7c00`. From there, our bootloader will run.

- [bootloader.asm](https://github.com/phenomeno/gros/blob/master/bootloader.asm)

Execution Instructions:
```
nasm -f bin -o bootloader.bin bootloader.asm
dd if=bootloader.bin of=bootloader.flp
qemu-system-i386 -fda bootloader.flp
```

Resources:
- [Explanation of `0000:7c00`](http://stackoverflow.com/a/9340935)
- [Explanation of memory addressing on stackoverflow](http://superuser.com/questions/593847/how-many-memory-addresses-can-we-get-with-a-32-bit-processor-and-1gb-ram)
- https://www.geek.com/chips/difference-between-real-mode-and-protected-mode-574665/
- https://en.wikipedia.org/wiki/Endianness
- http://download.qemu.org/qemu-doc.html

Pending:
- https://www.reinterpretcast.com/creating-a-bare-bones-bootloader
- https://sreeramz.wordpress.com/2012/11/21/hello-world-boot-loader/
- http://mikeos.sourceforge.net/write-your-own-os.html
- https://en.wikipedia.org/wiki/Hexadecimal
- https://samypesse.gitbooks.io/how-to-create-an-operating-system/content/
- https://news.ycombinator.com/item?id=13641949
