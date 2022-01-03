*****************************************************************************

MPFUN2020: A thread-safe arbitrary precision package
MPFUN20-Fort version

Revision date: 27 Dec 2021

AUTHOR:
David H. Bailey
Lawrence Berkeley National Lab (retired) and University of California, Davis
Email: dhbailey@lbl.gov
 
COPYRIGHT AND DISCLAIMER:
All software in this package (c) 2021 David H. Bailey. By downloading or using this software you agree to the copyright, disclaimer and license agreement in the accompanying file DISCLAIMER.txt.

FULL DOCUMENTATION
David H. Bailey, "MPFUN2020: A new thread-safe arbitrary precision package," 
https://www.davidhbailey.com/dhbpapers/mpfun2020.pdf

RECENTLY TESTED PLATFORMS:
1. gfortran compiler, version 11.2.0, on an Apple Mac OS X system, version 12.0.1, with an Intel Core i5 processor.
2. gfortran compiler, version 11.2.0, on an Apple Mac OS X system, version 12.0.1, with an Apple Silicon (ARM) M1 Pro processor.
3. gfortran compiler, version 10.2.1, on a Debian Linux system, version 4.19.152-1, with an Intel processor.
4. NAG nagfor compiler, version 7.0, on a Debian Linux system, version 4.19.152-1, with an Intel processor.
5. Intel ifort compiler, version 2021.4.0, on a Debian Linux system, version 4.19.152-1, with an Intel processor.

RECENT UPDATES:

15 Nov 2021: Implemented the special functions bessel_in, bessel_jn, bessel_kn and bessel_yn, and fixed bugs in erf, erfc and incgamma, all in mpfune.f90; updated testmpfun.f90 program to test these functions. 

4 Dec 2021: Implemented the special functions polylog_ini, polylog_neg and polylog_pos in mpfune.f90; updated testmpfun.f90 program to test these functions.

7 Dec 2021: Implemented and tested the package on an Apple Mac OS X system with the Apple Silicon (ARM) M1 Pro processor.

8 Dec 2021: Changed the gfortran optimization flag in the scripts for compiling and linking application programs from -Ofast to -O3; this corrects a problem with some large codes crashing; the gfortran optimization flag in the scripts for compiling the library is still -Ofast.

21 Dec 2021: Made a major revision to mpfune.f90, including changing all routines to follow a convention that facilitates  conversion for MPFUN-MPFR; made minor changes to mpfund.f90, mpfung1.f90, mpfung2.f90, mpfunh1.f90 and mpfunh2.f90.

27 Dec 2021: Implemented an advanced iterative algorithm (much faster) for routine mpberner, which returns an array of the first n even-indexed Bernoulli numbers; included mpzeta_int in mpfune.f90; updated testmpfun.f90 to test these functions; made minor changes to mpfunb.f90, mpfunc.f90, mpfund.f90.


INDEX OF THIS README FILE:

I. PURPOSE OF PACKAGE
II. INSTALLING CODING ENVIRONMENT (FOR MAC OS X SYSTEMS)
III. INSTALLING FORTRAN COMPILER (IF NEEDED)
IV. [Not needed in this version]
V. DOWNLOADING AND COMPILING MPFUN20-Fort 
VI. BRIEF SUMMARY OF CODING INSTRUCTIONS AND USAGE
VII. SAMPLE APPLICATION PROGRAMS AND TESTS

+++++


I. PURPOSE OF PACKAGE

This package permits one to perform floating-point computations (real and complex) to arbitrarily high numeric precision, by making only relatively minor changes to existing Fortran-90 programs (mostly changes to type statements). All basic arithmetic operations and transcendental functions are supported, together with several special functions.

The package comes in two versions: one completely self-contained, all-Fortran version that is simple to install; and one version based on the MPFR package that is more complicated to install but runs somewhat faster on most applications. Both versions are completely thread-safe, which means that user-level applications can be easily converted for parallel execution, say by using a threaded parallel environment such as OpenMP.  Both versions also detect, and provide means to overcome, accuracy problems rooted in the usage of inexact double-precision constants and expressions. A high-level Fortran-90 interface, supporting both multiprecision real and complex datatypes, is provided for each, so that most users need only to make minor changes to existing double-precision code. The two versions are "plug-compatible" in the sense that applications written for one also run with the other (provided a simple guideline is followed). 

