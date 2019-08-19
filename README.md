### Description

This repository contains a small testcase demonstrating how GNU gold
from the NDK incorrectly lays out `.note.*` sections.  You should be
able to run:

```
   NDK_DIR=/path/to/ndk ./run.sh ld.gold
```

to build an `libplugin-container.so` library in the current directory.

You can use GNU binutils ld instead:

```
   NDK_DIR=/path/to/ndk ./run.sh ld.bfd
```

### ld.gold bug

Running `readelf -SlW` on a library produced with GNU gold should
produce output similar to:

```
There are 34 section headers, starting at offset 0x1cb8:

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .interp           PROGBITS        0000000000000238 000238 000015 00   A  0   0  1
  [ 2] .note.android.ident NOTE            000000000000024e 00024e 000098 00   A  0   0  2
  [ 3] .note.gnu.build-id NOTE            00000000000002e8 0002e8 000024 00   A  0   0  4
  [ 4] .dynsym           DYNSYM          0000000000000310 000310 0000a8 18   A  5   1  8
  [ 5] .dynstr           STRTAB          00000000000003b8 0003b8 000078 00   A  0   0  1
  [ 6] .hash             HASH            0000000000000430 000430 000030 04   A  4   0  8
  [ 7] .gnu.version      VERSYM          0000000000000460 000460 00000e 02   A  4   0  2
  [ 8] .gnu.version_r    VERNEED         0000000000000470 000470 000040 00   A  5   2  4
  [ 9] .rela.dyn         RELA            00000000000004b0 0004b0 000030 18   A  4   0  8
  [10] .rela.plt         RELA            00000000000004e0 0004e0 000090 18  AI  4  11  8
  [11] .plt              PROGBITS        0000000000000570 000570 000070 10  AX  0   0 16
  [12] .text             PROGBITS        00000000000005e0 0005e0 0000fc 00  AX  0   0 16
  [13] .rodata           PROGBITS        00000000000006dc 0006dc 000070 01 AMS  0   0  1
  [14] .eh_frame         PROGBITS        0000000000000750 000750 0000bc 00   A  0   0  8
  [15] .eh_frame_hdr     PROGBITS        000000000000080c 00080c 000034 00   A  0   0  4
  [16] .preinit_array    PREINIT_ARRAY   0000000000001d38 000d38 000010 00  WA  0   0  8
  [17] .init_array       INIT_ARRAY      0000000000001d48 000d48 000010 00  WA  0   0  8
  [18] .fini_array       FINI_ARRAY      0000000000001d58 000d58 000010 00  WA  0   0  8
  [19] .dynamic          DYNAMIC         0000000000001d68 000d68 000240 10  WA  5   0  8
  [20] .got              PROGBITS        0000000000001fa8 000fa8 000010 00  WA  0   0  8
  [21] .got.plt          PROGBITS        0000000000001fb8 000fb8 000048 00  WA  0   0  8
  [22] .bss              NOBITS          0000000000002000 001000 000008 00  WA  0   0  8
  [23] .comment          PROGBITS        0000000000000000 001000 00011e 01  MS  0   0  1
  [24] .debug_str        PROGBITS        0000000000000000 00111e 0001b6 01  MS  0   0  1
  [25] .debug_loc        PROGBITS        0000000000000000 0012d4 0000eb 00      0   0  1
  [26] .debug_abbrev     PROGBITS        0000000000000000 0013bf 0000aa 00      0   0  1
  [27] .debug_info       PROGBITS        0000000000000000 001469 000121 00      0   0  1
  [28] .debug_macinfo    PROGBITS        0000000000000000 00158a 000001 00      0   0  1
  [29] .debug_line       PROGBITS        0000000000000000 00158b 000169 00      0   0  1
  [30] .note.gnu.gold-version NOTE            0000000000000000 0016f4 00001c 00      0   0  4
  [31] .symtab           SYMTAB          0000000000000000 001710 0002d0 18     32  17  8
  [32] .strtab           STRTAB          0000000000000000 0019e0 000173 00      0   0  1
  [33] .shstrtab         STRTAB          0000000000000000 001b53 000164 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), l (large)
  I (info), L (link order), G (group), T (TLS), E (exclude), x (unknown)
  O (extra OS processing required) o (OS specific), p (processor specific)

Elf file type is DYN (Shared object file)
Entry point 0x5e0
There are 9 program headers, starting at offset 64

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  PHDR           0x000040 0x0000000000000040 0x0000000000000040 0x0001f8 0x0001f8 R   0x8
  INTERP         0x000238 0x0000000000000238 0x0000000000000238 0x000015 0x000015 R   0x1
      [Requesting program interpreter: /system/bin/linker64]
  LOAD           0x000000 0x0000000000000000 0x0000000000000000 0x000840 0x000840 R E 0x1000
  LOAD           0x000d38 0x0000000000001d38 0x0000000000001d38 0x0002c8 0x0002d0 RW  0x1000
  DYNAMIC        0x000d68 0x0000000000001d68 0x0000000000001d68 0x000240 0x000240 RW  0x8
  NOTE           0x00024e 0x000000000000024e 0x000000000000024e 0x0000be 0x0000be R   0x4
  GNU_EH_FRAME   0x00080c 0x000000000000080c 0x000000000000080c 0x000034 0x000034 R   0x4
  GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000 0x000000 0x000000 RW  0x10
  GNU_RELRO      0x000d38 0x0000000000001d38 0x0000000000001d38 0x0002c8 0x0002c8 RW  0x8

 Section to Segment mapping:
  Segment Sections...
   00     
   01     .interp 
   02     .interp .note.android.ident .note.gnu.build-id .dynsym .dynstr .hash .gnu.version .gnu.version_r .rela.dyn .rela.plt .plt .text .rodata .eh_frame .eh_frame_hdr 
   03     .preinit_array .init_array .fini_array .dynamic .got .got.plt .bss 
   04     .dynamic 
   05     .note.android.ident .note.gnu.build-id 
   06     .eh_frame_hdr 
   07     
   08     .preinit_array .init_array .fini_array .dynamic .got .got.plt 
```

