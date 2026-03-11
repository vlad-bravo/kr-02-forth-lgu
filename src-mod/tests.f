\ Тесты

: HH " HELLO, HABR!" COUNT TYPE ;

\ division, floored
\     Integer division in which the remainder carries  the  sign  of
\     the  divisor  or  is zero,  and the quotient is rounded to its
\     arithmetic floor.  Note that,  except for error conditions, n1
\     n2  SWAP  OVER /MOD ROT * + is identical to n1.  See:  "floor,
\     arithmetic" Examples:
\          dividend  divisor  remainder  quotient
\            10        7        3          1
\           -10        7        4         -2
\            10       -7       -4         -2
\           -10       -7       -3          1
: STD-TEST1
  100 17
  SWAP OVER /MOD ROT * + .
;

: TESTS
  STD-TEST1
;