The two versions of this package are:

MPFUN20-Fort: This is an all-Fortran version based on 8-byte integer arithmetic. It includes support for a medium precision datatype, which results in faster execution on very large problems, and features FFT-based multiplication to accelerate very high precision computations. It compiles in just a few seconds on any system with a Fortran-2008 compliant compiler (examples include the GNU gfortran compiler, the Intel ifort compiler and the NAG Fortran compiler).

MPFUN20-MPFR: This is virtually identical to MPFUN20-Fort in its user interface, but it calls the MPFR package for all low-level functions and operations. The MPFUN20-MPFR version is faster than MPFUN20-Fort on most applications, particularly those that involve transcendental functions. However, installation of MPFUN20-MPFR is significantly more complicated (because the GMP and MPFR packages must first be installed, usually requiring administrator privilege).

What follows are the instructions for MPFUN20-Fort.


II. INSTALLING CODING ENVIRONMENT (FOR MAC OS X SYSTEMS)

For Apple Mac OS X systems (highly recommended for MPFUN20-Fort), first install the latest supported version of Xcode, which is available for free from the Apple Developer website:

  https://developer.apple.com/

Here click on Account, then enter your Apple ID and password, then go to 

  https://developer.apple.com/download/more/?=xcode

On this list, find the most recent version of Xcode that is NOT listed as "beta" or "Release Candidate". Download this package on your system, double click to decompress, and place the resulting Xcode app somewhere on your system (typically in the Applications folder). Double-click on the app to run Xcode, allowing it install additional components, then quit Xcode. Open a terminal window, using the Terminal application in the Utilities folder, and type

  xcode-select --install

which installs various command-line tools. The entire process of downloading Xcode and installing command-line tools takes roughly 30 minutes. When this is completed, you should be ready to continue with the installation.


III. INSTALLING FORTRAN COMPILER (IF NEEDED)

Running MPFUN20-Fort is relatively straightforward, provided that one has a Unix-based system, such as Linux or Apple OS X, and a Fortran-2008 compliant compiler. These requirements are met by the GNU gfortran compiler, the Intel ifort compiler, the NAG nagfor compiler, IBM's xlf, PGI's pgf90 and others.

The gfortran compiler (highly recommended for MPFUN20-Fort) is available free for a variety of systems at this website:

  https://gcc.gnu.org/wiki/GFortranBinaries

For Apple Mac OS X systems, download the installer file here, depending on which version of the Mac OS X you are running:

  https://github.com/fxcoudert/gfortran-for-macOS/releases

Note that for Apple Mac OS X systems with an Apple Silicon (ARM) processor (M1, M1 Pro, M1 Max, etc.), download the installer for "gfortran 11-experimental-2 for ARM" (or whatever is the latest version) from the same list.

On an Apple OS X system, when one attempts to install gfortran, one will likely see the message "gfortran.pkg can't be opened because it is from an unidentified developer". If so, open the "System Preferences" on the Mac, then click on "Security & Privacy", unlock if necessary, and then click "Open anyway". For details, see:

  https://support.apple.com/en-us/HT202491

The gfortran compiler is normally placed in /usr/local/lib and /usr/local/bin. Thus before one uses gfortran, one must insert a line in one's shell initialization file (if the Z shell is used, as on most Apple OS X systems, the shell initialization file is ~/.zshrc). The line to be included is:

  PATH=/usr/local/lib:/usr/local/bin:$PATH

The following line is also recommended for gfortran compiler users:

  GFORTRAN_UNBUFFERED_ALL=yes; export GFORTRAN_UNBUFFERED_ALL

The following line is recommended for inclusion in the shell initialization file, no matter what compiler is used (it prevents stack overflow system errors):

  ulimit -s unlimited

On most Unix systems (including Apple Mac OS X systems), the shell initialization file must be manually executed upon initiating a terminal shell, typically by typing "source .zshrc".


IV. [Not needed in this version]