The `NOTE` program header is not aligned correctly (although the
sections inside of it probably are aligned correctly?).  It is also
larger than it needs to be, presumably because it has laid out the
`.note.android.ident` section prior to the `.note.gnu.build-id` section
and therefore introduced unnecessary padding.

#### Issues with stripping ld.gold binaries

This problem causes `strip` (`strip libplugin-container.so`) to produce
output that looks like:

```
There are 26 section headers, starting at offset 0x1248:

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .interp           PROGBITS        0000000000000238 000238 000015 00   A  0   0  1
  [ 2] .note.android.ident NOTE            000000000000024e 00024e 000098 00   A  0   0  2
  [ 3] .note.gnu.build-id NOTE            00000000000002e8 0002e8 000024 00   A  0   0  4
  [ 4] .dynsym           DYNSYM          0000000000000310 000310 0000a8 18   A  5   1  8
  [ 5] .dynstr           STRTAB          00000000000003b8 0003b8 000078 00   A  0   0  1
  [ 6] .hash             HASH            0000000000000430 000430 000030 04   A  4   0  8
  [ 7] .gnu.version      VERSYM          0000000000000460 000460 00000e 02   A  4   0  2
  [ 8] .gnu.version_r    VERNEED         0000000000000470 000470 000040 00   A  5   2  4
  [ 9] .rela.dyn         RELA            00000000000004b0 0004b0 000030 18   A  4   0  8
  [10] .rela.plt         RELA            00000000000004e0 0004e0 000090 18  AI  4  21  8
  [11] .plt              PROGBITS        0000000000000570 000570 000070 10  AX  0   0 16
  [12] .text             PROGBITS        00000000000005e0 0005e0 0000fc 00  AX  0   0 16
  [13] .rodata           PROGBITS        00000000000006dc 0006dc 000070 01 AMS  0   0  1
  [14] .eh_frame         PROGBITS        0000000000000750 000750 0000bc 00   A  0   0  8
  [15] .eh_frame_hdr     PROGBITS        000000000000080c 00080c 000034 00   A  0   0  4
  [16] .preinit_array    PREINIT_ARRAY   0000000000001d38 000d38 000010 00  WA  0   0  8
  [17] .init_array       INIT_ARRAY      0000000000001d48 000d48 000010 00  WA  0   0  8
  [18] .fini_array       FINI_ARRAY      0000000000001d58 000d58 000010 00  WA  0   0  8
  [19] .dynamic          DYNAMIC         0000000000001d68 000d68 000240 10  WA  5   0  8
  [20] .got              PROGBITS        0000000000001fa8 000fa8 000010 00  WA  0   0  8
  [21] .got.plt          PROGBITS        0000000000001fb8 000fb8 000048 00  WA  0   0  8
  [22] .bss              NOBITS          0000000000002000 001000 000008 00  WA  0   0  8
  [23] .comment          PROGBITS        0000000000000000 001000 00011e 01  MS  0   0  1
  [24] .note.gnu.gold-version NOTE            0000000000000000 001120 00001c 00      0   0  4
  [25] .shstrtab         STRTAB          0000000000000000 00113c 000109 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), l (large)
  I (info), L (link order), G (group), T (TLS), E (exclude), x (unknown)
  O (extra OS processing required) o (OS specific), p (processor specific)

Elf file type is DYN (Shared object file)
Entry point 0x5e0
There are 9 program headers, starting at offset 64

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  PHDR           0x000040 0x0000000000000040 0x0000000000000040 0x0001f8 0x0001f8 R   0x8
  INTERP         0x000238 0x0000000000000238 0x0000000000000238 0x000015 0x000015 R   0x1
      [Requesting program interpreter: /system/bin/linker64]
  LOAD           0x000000 0x0000000000000000 0x0000000000000000 0x000840 0x000840 R E 0x1000
  LOAD           0x000d38 0x0000000000001d38 0x0000000000001d38 0x0002c8 0x0002d0 RW  0x1000
  DYNAMIC        0x000d68 0x0000000000001d68 0x0000000000001d68 0x000240 0x000240 RW  0x8
  NOTE           0x00024e 0x000000000000024e 0x000000000000024e 0x0000be 0x0000bc R   0x4
  GNU_EH_FRAME   0x00080c 0x000000000000080c 0x000000000000080c 0x000034 0x000034 R   0x4
  GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000 0x000000 0x000000 RW  0x10
  GNU_RELRO      0x000d38 0x0000000000001d38 0x0000000000001d38 0x0002c8 0x0002c8 RW  0x8

 Section to Segment mapping:
  Segment Sections...
   00     
   01     .interp 
   02     .interp .note.android.ident .note.gnu.build-id .dynsym .dynstr .hash .gnu.version .gnu.version_r .rela.dyn .rela.plt .plt .text .rodata .eh_frame .eh_frame_hdr 
   03     .preinit_array .init_array .fini_array .dynamic .got .got.plt .bss 
   04     .dynamic 
   05     .note.android.ident 
   06     .eh_frame_hdr 
   07     
   08     .preinit_array .init_array .fini_array .dynamic .got .got.plt 
```

