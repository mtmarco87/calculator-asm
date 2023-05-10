# Calculator ASM app

An introduction to x86_64 assembly on Windows x64 PC.

## Introduction

In this repository I coded a simple Win64 calculator app in assembler, to test 64bits assembly language.
I coded this repository starting from the Win64 HelloWorld example provided here [mcandre/hello.asm](https://gist.github.com/mcandre/b3664ffbeb4f5764b36a397fafb04f1c).

## Prerequisites

While I pretty much assume that people who made it here meet most if not all required prerequisites, it doesn't hurt to list them.

* First of all you need [nasm](https://nasm.us/) assembler, to compile assembly files.

* Secondly you need [Visual Studio build tools](https://visualstudio.microsoft.com/it/downloads/?q=build+tools), to link them into final executables (or you may use [GoLink](https://www.godevtool.com/), but in my examples I will be using the former).

* __NOTE__: I recommend installing the above using [Chocolatey](https://chocolatey.org/install) and running from an elevated powershell terminal: 

    choco install nasm, visualstudio2017buildtools, visualstudio2017-workload-vctools

__PS__: if using chocolatey to install it, be sure to add NASM bin folder manually to the PATH Environment Variable, otherwise makefile will not be able to find the assembler.


## Acknowledgments

I would like to thank [nasm](https://nasm.us/), [@felixcloutier x86/x64 instruction reference](https://www.felixcloutier.com/x86/), [@SenecaCDOT](https://wiki.cdot.senecacollege.ca/wiki/X86_64_Register_and_Instruction_Quick_Start), [@University of Alaska Fairbanks](https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html), [@giobe2000](http://www.giobe2000.it/), [@mcandre](https://gist.github.com/mcandre), [@Hermann Krohn](https://towardsdatascience.com/hello-world-not-so-easy-in-assembly-23da6644ff0d) and [@below](https://github.com/below)! They helped me when I hit a wall.

## Getting Started

### Build the executable (Assemble&Link)

The build is handled via makefile for simplified usage. As far as you meet all of the above prerequisites, the build process will be as simple as:

    make

To explain in more details what's going on under the hood:

1) To assemble the Win64 object file from the source code, the following command is issued:
  
        nasm -f win64 calculator.asm -o out\calculator.obj -g

2) To prepare the needed linker env variables (amd64 libraries/tools/binaries):

        call "C:\\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" amd64

3) Finally, to link the Win64 executable:

        link /entry:start /subsystem:console app.obj kernel32.lib 

__NOTE__: In case of any problems using the makefile, you can opt for the batch compilation script: scripts/createapp yourapp.asm

__NOTE2__: Adjust the step 2) to your version/installation path of Visual Studio build tools (here the configuration has been done for VSTools 2017)

## Tooling Up

### [xd64dbg](https://x64dbg.com/)

This is a __MUST__ :) 

While developing/testing assembly code, you will indeed need to debug and reverse it to understand what's going on under the hood.
I think this tool is one of the best asm debugging tool out there for Windows x86 supporting both 32/64 bits arch.

### Calculator

The default Calculator on Windows has a "Programmer Mode", take advantage of it while ASM coding..

### CPU Registers

Microsoft has made certain platform specific choices for the registers under Windows (check [this](https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html)):

* Microsoft reserves **RBX**, **RBP**, **RSI**, **RDI** registers for its own use. Don't use them without saving in the stack first!
* Same goes for **R12-R15** registers.
* The Win64 function calls convention assumes that the first 4 parameters will be passed in: **RCX**, **RDX**, **R8**, **R9** respectively, and any extra needed param will go in the stack.
* Before any Win64 function call be sure to reserve the mandatory __Win64 home space__ in the stack consisting of 32 bytes + 16 bytes (for alignment purposes). Note: this stack space should also be empty (filled with 0es) to ensure correct functions execution.

### NASM Assembly quick-guide

#### GP Registers

__x86_64 QWORD (64bit) registers__

* Base registers        => rax rbx rcx rdx rbp rsp rsi rdi
* Extended registers    => r8 r9 r10 r11 r12 r13 r14 r15

__x86_64 DWORD (32bit) registers__

* Base registers        => eax ebx ecx edx ebp esp esi edi
* Extended registers    => r8d r9d r10d r11d r12d r13d r14d r15d

__x86_64 WORD (16bit) registers__

* Base registers        => ax bx cx dx bp sp si di
* Extended registers    => r8w r9w r10w r11w r12w r13w r14w r15w

__x86_64 low-WORD (8bit) registers__

* Base registers        => al bl cl dl
* Extended registers    => r8b r9b r10b r11b r12b r13b r14b r15b

__x86_64 high-WORD (8bit) registers__

* Base registers        => ah bh ch dh

#### SSE/AVX Registers

__SSE Registers (128bit)__

* xmm0-15

__AVX Registers (256bit)__

* ymm0-15

__AVX Registers (512bit)__

* zmm0-15


#### NASM data operands size

* 1 byte (8 bit): byte, DB, RESB
* 2 bytes (16 bit): word, DW, RESW
* 4 bytes (32 bit): dword, DD, RESD
* 8 bytes (64 bit): qword, DQ, RESQ
* 10 bytes (80 bit): tword, DT, REST
* 16 bytes (128 bit): oword, DO, RESO, DDQ, RESDQ
* 32 bytes (256 bit): yword, DY, RESY
* 64 bytes (512 bit): zword, DZ, RESZ