V. DOWNLOADING AND COMPILING MPFUN20-Fort

From the website https://www.davidhbailey.com/dhbsoftware, download the file "mpfun20-fort-vnn.tar.gz" (replace "vnn" by whatever is the current version on the website, such as "v22"). If the file is not decompressed by your browser, use gunzip at the shell level to do this. Some browsers (such as the Apple Safari browser) do not drop the ".gz" suffix after decompression; if so, remove this suffix manually at the shell level. Then type

  tar xfv mpfun20-fort-vnn.tar 

(where again "vnn" is replaced by the downloaded version). This should create the directory and unpack all files.

The MPFUN20-Fort software comes in two variants, which are in directories fortran-var1 and fortran-var2, respectively:

Variant 1: This is recommended for beginning users and for basic applications that do not dynamically change the working precision level (or do so only rarely).

Variant 2: This is recommended for more sophisticated applications that dynamically change the working precision level. It does not allow some mixed-mode combinations, and requires one to explicitly specify a working precision parameter for some functions. However, in the present author's experience, these restrictions result in less overall effort to produce a debugged, efficient application code.

See documentation paper for additional details on the differences between these two variants. The Fortran source files and scripts required for each of these variants are in the respective directories fortran-var1 and fortran-var2.

Compile/link scripts are available for the GNU gfortran, the Intel ifort and NAG Fortran compilers. These scripts automatically select the proper source files from the package for compilation and employ the appropriate compiler flags. For example, to compile Variant 1 of the library using the GNU gfortran compiler, go to the fortran-var1 directory and type

  ./gnu-complib1.scr

NOTE: The first time you compile the library, you may see numerous error messages. This is normal -- just repeat the library compile script. The compile script actually invokes the compiler twice for this reason.

Then to compile and link the application program tpslq1.f90 for variant 1, using the GNU gfortran compiler, producing the executable file tpslq1, type

  ./gnu-complink1.scr tpslq1

To execute the program, with output to tpslq1.txt, type

  ./tpslq1 > tpslq1.txt

These scripts assume that the user program is in the same directory as the library files; this can easily be changed by editing the script files.

Several sample test programs, together with reference output files, are included in the fortran-var1 and fortran-var2 directories -- see Section VIII below.


VI. BRIEF SUMMARY OF CODING INSTRUCTIONS AND USAGE

What follows is a brief summary of Fortran coding instructions. For full details, see the documentation paper:

David H. Bailey, "MPFUN2020: A new thread-safe arbitrary precision package," 
https://www.davidhbailey.com/dhbpapers/mpfun2020.pdf

First set the parameter mpipl, the default standard precision level in digits, which is the maximum precision level to be used for subsequent computation, and is used to specify the amount of storage required for multiprecision data. mpipl is set in a parameter statement in file mpfunf.f90 in the fortran-var1 or fortran-var2 directory of the software. In the code as distributed, mpipl is set to 2500 digits (sufficient to run each of the test programs), but it can be set to any level greater than 50 digits. mpipl is automatically converted to mantissa words by the formula 

  mpwds = int (mpipl / mpdpw + 2)

where mpdpw (digits per word) is a system parameter (approx. 18.0617997398 for MPFUN20-Fort and 19.2659197224 in MPFUN-MPFR) set in file mpfuna.f90. The resulting parameter mpwds is the internal default precision level, in words. All subsequent computations are performed to mpwds words precision unless the user, within an application code, specifies a lower precision.

After setting the value of mpipl, compile the library, using one of the scripts mentioned above (e.g., gnu-complib1.scr if using the GNU gfortran compiler or intel-complib1.scr if using the Intel compiler).

Next, place the following line in every subprogram of the user's application code that contains a multiprecision variable or array, at the beginning of the declaration section, before any implicit or type statements:

  use mpmodule

To designate a variable or array as multiprecision real (MPR) in an application code, use the Fortran-90 type statement with the type "mp_real", as in this example:

  type (mp_real) a, b(m), c(m,n)

Similarly, to designate a variable or array as multiprecision complex (MPC), use a type statement with "mp_complex".

Thereafter when one of these variables or arrays appears in code, e.g.,

  d = a + b(i) * sqrt(3.d0 - c(i,j))

