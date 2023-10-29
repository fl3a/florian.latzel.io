---
layout: post
title: "CO2 sparen II: Das Jekyll Picture Tag Plugin"
tags:
- howto
- Jekyll
- liquid
- netzaffe
- Nachhaltigkeit
- uberspace
---
In 2023

<picture>
  <source media="(max-width:450px)" srcset="{% picture mobile-webp gears-of-industry.jpg %}">
  <source media="(min-width:451px) and (max-width:660px)" srcset="{% picture middle-webp gears-of-industry.jpg %}">
  <source media="(min-width:661px)" srcset="{% picture full-webp gears-of-industry.jpg %}">
  <img src="{% picture fallback-webp gears-of-industry.jpg %}" alt="alt">
</picture>
  Direct + webp
  <img src="{% picture full-webp lpic-2-certification-florian-latzel.png %}" alt="alt">
  jPT Default
  {%picture lpic-2-certification-florian-latzel.png %}
<!--break-->
## libvips 

### Local

```
➜  florian.latzel.io git:(picture) ✗ sudo apt install libvips  libvips-dev                             
Paketlisten werden gelesen… Fertig
Abhängigkeitsbaum wird aufgebaut… Fertig
Statusinformationen werden eingelesen… Fertig
Hinweis: »libvips42« wird an Stelle von »libvips« gewählt.
Die folgenden zusätzlichen Pakete werden installiert:
  libaec0 libcfitsio9 libgsl25 libgslcblas0 libhdf5-103-1 libmatio11 libopenslide0 libsz2 nip2
Vorgeschlagene Pakete:
  gsl-ref-psdoc | gsl-doc-pdf | gsl-doc-info | gsl-ref-html libvips-doc libvips-tools
Die folgenden NEUEN Pakete werden installiert:
  libaec0 libcfitsio9 libgsl25 libgslcblas0 libhdf5-103-1 libmatio11 libopenslide0 libsz2 libvips42 nip2
0 aktualisiert, 10 neu installiert, 0 zu entfernen und 9 nicht aktualisiert.
Es müssen 8.894 kB an Archiven heruntergeladen werden.
Nach dieser Operation werden 28,4 MB Plattenplatz zusätzlich benutzt.
Möchten Sie fortfahren? [J/n] j
Holen:1 http://deb.debian.org/debian bullseye/main amd64 libaec0 amd64 1.0.4-1 [20,3 kB]
Holen:2 http://deb.debian.org/debian bullseye/main amd64 libcfitsio9 amd64 3.490-3 [554 kB]
Holen:3 http://deb.debian.org/debian bullseye/main amd64 libgslcblas0 amd64 2.6+dfsg-2 [102 kB]
Holen:4 http://deb.debian.org/debian bullseye/main amd64 libgsl25 amd64 2.6+dfsg-2 [934 kB]
Holen:5 http://deb.debian.org/debian bullseye/main amd64 libsz2 amd64 1.0.4-1 [6.760 B]
Holen:6 http://deb.debian.org/debian bullseye/main amd64 libhdf5-103-1 amd64 1.10.6+repack-4+deb11u1 [1.189 kB]
Holen:7 http://deb.debian.org/debian bullseye/main amd64 libmatio11 amd64 1.5.19-2 [99,5 kB]
Holen:8 http://deb.debian.org/debian bullseye/main amd64 libopenslide0 amd64 3.4.1+dfsg-5 [87,5 kB]
Holen:9 http://deb.debian.org/debian bullseye/main amd64 libvips42 amd64 8.10.5-2 [1.124 kB]
Holen:10 http://deb.debian.org/debian bullseye/main amd64 nip2 amd64 8.7.1-2 [4.777 kB]
Es wurden 8.894 kB in 0 s geholt (24,1 MB/s).
Vormals nicht ausgewähltes Paket libaec0:amd64 wird gewählt.
(Lese Datenbank ... 382666 Dateien und Verzeichnisse sind derzeit installiert.)
Vorbereitung zum Entpacken von .../0-libaec0_1.0.4-1_amd64.deb ...
Entpacken von libaec0:amd64 (1.0.4-1) ...
Vormals nicht ausgewähltes Paket libcfitsio9:amd64 wird gewählt.
Vorbereitung zum Entpacken von .../1-libcfitsio9_3.490-3_amd64.deb ...
Entpacken von libcfitsio9:amd64 (3.490-3) ...
Vormals nicht ausgewähltes Paket libgslcblas0:amd64 wird gewählt.
Vorbereitung zum Entpacken von .../2-libgslcblas0_2.6+dfsg-2_amd64.deb ...
Entpacken von libgslcblas0:amd64 (2.6+dfsg-2) ...
Vormals nicht ausgewähltes Paket libgsl25:amd64 wird gewählt.
Vorbereitung zum Entpacken von .../3-libgsl25_2.6+dfsg-2_amd64.deb ...
Entpacken von libgsl25:amd64 (2.6+dfsg-2) ...
Vormals nicht ausgewähltes Paket libsz2:amd64 wird gewählt.
Vorbereitung zum Entpacken von .../4-libsz2_1.0.4-1_amd64.deb ...
Entpacken von libsz2:amd64 (1.0.4-1) ...
Vormals nicht ausgewähltes Paket libhdf5-103-1:amd64 wird gewählt.
Vorbereitung zum Entpacken von .../5-libhdf5-103-1_1.10.6+repack-4+deb11u1_amd64.deb ...
Entpacken von libhdf5-103-1:amd64 (1.10.6+repack-4+deb11u1) ...
Vormals nicht ausgewähltes Paket libmatio11:amd64 wird gewählt.
Vorbereitung zum Entpacken von .../6-libmatio11_1.5.19-2_amd64.deb ...
Entpacken von libmatio11:amd64 (1.5.19-2) ...
Vormals nicht ausgewähltes Paket libopenslide0 wird gewählt.
Vorbereitung zum Entpacken von .../7-libopenslide0_3.4.1+dfsg-5_amd64.deb ...
Entpacken von libopenslide0 (3.4.1+dfsg-5) ...
Vormals nicht ausgewähltes Paket libvips42:amd64 wird gewählt.
Vorbereitung zum Entpacken von .../8-libvips42_8.10.5-2_amd64.deb ...
Entpacken von libvips42:amd64 (8.10.5-2) ...
Vormals nicht ausgewähltes Paket nip2 wird gewählt.
Vorbereitung zum Entpacken von .../9-nip2_8.7.1-2_amd64.deb ...
Entpacken von nip2 (8.7.1-2) ...
libgslcblas0:amd64 (2.6+dfsg-2) wird eingerichtet ...
libgsl25:amd64 (2.6+dfsg-2) wird eingerichtet ...
libaec0:amd64 (1.0.4-1) wird eingerichtet ...
libcfitsio9:amd64 (3.490-3) wird eingerichtet ...
libopenslide0 (3.4.1+dfsg-5) wird eingerichtet ...
libsz2:amd64 (1.0.4-1) wird eingerichtet ...
libhdf5-103-1:amd64 (1.10.6+repack-4+deb11u1) wird eingerichtet ...
libmatio11:amd64 (1.5.19-2) wird eingerichtet ...
libvips42:amd64 (8.10.5-2) wird eingerichtet ...
nip2 (8.7.1-2) wird eingerichtet ...
Trigger für doc-base (0.11.1) werden verarbeitet ...
1 hinzugefügte Doc-base-Datei wird verarbeitet...
Trigger für gnome-menus (3.36.0-1) werden verarbeitet ...
Trigger für libc-bin (2.31-13+deb11u6) werden verarbeitet ...
Trigger für man-db (2.9.4-2) werden verarbeitet ...
Trigger für shared-mime-info (2.0-1) werden verarbeitet ...
Trigger für mailcap (3.69) werden verarbeitet ...
Trigger für desktop-file-utils (0.26-1) werden verarbeitet ...
```

