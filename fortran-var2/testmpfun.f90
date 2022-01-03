!*****************************************************************************

!  program testmpfun

!  Revision date:  25 Dec 2021

!  AUTHOR:
!   David H. Bailey
!   Lawrence Berkeley National Lab (retired) and University of California, Davis
!   Email: dhbailey@lbl.gov

!  COPYRIGHT AND DISCLAIMER:
!   All software in this package (c) 2021 David H. Bailey.
!   By downloading or using this software you agree to the copyright, disclaimer
!   and license agreement in the accompanying file DISCLAIMER.txt.

!  DESCRIPTION:
!   This briefly tests most individual MPFUN2020 operations and functions
!   (including mixed mode arithmetic, comparison operations, transcendental
!   functions and special functions), by comparing each result with benchmark
!   results in the file testmpfun.ref.txt, which must be present in the same
!   directory.  This is not an exhaustive test of all possible scenarios, but it
!   often detects bugs and compiler issues.

program testmpfun
use mpmodule
implicit none
integer i, n1, nfile, ndp, neps, nwds
parameter (nfile = 11, ndp = 500, nwds = ndp / mpdpw + 2, neps = 5 - ndp)
character(500) chr500
character(1) chrpi(ndp+30)
integer i1
logical l1, l2, l3, l4, l5
real (mprknd) d1, e1, e2
complex (mprknd) ec1, ec2
type (mp_real) eps, err, errmx, one, rr(500), t1, t2, t3, t4, zero
type (mp_complex) z1, z2

open (nfile, file = 'testmpfun.ref.txt')
rewind nfile
eps = mpreal (10.d0, nwds) ** neps
one = mpreal (1.d0, nwds)
zero = mpreal (0.d0, nwds)
errmx = zero

write (6, '(a)') 'MPUN2020 quick check of operations and functions'

!   Define a few sample data values.

chr500 = &
'3.14159265358979323846264338327950288419716939937510582097494459230781&
&6406286208998628034825342117067982148086513282306647093844609550582231&
&7253594081284811174502841027019385211055596446229489549303819644288109&
&7566593344612847564823378678316527120190914564856692346034861045432664&
&8213393607260249141273724587006606315588174881520920962829254091715364&
&3678925903600113305305488204665213841469519415116094330572703657595919&
&5309218611738193261179310511854807446237996274956735188575272489122793&
&81830119491'

do i = 1, ndp
  chrpi(i) = chr500(i:i)
enddo

t1 = mppi (nwds)
t2 = - mplog2 (nwds)

e1 = 3141.d0 / 8192.d0
e2 = 6931.d0 / 8192.d0
z1 = mpcmplx (0.5d0 * mppi (nwds), exp (mpreal (0.5d0, nwds)), nwds)
z2 = mpcmplx (- gamma (mpreal (0.5d0, nwds)), cos (mpreal (1.d0, nwds)), nwds)
ec1 = cmplx (e1, e2, mprknd)
ec2 = cmplx (-e2, e1, mprknd)
i1 = 5