The `NOTE` program header is still not aligned correctly, the
`.note.gnu.build-id` section is no longer present within it, and the
in-memory size is smaller than the on-disk size, which causes other
tools to fail consistency checks.

### binutils ld

In contrast, using binutils ld:

```
   NDK_DIR=/path/to/ndk ./run.sh ld.bfd
```

gives `readelf -SlW` output like:

```
There are 32 section headers, starting at offset 0x1fe8:

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .interp           PROGBITS        0000000000000270 000270 000015 00   A  0   0  1
  [ 2] .note.android.ident NOTE            0000000000000286 000286 000098 00   A  0   0  2
  [ 3] .note.gnu.build-id NOTE            0000000000000320 000320 000024 00   A  0   0  4
  [ 4] .hash             HASH            0000000000000348 000348 00003c 04   A  5   0  8
  [ 5] .dynsym           DYNSYM          0000000000000388 000388 0000f0 18   A  6   1  8
  [ 6] .dynstr           STRTAB          0000000000000478 000478 0000a8 00   A  0   0  1
  [ 7] .gnu.version      VERSYM          0000000000000520 000520 000014 02   A  5   0  2
  [ 8] .gnu.version_r    VERNEED         0000000000000538 000538 000040 00   A  6   2  8
  [ 9] .rela.dyn         RELA            0000000000000578 000578 0000c0 18   A  5   0  8
  [10] .plt              PROGBITS        0000000000000640 000640 000010 10  AX  0   0 16
  [11] .plt.got          PROGBITS        0000000000000650 000650 000030 00  AX  0   0  8
  [12] .text             PROGBITS        0000000000000680 000680 0000fc 00  AX  0   0 16
  [13] .rodata           PROGBITS        000000000000077c 00077c 000070 01 AMS  0   0  1
  [14] .eh_frame_hdr     PROGBITS        00000000000007ec 0007ec 000034 00   A  0   0  4
  [15] .eh_frame         X86_64_UNWIND   0000000000000820 000820 0000bc 00   A  0   0  8
  [16] .preinit_array    PREINIT_ARRAY   0000000000200d78 000d78 000010 08  WA  0   0  8
  [17] .init_array       INIT_ARRAY      0000000000200d88 000d88 000010 08  WA  0   0  8
  [18] .fini_array       FINI_ARRAY      0000000000200d98 000d98 000010 08  WA  0   0  8
  [19] .dynamic          DYNAMIC         0000000000200da8 000da8 000200 10  WA  6   0  8
  [20] .got              PROGBITS        0000000000200fa8 000fa8 000058 08  WA  0   0  8
  [21] .bss              NOBITS          0000000000201000 001000 000008 00  WA  0   0  8
  [22] .comment          PROGBITS        0000000000000000 001000 00011d 01  MS  0   0  1
  [23] .debug_info       PROGBITS        0000000000000000 00111d 000121 00      0   0  1
  [24] .debug_abbrev     PROGBITS        0000000000000000 00123e 0000aa 00      0   0  1
  [25] .debug_line       PROGBITS        0000000000000000 0012e8 000169 00      0   0  1
  [26] .debug_str        PROGBITS        0000000000000000 001451 0001b2 01  MS  0   0  1
  [27] .debug_loc        PROGBITS        0000000000000000 001603 0000eb 00      0   0  1
  [28] .debug_macinfo    PROGBITS        0000000000000000 0016ee 000001 00      0   0  1
  [29] .shstrtab         STRTAB          0000000000000000 001ea3 000143 00      0   0  1
  [30] .symtab           SYMTAB          0000000000000000 0016f0 0005b8 18     31  45  8
  [31] .strtab           STRTAB          0000000000000000 001ca8 0001fb 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), l (large)
  I (info), L (link order), G (group), T (TLS), E (exclude), x (unknown)
  O (extra OS processing required) o (OS specific), p (processor specific)

Elf file type is DYN (Shared object file)
Entry point 0x680
There are 10 program headers, starting at offset 64

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  PHDR           0x000040 0x0000000000000040 0x0000000000000040 0x000230 0x000230 R E 0x8
  INTERP         0x000270 0x0000000000000270 0x0000000000000270 0x000015 0x000015 R   0x1
      [Requesting program interpreter: /system/bin/linker64]
  LOAD           0x000000 0x0000000000000000 0x0000000000000000 0x0008dc 0x0008dc R E 0x200000
  LOAD           0x000d78 0x0000000000200d78 0x0000000000200d78 0x000288 0x000290 RW  0x200000
  DYNAMIC        0x000da8 0x0000000000200da8 0x0000000000200da8 0x000200 0x000200 RW  0x8
  NOTE           0x000286 0x0000000000000286 0x0000000000000286 0x000098 0x000098 R   0x2
  NOTE           0x000320 0x0000000000000320 0x0000000000000320 0x000024 0x000024 R   0x4
  GNU_EH_FRAME   0x0007ec 0x00000000000007ec 0x00000000000007ec 0x000034 0x000034 R   0x4
  GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000 0x000000 0x000000 RW  0x10
  GNU_RELRO      0x000d78 0x0000000000200d78 0x0000000000200d78 0x000288 0x000288 R   0x1

 Section to Segment mapping:
  Segment Sections...
   00     
   01     .interp 
   02     .interp .note.android.ident .note.gnu.build-id .hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .plt .plt.got .text .rodata .eh_frame_hdr .eh_frame 
   03     .preinit_array .init_array .fini_array .dynamic .got .bss 
   04     .dynamic 
   05     .note.android.ident 
   06     .note.gnu.build-id 
   07     .eh_frame_hdr 
   08     
   09     .preinit_array .init_array .fini_array .dynamic .got
```

Note how the `.note.*` sections with differing alignments have wound up
in different segments, each with appropriate alignments.  `strip` works
correctly on a `ld.bfd`-produced library.