## remote/ (uberspace)
 
### Meson 

Libvips verwendet Meson als Build System.

```
➜  vips-8.14.5 meson 
zsh: command not found: meson
➜  vips-8.14.5 pip3 install --user meson
Collecting meson
  Downloading https://files.pythonhosted.org/packages/18/db/3feb3cfa102553b9329d0c887b3c10480381de69abf6e8629f6b32f450df/meson-0.61.5-py3-none-any.whl (862kB)
    100% |████████████████████████████████| 870kB 1.0MB/s 
Installing collected packages: meson
Successfully installed meson-0.61.5
➜  vips-8.14.5 meson                    
zsh: command not found: meson
```
PATH

```
export PATH=$HOME/.local/bin:$HOME/bin:$PATH
```

```
wget https://github.com/libvips/libvips/releases/download/v8.14.5/vips-8.14.5.tar.xz
tar xf vips-8.14.5.tar.xz
cd vips-8.14.5
```

### Ninja

https://ninja-build.org/

> Meson can use ninja, Visual Studio or XCode as a backend, so you’ll also need one of them.
```
➜  vips-8.14.5 python -m pip install --user ninja
Collecting ninja
  Using cached https://files.pythonhosted.org/packages/58/9a/929f2deeffca632f5e031306e4884e37a1766fe4fd098c68283408016ff0/ninja-1.11.1-py2.py3-none-manylinux_2_5_x86_64.manylinux1_x86_64.whl
Installing collected packages: ninja
Successfully installed ninja
You are using pip version 8.1.2, however version 23.2.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
```
### Building libvips from source 
```
➜  vips-8.14.5 meson setup build-dir --prefix=$HOME
The Meson build system
Version: 0.61.5
Source dir: /home/kdoz/vips-8.14.5
Build dir: /home/kdoz/vips-8.14.5/build-dir
Build type: native build
Project name: vips
Project version: 8.14.5
C compiler for the host machine: cc (gcc 9.3.1 "cc (GCC) 9.3.1 20200408 (Red Hat 9.3.1-2)")
C linker for the host machine: cc ld.bfd 2.32-16
C++ compiler for the host machine: c++ (gcc 9.3.1 "c++ (GCC) 9.3.1 20200408 (Red Hat 9.3.1-2)")
C++ linker for the host machine: c++ ld.bfd 2.32-16
Host machine cpu family: x86_64
Host machine cpu: x86_64
Compiler for C supports arguments -Werror=pointer-arith: YES 
Found pkg-config: /usr/bin/pkg-config (0.27.1)
Run-time dependency glib-2.0 found: YES 2.56.1
Run-time dependency gio-2.0 found: YES 2.56.1
Run-time dependency gobject-2.0 found: YES 2.56.1
Run-time dependency gmodule-no-export-2.0 found: YES 2.56.1
Run-time dependency expat found: YES 2.1.0
Run-time dependency threads found: YES
Library m found: YES
Compiler for C supports link arguments -Wl,-z,nodelete: YES 
Compiler for C supports function attribute visibility:hidden: YES 
Checking if "Has vector arithmetic" with dependency -lm compiles: YES 
Checking if "Has signed constants in vector templates" with dependency -lm compiles: YES 
Checking for function "vsnprintf" with dependency -lm: YES 
Checking for function "_aligned_malloc" with dependency -lm: NO 
Checking for function "posix_memalign" with dependency -lm: YES 
Checking for function "memalign" with dependency -lm: YES 
Checking for function "cbrt" with dependency -lm: YES 
Checking for function "hypot" with dependency -lm: YES 
Checking for function "atan2" with dependency -lm: YES 
Checking for function "asinh" with dependency -lm: YES 
Checking for function "pthread_setattr_default_np" with dependency threads: NO 
Run-time dependency zlib found: YES 1.2.7
Found CMake: /usr/bin/cmake (2.8.12.2)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency libgsf-1 found: NO (tried pkgconfig and cmake)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency fftw3 found: NO (tried pkgconfig and cmake)
Run-time dependency magickcore found: YES 7.1.1
Checking for function "ImportImagePixels" with dependency MagickCore: YES 
Checking for function "ImagesToBlob" with dependency MagickCore: YES 
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency cfitsio found: NO (tried pkgconfig and cmake)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency imagequant found: NO (tried pkgconfig and cmake)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency quantizr found: NO (tried pkgconfig and cmake)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency libexif found: NO (tried pkgconfig and cmake)
Run-time dependency libjpeg found: YES 1.2.90
Checking for function "jpeg_c_bool_param_supported" with dependency libjpeg: NO 
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency spng found: NO (tried pkgconfig and cmake)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency libspng found: NO (tried pkgconfig and cmake)
Run-time dependency libpng found: YES 1.5.13
Checking for function "png_set_chunk_malloc_max" with dependency libpng: YES 
Run-time dependency libwebp found: YES 1.3.2
Run-time dependency libwebpmux found: YES 1.3.2
Run-time dependency libwebpdemux found: YES 1.3.2
Run-time dependency pangocairo found: YES 1.42.3
Run-time dependency pangoft2 found: YES 1.42.3
Run-time dependency fontconfig found: YES 2.13.0
Run-time dependency libtiff-4 found: YES 4.0.3
Fetching value of define "COMPRESSION_WEBP" with dependency libtiff-4:  
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency librsvg-2.0 found: NO (tried pkgconfig and cmake)
Run-time dependency cairo found: YES 1.15.12
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency openslide found: NO (tried pkgconfig and cmake)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency matio found: NO (tried pkgconfig and cmake)
Run-time dependency lcms2 found: YES 2.6
Run-time dependency openexr found: YES 1.7.1
Dependency libopenjp2 found: NO found 2.3.1 but need: '>=2.4'
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency libopenjp2 found: NO (tried pkgconfig and cmake)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency orc-0.4 found: NO (tried pkgconfig and cmake)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency pdfium found: NO (tried pkgconfig and cmake)
Run-time dependency libheif found: YES 1.16.2
Checking for function "heif_image_handle_get_raw_color_profile" with dependency libheif: YES 
Checking for function "heif_context_set_maximum_image_size_limit" with dependency libheif: YES 
Checking whether type "struct heif_decoding_options" has member "convert_hdr_to_8bit" with dependency libheif: YES 
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency libjxl found: NO (tried pkgconfig and cmake)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency libjxl_threads found: NO (tried pkgconfig and cmake)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency poppler-glib found: NO (tried pkgconfig and cmake)
Run-time dependency niftiio found: NO (tried pkgconfig)
WARNING: The version of CMake /usr/bin/cmake is 2.8.12.2 but version >=3.4 is required
Run-time dependency nifti found: NO (tried cmake)
Has header "sys/file.h" : YES 
Has header "sys/param.h" : YES 
Has header "sys/mman.h" : YES 
Has header "unistd.h" : YES 
Has header "io.h" : NO 
Has header "direct.h" : NO 
Checking for function "ngettext" : YES 
Checking for function "bind_textdomain_codeset" : YES 
Configuring config.h using configuration
Program glib-mkenums found: YES (/usr/bin/glib-mkenums)
Program glib-mkenums found: YES (/usr/bin/glib-mkenums)
Configuring version.h using configuration
Found pkg-config: /usr/bin/pkg-config (0.27.1)
Program glib-genmarshal found: YES (/usr/bin/glib-genmarshal)
Run-time dependency gobject-introspection-1.0 found: YES 1.56.1
Dependency gobject-introspection-1.0 found: YES 1.56.1 (cached)
Program g-ir-scanner found: YES (/usr/bin/g-ir-scanner)
Dependency gobject-introspection-1.0 found: YES 1.56.1 (cached)
Program g-ir-compiler found: YES (/usr/bin/g-ir-compiler)
Program python3 found: YES (/usr/bin/python3)
Configuring variables.sh using configuration
Library FuzzingEngine found: NO
Build targets in project: 53

vips 8.14.5

  Build options
    enable debug                      : YES
    enable deprecated                 : YES
    enable modules                    : YES
    enable gtk-doc                    : NO
    enable doxygen                    : NO
    enable introspection              : YES
    enable examples                   : YES
    enable cplusplus                  : YES
    enable RAD load/save              : YES
    enable Analyze7 load/save         : YES
    enable PPM load/save              : YES
    enable GIF load                   : YES

  Optional external packages
    use fftw for FFTs                 : NO
    accelerate loops with ORC         : NO
    ICC profile support with lcms     : YES
    zlib                              : YES
    text rendering with pangocairo    : YES
    font file support with fontconfig : YES
    EXIF metadata support with libexif: NO

  External image format libraries
    JPEG load/save with libjpeg       : YES
    JXL load/save with libjxl         : NO (dynamic module: NO)
    JPEG2000 load/save with OpenJPEG  : NO
    PNG load/save with libspng        : NO
    PNG load/save with libpng         : YES
    selected quantisation package     : none
    TIFF load/save with libtiff       : YES
    image pyramid save with libgsf    : NO
    HEIC/AVIF load/save with libheif  : YES (dynamic module: YES)
    WebP load/save with libwebp       : YES
    PDF load with PDFium              : NO
    PDF load with poppler-glib        : NO (dynamic module: NO)
    SVG load with librsvg             : NO
    EXR load with OpenEXR             : YES
    OpenSlide load                    : NO (dynamic module: NO)
    Matlab load with libmatio         : NO
    NIfTI load/save with niftiio      : NO
    FITS load/save with cfitsio       : NO
    GIF save with cgif                : NO
    selected Magick package           : MagickCore (dynamic module: YES)
    Magick API version                : magick7
    Magick load                       : YES
    Magick save                       : YES

  User defined options
    prefix                            : /home/kdoz

Found ninja-1.11.1.git.kitware.jobserver-1 at /home/kdoz/.local/bin/ninja
NOTICE: You are using Python 3.6 which is EOL. Starting with v0.62.0, Meson will require Python 3.7 or newer
```