write (6, '(/a/)') 'Test data:'
write (6, '(a)') 't1 = pi:'
call mpwrite (6, ndp + 20, ndp, t1)
call checkmp (nwds, nfile, 5, t1, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 't2 = -log(2):'
call mpwrite (6, ndp + 20, ndp, t2)
call checkmp (nwds, nfile, 1, t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'z1 = (0.5*pi, exp(0.5)):'
call mpwrite (6, ndp + 20, ndp, z1)
call checkmpc (nwds, nfile, 1, z1, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'z2 = (-Gamma(0.5), Cos(1)):'
call mpwrite (6, ndp + 20, ndp, z2)
call checkmpc (nwds, nfile, 1, z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'e1 = 3141/8192:'
write (6, '(1p,d25.15)') e1
write (6, '(a)') 'e2 = 6931/8192:'
write (6, '(1p,d25.15)') e2
write (6, '(a)')  'ec1 = (3141/8192, 6931/8192)'
write (6, '(1p,2d25.15)') ec1
write (6, '(a)') 'ec2 = (-6931/8192, 3141/8192):'
write (6, '(1p,2d25.15)') ec2
write (6, '(a,i4)') 'i1: ', i1

write (6, '(/a/)') 'Real data operations:'

write (6, '(a)') 'addition: t1+t2 ='
call mpwrite (6, ndp + 20, ndp, t1 + t2)
call checkmp (nwds, nfile, 13, t1 + t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'addition: t1+e2 ='
call mpwrite (6, ndp + 20, ndp, t1 + e2)
call checkmp (nwds, nfile, 1, t1 + e2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'addition: e1+t2 ='
call mpwrite (6, ndp + 20, ndp, e1 + t2)
call checkmp (nwds, nfile, 1, e1 + t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'subtraction: t1-t2 ='
call mpwrite (6, ndp + 20, ndp, t1 - t2)
call checkmp (nwds, nfile, 1, t1 - t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'subtraction: t1-e2 ='
call mpwrite (6, ndp + 20, ndp, t1 - e2)
call checkmp (nwds, nfile, 1, t1 - e2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'subtraction: e1-t2 ='
call mpwrite (6, ndp + 20, ndp, e1 - t2)
call checkmp (nwds, nfile, 1, e1 - t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: t1*t2 ='
call mpwrite (6, ndp + 20, ndp, t1 * t2)
call checkmp (nwds, nfile, 1, t1 * t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: t1*e2 ='
call mpwrite (6, ndp + 20, ndp, t1 * e2)
call checkmp (nwds, nfile, 1, t1 * e2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: e1*t2 ='
call mpwrite (6, ndp + 20, ndp, e1 * t2)
call checkmp (nwds, nfile, 1, e1 * t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'division: t1/t2 ='
call mpwrite (6, ndp + 20, ndp, t1 / t2)
call checkmp (nwds, nfile, 1, t1 / t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'division: t1/e2 ='
call mpwrite (6, ndp + 20, ndp, t1 / e2)
call checkmp (nwds, nfile, 1, t1 / e2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'division: e1/t2 ='
call mpwrite (6, ndp + 20, ndp, e1 / t2)
call checkmp (nwds, nfile, 1, e1 / t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'exponentiation: t1**i1 ='
call mpwrite (6, ndp + 20, ndp, t1 ** i1)
call checkmp (nwds, nfile, 1, t1 ** i1, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'exponentiation: t1**t2 ='
call mpwrite (6, ndp + 20, ndp, t1 ** t2)
call checkmp (nwds, nfile, 1, t1 ** t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'equal test: t1 == t2, e1 == t2, t1 == e2'
l1 = t1 == t2; l2 = e1 == t2; l3 = t1 == e2
write (6, '(6l4)') l1, l2, l3
if (l1 .eqv. .false. .and. l2 .eqv. .false. .and. l3 .eqv. .false.) then
  err = zero
else
  err = one
endif
errmx = max (err, errmx)

write (6, '(a)') 'not-equal test: t1 /= t2, e1 /= t2, t1 =/ e2'
l1 = t1 /= t2; l2 = e1 /= t2; l3 = t1 /= e2
write (6, '(6l4)') l1, l2, l3
if (l1 .eqv. .true. .and. l2 .eqv. .true. .and. l3 .eqv. .true.) then
  err = zero
else
  err = one
endif
errmx = max (err, errmx)

write (6, '(a)') 'less-than-or-equal test: t1 <= t2, e1 <= t2, t1 <= e2'
l1 = t1 <= t2; l2 = e1 <= t2; l3 = t1 <= e2
write (6, '(6l4)') l1, l2, l3
if (l1 .eqv. .false. .and. l2 .eqv. .false. .and. l3 .eqv. .false.) then
  err = zero
else
  err = one
endif
errmx = max (err, errmx)

write (6, '(a)') 'greater-than-or-equal test: t1 >= t2, e1 >= t2, t1 >= e2'
l1 = t1 >= t2; l2 = e1 >= t2; l3 = t1 >= e2
write (6, '(6l4)') l1,l2, l3
if (l1 .eqv. .true. .and. l2 .eqv. .true. .and. l3 .eqv. .true.) then
  err = zero
else
  err = one
endif
errmx = max (err, errmx)

write (6, '(a)') 'less-than test: t1 < t2, e1 < t2, t1 < e2'
l1 = t1 < t2; l2 = e1 < t2; l3 = t1 < e2
write (6, '(6l4)') l1, l2, l3
if (l1 .eqv. .false. .and. l2 .eqv. .false. .and. l3 .eqv. .false.) then
  err = zero
else
  err = one
endif
errmx = max (err, errmx)

write (6, '(a)') 'greater-than test: t1 > t2, e1 > t2, t1 > e2'
l1 = t1 > t2; l2 = e1 > t2; l3 = t1 > e2
write (6, '(6l4)') l1, l2, l3
if (l1 .eqv. .true. .and. l2 .eqv. .true. .and. l3 .eqv. .true.) then
  err = zero
else
  err = one
endif
errmx = max (err, errmx)

write (6, '(a)') 'abs(t2) ='
call mpwrite (6, ndp + 20, ndp, abs (t2))
call checkmp (nwds, nfile, 13, abs (t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'acos(t2) ='
call mpwrite (6, ndp + 20, ndp, acos (t2))
call checkmp (nwds, nfile, 1, acos (t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'acosh(t1) ='
call mpwrite (6, ndp + 20, ndp, acosh (t1))
call checkmp (nwds, nfile, 1, acosh (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'agm(t1,abs(t2)) ='
call mpwrite (6, ndp + 20, ndp, agm (t1, abs (t2)))
call checkmp (nwds, nfile, 1, agm (t1, abs (t2)), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'aint(t1) ='
call mpwrite (6, ndp + 20, ndp, aint (t1))
call checkmp (nwds, nfile, 1, aint (t1), eps, err)

write (6, '(a)') 'anint(t1) ='
call mpwrite (6, ndp + 20, ndp, anint (t1))
call checkmp (nwds, nfile, 1, anint (t1), eps, err)

write (6, '(a)') 'asin(t2) ='
call mpwrite (6, ndp + 20, ndp, asin (t2))
call checkmp (nwds, nfile, 1, asin (t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'asinh(t1) ='
call mpwrite (6, ndp + 20, ndp, asinh (t1))
call checkmp (nwds, nfile, 1, asinh (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'atan(t1) ='
call mpwrite (6, ndp + 20, ndp, atan (t1))
call checkmp (nwds, nfile, 1, atan (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'atan2(t1,t2) ='
call mpwrite (6, ndp + 20, ndp, atan2 (t1,t2))
call checkmp (nwds, nfile, 1, atan2 (t1, t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'bessel_in(3,t1) ='
call mpwrite (6, ndp + 20, ndp, bessel_in (3, t1))
call checkmp (nwds, nfile, 1, bessel_in (3, t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'bessel_jn(3,t1) ='
call mpwrite (6, ndp + 20, ndp, bessel_jn (3, t1))
call checkmp (nwds, nfile, 1, bessel_jn (3, t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'bessel_kn(3,t1) ='
call mpwrite (6, ndp + 20, ndp, bessel_kn (3, t1))
call checkmp (nwds, nfile, 1, bessel_kn (3, t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'bessel_yn(3,t1) ='
call mpwrite (6, ndp + 20, ndp, bessel_yn (3, t1))
call checkmp (nwds, nfile, 1, bessel_yn (3, t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'cos(t2) ='
call mpwrite (6, ndp + 20, ndp, cos (t2))
call checkmp (nwds, nfile, 1, cos (t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'cosh(t1) ='
call mpwrite (6, ndp + 20, ndp, cosh (t1))
call checkmp (nwds, nfile, 1, cosh (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'erf(t1) ='
call mpwrite (6, ndp + 20, ndp, erf (t1))
call checkmp (nwds, nfile, 1, erf (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'erfc(t1) ='
call mpwrite (6, ndp + 20, ndp, erfc (t1))
call checkmp (nwds, nfile, 1, erfc (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'exp(t1) ='
call mpwrite (6, ndp + 20, ndp, exp (t1))
call checkmp (nwds, nfile, 1, exp (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'gamma(t1) ='
call mpwrite (6, ndp + 20, ndp, gamma (t1))
call checkmp (nwds, nfile, 1, gamma (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'incgamma(t1,t2+2) ='
call mpwrite (6, ndp + 20, ndp, incgamma (t1, t2+2.d0))
call checkmp (nwds, nfile, 1, incgamma (t1, t2+2.d0), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'log(t1) ='
call mpwrite (6, ndp + 20, ndp, log (t1))
call checkmp (nwds, nfile, 1, log (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'max(t1,t2) ='
call mpwrite (6, ndp + 20, ndp, max (t1,t2))
call checkmp (nwds, nfile, 1, max (t1, t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'min(t1,t2) ='
call mpwrite (6, ndp + 20, ndp, min (t1,t2))
call checkmp (nwds, nfile, 1, min (t1, t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'mod(t1,t2) ='
call mpwrite (6, ndp + 20, ndp, mod(t1,t2))
call checkmp (nwds, nfile, 1, mod (t1, t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'mpcssh(t1) ='
call mpcssh (t1, t3, t4)
call mpwrite (6, ndp + 20, ndp, t3, t4)
call checkmp (nwds, nfile, 1, t3, eps, err)
errmx = max (err, errmx)
call checkmp (nwds, nfile, 0, t4, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'mpcssn(t2) ='
call mpcssn (t2, t3, t4)
call mpwrite (6, ndp + 20, ndp, t3, t4)
call checkmp (nwds, nfile, 1, t3, eps, err)
errmx = max (err, errmx)
call checkmp (nwds, nfile, 0, t4, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'mpnrt(t1,i1) ='
call mpwrite (6, ndp + 20, ndp, mpnrt (t1,i1))
call checkmp (nwds, nfile, 1, mpnrt (t1, i1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'mpprod (t1,e2) ='
call mpwrite (6, ndp + 20, ndp, mpprod (t1,e2))
call checkmp (nwds, nfile, 1, mpprod (t1,e2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'mpquot (t1,e2) ='
call mpwrite (6, ndp + 20, ndp, mpquot (t1,e2))
call checkmp (nwds, nfile, 1, mpquot (t1,e2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'mpreal (chr500, nwds) ='
call mpwrite (6, ndp + 20, ndp, mpreal (chr500, nwds))
call checkmp (nwds, nfile, 1, mpreal (chr500, nwds), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'mpreal (chrpi, ndp, nwds) ='
call mpwrite (6, ndp + 20, ndp, mpreal (chrpi, ndp, nwds))
call checkmp (nwds, nfile, 1, mpreal (chrpi, ndp, nwds), eps, err)

call polylog_ini (-10, rr, nwds)
write (6, '(a)') 'polylog_neg (-10, rr, -t1) ='
call mpwrite (6, ndp + 20, ndp, polylog_neg (-10, rr, -t1))
call checkmp (nwds, nfile, 1, polylog_neg (-10, rr, -t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'polylog_pos (10, 1/t1) ='
call mpwrite (6, ndp + 20, ndp, polylog_pos (10, 1.d0/t1))
call checkmp (nwds, nfile, 1, polylog_pos (10, 1.d0/t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'sign(t1,t2) ='
call mpwrite (6, ndp + 20, ndp, sign (t1,t2))
call checkmp (nwds, nfile, 1, sign (t1, t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'sin(t2) ='
call mpwrite (6, ndp + 20, ndp, sin (t2))
call checkmp (nwds, nfile, 1, sin (t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'sinh(t1) ='
call mpwrite (6, ndp + 20, ndp, sinh (t1))
call checkmp (nwds, nfile, 1, sinh (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'sqrt(t1) ='
call mpwrite (6, ndp + 20, ndp, sqrt (t1))
call checkmp (nwds, nfile, 1, sqrt (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'tan(t1) ='
call mpwrite (6, ndp + 20, ndp, tan (t2))
call checkmp (nwds, nfile, 1, tan (t2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'tanh(t1) ='
call mpwrite (6, ndp + 20, ndp, tanh (t1))
call checkmp (nwds, nfile, 1, tanh (t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'zeta(t1) ='
call mpwrite (6, ndp + 20, ndp, zeta (t1))
call checkmp (nwds, nfile, 1, zeta (t1), eps, err)
errmx = max (err, errmx)

call mpberne (500, rr, nwds)
write (6, '(a)') 'zetaem(500,rr,t1) ='
call mpwrite (6, ndp + 20, ndp, zetaem (500,rr,t1))
call checkmp (nwds, nfile, 1, zetaem (500,rr,t1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'zeta_int(10,nwds) ='
call mpwrite (6, ndp + 20, ndp, zeta_int (10,nwds))
call checkmp (nwds, nfile, 1, zeta_int (10,nwds), eps, err)
errmx = max (err, errmx)

write (6, '(/a/)') 'Complex data operations:'

write (6, '(a)') 'addition: z1+z2 ='
call mpwrite (6, ndp + 20, ndp, z1 + z2)
call checkmpc (nwds, nfile, 4, z1 + z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'addition: z1+e2 ='
call mpwrite (6, ndp + 20, ndp, z1 + e2)
call checkmpc (nwds, nfile, 1, z1 + e2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'addition: e1+z2 ='
call mpwrite (6, ndp + 20, ndp, e1 + z2)
call checkmpc (nwds, nfile, 1, e1 + z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'addition: z1+ec2 ='
call mpwrite (6, ndp + 20, ndp, z1 + ec2)
call checkmpc (nwds, nfile, 1, z1 + ec2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'addition: ec1+z2 ='
call mpwrite (6, ndp + 20, ndp, ec1 + z2)
call checkmpc (nwds, nfile, 1, ec1 + z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'addition: z1+t2 ='
call mpwrite (6, ndp + 20, ndp, z1 + t2)
call checkmpc (nwds, nfile, 1, z1 + t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'addition: t1+z2 ='
call mpwrite (6, ndp + 20, ndp, t1 + z2)
call checkmpc (nwds, nfile, 1, t1 + z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'subtraction: z1-z2 ='
call mpwrite (6, ndp + 20, ndp, z1 - z2)
call checkmpc (nwds, nfile, 1, z1 - z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'subtraction: z1-e2 ='
call mpwrite (6, ndp + 20, ndp, z1 - e2)
call checkmpc (nwds, nfile, 1, z1 - e2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'subtraction: e1-z2 ='
call mpwrite (6, ndp + 20, ndp, e1 - z2)
call checkmpc (nwds, nfile, 1, e1 - z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'subtraction: z1-ec2 ='
call mpwrite (6, ndp + 20, ndp, z1 - ec2)
call checkmpc (nwds, nfile, 1, z1 - ec2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'subtraction: ec1-z2 ='
call mpwrite (6, ndp + 20, ndp, ec1 - z2)
call checkmpc (nwds, nfile, 1, ec1 - z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'subtraction: z1-t2 ='
call mpwrite (6, ndp + 20, ndp, z1 - t2)
call checkmpc (nwds, nfile, 1, z1 - t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'subtraction: t1-z2 ='
call mpwrite (6, ndp + 20, ndp, t1 - z2)
call checkmpc (nwds, nfile, 1, t1 - z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: z1*z2 ='
call mpwrite (6, ndp + 20, ndp, z1 * z2)
call checkmpc (nwds, nfile, 1, z1 * z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: z1*e2 ='
call mpwrite (6, ndp + 20, ndp, z1 * e2)
call checkmpc (nwds, nfile, 1, z1 * e2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: e1*z2 ='
call mpwrite (6, ndp + 20, ndp, e1 * z2)
call checkmpc (nwds, nfile, 1, e1 * z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: z1*ec2 ='
call mpwrite (6, ndp + 20, ndp, z1 * ec2)
call checkmpc (nwds, nfile, 1, z1 * ec2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: ec1*z2 ='
call mpwrite (6, ndp + 20, ndp, ec1 * z2)
call checkmpc (nwds, nfile, 1, ec1 * z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: z1*t2 ='
call mpwrite (6, ndp + 20, ndp, z1 * t2)
call checkmpc (nwds, nfile, 1, z1 * t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: t1*z2 ='
call mpwrite (6, ndp + 20, ndp, t1 * z2)
call checkmpc (nwds, nfile, 1, t1 * z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: z1*e2 ='
call mpwrite (6, ndp + 20, ndp, z1 * e2)
call checkmpc (nwds, nfile, 1, z1 * e2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'multiplication: e1*z2 ='
call mpwrite (6, ndp + 20, ndp, e1 * z2)
call checkmpc (nwds, nfile, 1, e1 * z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'division: z1/z2 ='
call mpwrite (6, ndp + 20, ndp, z1 / z2)
call checkmpc (nwds, nfile, 1, z1 / z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'division: z1/e2 ='
call mpwrite (6, ndp + 20, ndp, z1 / e2)
call checkmpc (nwds, nfile, 1, z1 / e2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'division: e1/z2 ='
call mpwrite (6, ndp + 20, ndp, e1 / z2)
call checkmpc (nwds, nfile, 1, e1 / z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'division: z1/ec2 ='
call mpwrite (6, ndp + 20, ndp, z1 / ec2)
call checkmpc (nwds, nfile, 1, z1 / ec2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'division: ec1/z2 ='
call mpwrite (6, ndp + 20, ndp, ec1 / z2)
call checkmpc (nwds, nfile, 1, ec1 / z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'division: z1/t2 ='
call mpwrite (6, ndp + 20, ndp, z1 / t2)
call checkmpc (nwds, nfile, 1, z1 / t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'division: t1/z2 ='
call mpwrite (6, ndp + 20, ndp, t1 / z2)
call checkmpc (nwds, nfile, 1, t1 / z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'exponentiation: z1**i1 ='
call mpwrite (6, ndp + 20, ndp, z1 ** i1)
call checkmpc (nwds, nfile, 1, z1 ** i1, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'exponentiation: z1**z2 ='
call mpwrite (6, ndp + 20, ndp, z1 ** z2)
call checkmpc (nwds, nfile, 1, z1 ** z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'exponentiation: t1**z2 ='
call mpwrite (6, ndp + 20, ndp, t1 ** z2)
call checkmpc (nwds, nfile, 1, t1 ** z2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'exponentiation: z1**t2 ='
call mpwrite (6, ndp + 20, ndp, z1 ** t2)
call checkmpc (nwds, nfile, 1, z1 ** t2, eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'equal test: z1 == z2, e1 == z2, z1 == e2, ec1 == z2, z1 == ec2'
l1 = z1 == z2; l2 = e1 == z2; l3 = z1 == e2; l4 = ec1 == z2; l5 = z1 == ec2
write (6, '(10l4)') l1, l2, l3, l4, l5
if (l1 .eqv. .false. .and. l2 .eqv. .false. .and. l3 .eqv. .false. &
  .and. l4 .eqv. .false. .and. l5 .eqv. .false.) then
  err = zero
else
  err = one
endif
errmx = max (err, errmx)

write (6, '(a)') 'not-equal test: z1 /= z2, e1 /= z2, z1 /= e2, ec1 /= z2, z1 /= ec2'
l1 = z1 /= z2; l2 = e1 /= z2; l3 = z1 /= e2; l4 = ec1 /= z2; l5 = z1 /= ec2
write (6, '(10l4)') l1, l2, l3, l4, l5
if (l1 .eqv. .true. .and. l2 .eqv. .true. .and. l3 .eqv. .true. &
  .and. l4 .eqv. .true. .and. l5 .eqv. .true.) then
  err = zero
else
  err = one
endif
errmx = max (err, errmx)

write (6, '(a)') 'abs(z2) ='
call mpwrite (6, ndp + 20, ndp, abs (z2))
call checkmp (nwds, nfile, 5, abs (z2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'aimag(z1) ='
call mpwrite (6, ndp + 20, ndp, aimag (z1))
call checkmp (nwds, nfile, 1, aimag (z1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'conjg(z1) ='
call mpwrite (6, ndp + 20, ndp, conjg (z1))
call checkmpc (nwds, nfile, 1, conjg (z1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'cos(z2) ='
call mpwrite (6, ndp + 20, ndp, cos (z2))
call checkmpc (nwds, nfile, 1, cos (z2), eps, err)
errmx = max (err, errmx)

! write (6, '(a)') 'dcmplx(z1) ='
! write (6, '(1p,2d25.15)') cmplx (dc1, kind=mprknd)
! write (6, '(1p,2d25.15)') dc1
! call checkmpc (nwds, nfile, 1, z1, dc1, ndp)

write (6, '(a)') 'exp(z1) ='
call mpwrite (6, ndp + 20, ndp, exp (z1))
call checkmpc (nwds, nfile, 1, exp (z1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'log(z1) ='
call mpwrite (6, ndp + 20, ndp, log (z1))
call checkmpc (nwds, nfile, 1, log (z1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'mpcmplx(t1,t2) ='
call mpwrite (6, ndp + 20, ndp, mpcmplx (t1, t2, nwds))
call checkmpc (nwds, nfile, 1, mpcmplx (t1, t2, nwds), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'mpreal(z1) ='
call mpwrite (6, ndp + 20, ndp, mpreal (z1, nwds))
call checkmp (nwds, nfile, 1, mpreal (z1, nwds), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'sin(z2) ='
call mpwrite (6, ndp + 20, ndp, sin (z2))
call checkmpc (nwds, nfile, 1, sin (z2), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'sqrt(z1) ='
call mpwrite (6, ndp + 20, ndp, sqrt (z1))
call checkmpc (nwds, nfile, 1, sqrt (z1), eps, err)
errmx = max (err, errmx)

write (6, '(a)') 'sqrt(z2) ='
call mpwrite (6, ndp + 20, ndp, sqrt (z2))
call checkmpc (nwds, nfile, 1, sqrt (z2), eps, err)
call mpdecmd (err, d1, n1)

call mpdecmd (errmx, d1, n1)
write (6, 9) d1, n1
9 format (/'Max abs error =',f9.6,'e',i6)

if (abs (errmx) < eps) then
  write (6, '(a)') 'ALL TESTS PASSED'
else
  write (6, '(a)') 'ONE OR MORE TESTS FAILED'
endif

stop
end

subroutine checkmp (nwds, nfile, i1, t1, eps, err)
use mpmodule
implicit none
type (mp_real) t1, t2, eps, err
integer i, nwds, nfile, i1
character(64) c1

do i = 1, i1
  read (nfile, '(a)') c1
enddo

call mpread (nfile, t2, nwds)
err = abs (t1 - t2)

if (abs (err) > eps) then
  write (6, '(a)') 'ERROR:'
  call mpwrite (6, 60, 40, abs (err))
endif

return
end

subroutine checkmpc (nwds, nfile, i1, z1, eps, err)
use mpmodule
implicit none
type (mp_complex) z1, z2, z3
type (mp_real) eps, err
integer i, nwds, nfile, i1
character(64) c1

do i = 1, i1
  read (nfile, '(a)') c1
enddo

call mpread (nfile, z2, nwds)

! err = abs (z1 - z2)
z3 = z1 - z2
err = max (abs (mpreal (z3, nwds)), abs (aimag (z3)))

if (abs (err) > eps) then
  write (6, '(a)') 'ERROR:'
  call mpwrite (6, 60, 40, abs (err))
endif

return
end