the proper multiprecision routines are automatically called by the Fortran compiler.

Most common mixed-mode combinations (arithmetic operations, comparisons and assignments) involving MPR, MPC, double precision (DP) and integer arguments are supported, although restrictions apply if one uses Variant 2 of the MPFUN20-Fort software. A complete list of supported mixed-mode operations is given in the documentation paper.

Users should be aware, however, that there are some hazards in this type of programming, inherent in conventions adopted by all Fortran compilers. For example, the code

  r1 = 3.14159d0

where r1 is MPR, does NOT produce the true multiprecision equivalent of 3.14159. In fact, the software will flag such usage with a run-time error. To obtain the full MPR converted value, write this as

  r1 = '3.14159d0'

or, if using variant 2, as

  r1 = mpreal ('3.14159d0', nwds)

where nwds is the level of working precision to be assigned to r1. Similarly, the code

  r2 = r1 + 3.d0 * sqrt (2.d0)

where r1 and r2 are MPR, does NOT produce the true multiprecision value one might expect, since the expression 3.d0 * sqrt (2.d0) will be performed in double precision, according to Fortran-90 precedence rules. In fact, the above line of code will result in a run-time error. To obtain the fully accurate result, write this as

  r2 = r1 + 3.d0 * sqrt (mpreal (2.q0))

or, if using variant 2, as

  r2 = r1 + 3.d0 * sqrt (mpreal (2.q0, nwds))

where nwds is the level of working precision. See documentation paper for details.

Input and output of MPR and MPC data are performed using the subroutines mpread and mpwrite. For example, to output the variable r1 in E format to Fortran unit 6 (standard output), to 100-digit accuracy, in a field of width 120 characters, use the line of code

  call mpwrite (6, 120, 100, r1)

The second argument (120 in the above example) must be at least 20 larger than the third argument (100 in the above example). To read the variable r1 from Fortran unit 5 (standard input), use the line of code

  call mpread (5, r1)

or, if using variant 2, as

  call mpread (5, r1, nwds)

where nwds is the level of working precision. See documentation paper for details such as formatting.

Most Fortran-2008 intrinsic functions are supported with MPR and MPC arguments, as appropriate, and several special functions are also supported. A complete list of supported functions and subroutines is given in the documentation paper. 


VII. SAMPLE APPLICATION PROGRAMS AND TESTS

The current release of the software includes a set of sample application programs in the fortran-var1 and fortran-var2 directories (the files are identical between directories):

testmpfun.f90  Tests most arithmetic and transcendental functions.

tpslq1.f90   Performs the standard 1-level PSLQ integer relation algorithm.

tpslqm1.f90  Performs the 1-level multipair PSLQ integer relation algorithm.

tpslqm2.f90  Performs the 2-level multipair PSLQ integer relation algorithm.

tpslqm3.f90  Performs the 3-level multipair PSLQ integer relation algorithm.

tpphix3.f90  Performs a Poisson polynomial application, using 3-level multipair PSLQ.

tquad.f90   Evaluates a set of definite integrals, using tanh-sinh, exp-sinh and sinh-sinh algorithms.

tquadgs.f90  Evaluates a set of definite integrals, using Gaussian quadrature.

Corresponding reference output files (e.g., tpphix3.ref.txt) are also included for each of the above programs.

In addition, the fortran-var1 and fortran-var2 directories include test scripts that compile the library and run each of the above sample programs above (except tquadgs.f90, which takes considerably more run time). In directory fortran-var1, these scripts are:

gnu-mpfun-tests1.scr
intel-mpfun-tests1.scr
nag-mpfun-tests1.scr

and the same scripts in directory fortran-var2, except for 2 instead of 1 in the filenames. For each test program, the script outputs either TEST PASSED or TEST FAILED. If all tests pass, then one can be fairly confident that the MPFUN2020 software and underlying compilers are working properly. Full descriptions of these application programs are included in the documentation paper:

David H. Bailey, "MPFUN2020: A new thread-safe arbitrary precision package," 
https://www.davidhbailey.com/dhbpapers/mpfun2020.pdf