```
cd build-dir
ninja
ninja test
ninja install
```

```
➜  build-dir ninja
[1/505] Generating libvips/iofuncs/vipsmarshal_h with a custom command
INFO: Reading ../libvips/iofuncs/vipsmarshal.list...
[2/505] Generating libvips/iofuncs/vipsmarshal_c with a custom command
INFO: Reading ../libvips/iofuncs/vipsmarshal.list...
[382/505] Compiling C object libvips/iofuncs/libiofuncs.a.p/vector.c.o
../libvips/iofuncs/vector.c:73:1: warning: ‘vips_vector_error’ defined but not used [-Wunused-function]
   73 | vips_vector_error( VipsVector *vector )
      | ^~~~~~~~~~~~~~~~~
[490/505] Generating libvips/Vips-8.0.gir with a custom command
g-ir-scanner: link: cc -o /home/kdoz/vips-8.14.5/build-dir/tmp-introspectiYNg2d/Vips-8.0 /home/kdoz/vips-8.14.5/build-dir/tmp-introspectiYNg2d/Vips-8.0.o -L. -Wl,-rpath,. -Wl,--no-as-needed -lvips -lglib-2.0 -lgio-2.0 -lgobject-2.0 -lgmodule-2.0 -lexpat -lm -lz -ljpeg -lpng15 -lwebp -lwebpmux -lwebpdemux -lpangocairo-1.0 -lpango-1.0 -lcairo -lpangoft2-1.0 -lfontconfig -lfreetype -ltiff -llcms2 -lIlmImf -lImath -lHalf -lIex -lIexMath -lIlmThread -lgirepository-1.0 -L/home/kdoz/vips-8.14.5/build-dir/libvips -Wl,-rpath,/home/kdoz/vips-8.14.5/build-dir/libvips -Wl,--export-dynamic -pthread -lgio-2.0 -lgobject-2.0 -lgmodule-2.0 -lglib-2.0
[505/505] Linking target fuzz/mosaic_fuzzer
➜  build-dir ninja test
[0/1] Running all tests.
1/9 connections             OK               0.73s
2/9 descriptors             OK               1.00s
3/9 stall                   OK               1.42s
4/9 webpsave_timeout        OK               5.60s
5/9 cli                     OK              10.24s
6/9 seq                     OK              12.85s
7/9 formats                 OK              15.75s
8/9 threading               OK              20.17s
9/9 fuzz                    FAIL            21.69s   exit status 1
>>> MALLOC_PERTURB_=161 /home/kdoz/vips-8.14.5/build-dir/fuzz/test_fuzz.sh
――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― ✀  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
Listing only the last 100 lines from a long log.
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5207224829345792: (166 bytes)
smartcrop_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5674696418263040
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5674696418263040: (97 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5658586599915520
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5658586599915520: (170 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5673786296238080
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5673786296238080: (44 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5759265708441600
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5759265708441600: (289 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_file_fuzzer-5662041322291200
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_file_fuzzer-5662041322291200: (4078 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/pngsave_buffer_fuzzer-5078454764044288
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/pngsave_buffer_fuzzer-5078454764044288: (71 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5203581631725568
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5203581631725568: (13 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5678720198639616
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5678720198639616: (306 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5691855517253632
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5691855517253632: (1613 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5806172036399104
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5806172036399104: (954923 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/smartcrop_fuzzer-5687924892368896
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/smartcrop_fuzzer-5687924892368896: (109 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5111890150424576
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5111890150424576: (33 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5676300823429120
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5676300823429120: (378 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5718717719117824
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5718717719117824: (1050 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5741423734816768
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5741423734816768: (2053 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5207224829345792
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5207224829345792: (166 bytes)
thumbnail_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5674696418263040
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5674696418263040: (97 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5658586599915520
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5658586599915520: (170 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5673786296238080
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5673786296238080: (44 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5759265708441600
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_buffer_fuzzer-5759265708441600: (289 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_file_fuzzer-5662041322291200
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/jpegsave_file_fuzzer-5662041322291200: (4078 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/pngsave_buffer_fuzzer-5078454764044288
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/pngsave_buffer_fuzzer-5078454764044288: (71 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5203581631725568
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5203581631725568: (13 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5678720198639616
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5678720198639616: (306 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5691855517253632
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5691855517253632: (1613 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5806172036399104
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/sharpen_fuzzer-5806172036399104: (954923 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/smartcrop_fuzzer-5687924892368896
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/smartcrop_fuzzer-5687924892368896: (109 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5111890150424576
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5111890150424576: (33 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5676300823429120
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5676300823429120: (378 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5718717719117824
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5718717719117824: (1050 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5741423734816768
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/thumbnail_fuzzer-5741423734816768: (2053 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5207224829345792
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5207224829345792: (166 bytes)
webpsave_buffer_fuzzer: running 1 inputs
Running: /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5674696418263040
Done:    /home/kdoz/vips-8.14.5/fuzz/common_fuzzer_corpus/webpsave_buffer_fuzzer-5674696418263040: (97 bytes)
――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――


Summary of Failures:

9/9 fuzz             FAIL            21.69s   exit status 1


Ok:                 8   
Expected Fail:      0   
Fail:               1   
Unexpected Pass:    0   
Skipped:            0   
Timeout:            0   

Full log written to /home/kdoz/vips-8.14.5/build-dir/meson-logs/testlog.txt
NOTICE: You are using Python 3.6 which is EOL. Starting with v0.62.0, Meson will require Python 3.7 or newer
FAILED: meson-test 
/home/kdoz/.local/bin/meson test --no-rebuild --print-errorlogs
ninja: build stopped: subcommand failed.
```

```
➜  build-dir ninja install
[0/1] Installing files.
Installing libvips/include/vips/enumtypes.h to /home/kdoz/include/vips
Installing libvips/libvips.so.42.16.5 to /home/kdoz/lib64
Installing symlink pointing to libvips.so.42.16.5 to /home/kdoz/lib64/libvips.so.42
Installing symlink pointing to libvips.so.42 to /home/kdoz/lib64/libvips.so
Installing libvips/Vips-8.0.gir to /home/kdoz/share/gir-1.0
Installing libvips/Vips-8.0.typelib to /home/kdoz/lib64/girepository-1.0
Installing libvips/vips-magick.so to /home/kdoz/lib64/vips-modules-8.14
Installing libvips/vips-heif.so to /home/kdoz/lib64/vips-modules-8.14
Installing cplusplus/libvips-cpp.so.42.16.5 to /home/kdoz/lib64
Installing symlink pointing to libvips-cpp.so.42.16.5 to /home/kdoz/lib64/libvips-cpp.so.42
Installing symlink pointing to libvips-cpp.so.42 to /home/kdoz/lib64/libvips-cpp.so
Installing po/de/LC_MESSAGES/vips8.14.mo to /home/kdoz/share/locale/de/LC_MESSAGES
Installing po/en_GB/LC_MESSAGES/vips8.14.mo to /home/kdoz/share/locale/en_GB/LC_MESSAGES
Installing tools/vips to /home/kdoz/bin
Installing tools/vipsedit to /home/kdoz/bin
Installing tools/vipsthumbnail to /home/kdoz/bin
Installing tools/vipsheader to /home/kdoz/bin
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/buf.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/connection.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/dbuf.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/debug.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/format.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/gate.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/generate.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/private.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/sbuf.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/semaphore.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/thread.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/threadpool.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/transform.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/util.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/vector.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/almostdeprecated.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/deprecated.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/dispatch.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/intl.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/mask.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/video.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/vips7compat.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/arithmetic.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/basic.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/colour.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/conversion.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/convolution.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/create.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/draw.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/error.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/foreign.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/freqfilt.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/header.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/histogram.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/image.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/interpolate.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/memory.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/morphology.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/mosaicing.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/object.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/operation.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/rect.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/region.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/resample.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/type.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/libvips/include/vips/vips.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/cplusplus/include/vips/VError8.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/cplusplus/include/vips/VImage8.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/cplusplus/include/vips/VInterpolate8.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/cplusplus/include/vips/VRegion8.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/cplusplus/include/vips/VConnection8.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/cplusplus/include/vips/vips8 to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/man/vipsedit.1 to /home/kdoz/share/man/man1
Installing /home/kdoz/vips-8.14.5/man/vipsheader.1 to /home/kdoz/share/man/man1
Installing /home/kdoz/vips-8.14.5/man/vips.1 to /home/kdoz/share/man/man1
Installing /home/kdoz/vips-8.14.5/man/vipsprofile.1 to /home/kdoz/share/man/man1
Installing /home/kdoz/vips-8.14.5/man/vipsthumbnail.1 to /home/kdoz/share/man/man1
Installing /home/kdoz/vips-8.14.5/build-dir/libvips/include/vips/version.h to /home/kdoz/include/vips
Installing /home/kdoz/vips-8.14.5/build-dir/meson-private/vips.pc to /home/kdoz/lib64/pkgconfig
Installing /home/kdoz/vips-8.14.5/build-dir/meson-private/vips-cpp.pc to /home/kdoz/lib64/pkgconfig
Installing /home/kdoz/vips-8.14.5/tools/vipsprofile to /home/kdoz/bin
NOTICE: You are using Python 3.6 which is EOL. Starting with v0.62.0, Meson will require Python 3.7 or newer
```

## Gemfile

```
gem "jekyll", "~>4.3.2"


group :jekyll_plugins do
   # (other jekyll plugins)

  # https://github.com/rbuchberger/jekyll_picture_tag
  gem 'jekyll_picture_tag', '~> 2.0.4'


end
```

```
➜  florian.latzel.io git:(picture) ✗ bundle install
Fetching gem metadata from https://rubygems.org/...........
Resolving dependencies...
Fetching objective_elements 1.1.2
Fetching ruby-vips 2.0.17
Fetching mime-types-data 3.2023.0808
Installing objective_elements 1.1.2
Installing mime-types-data 3.2023.0808
Fetching mime-types 3.5.1
Installing mime-types 3.5.1
Installing ruby-vips 2.0.17
Fetching jekyll_picture_tag 2.0.4
Installing jekyll_picture_tag 2.0.4
Bundle complete! 10 Gemfile dependencies, 43 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```
