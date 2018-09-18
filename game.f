<perm> definitions:

hex

0 val colors
0 val addr

: frame
    colors 1+ 7 and to colors

    0 15 pal-col!
    1 16 pal-col!
    2 30 pal-col!
    3 31 pal-col!
  
    18 c-to vppu-mask

    addr 1+ and 1FFF to addr
    [
      val-addr addr 1+ LDA
      2006 STA
      val-addr addr LDA
      2006 STA
      val-addr colors LDA
      2007 STA
    ]

    vppu-mask 1F and
    colors asl asl asl asl asl or c-to vppu-mask
;

: init
  font 0 mv>ppu
;

: done
  freeze \ stop emulation and write NES ROM
  wait-for-ppu
  \ Disable rendering
  [ 0 LDA.#
    2000 STA ]
  init
  \ Enable NMIs
  [ 80 LDA.#
    2000 STA ]
  \ Loop forever and call the frame function each frame
  begin
    ppu-wait-nmi
    frame
  0 until
;

: print9
  c-sp @ .
  dsp@ .
  0A 0 do
    900 i + .
    yield
  loop
;

: print8
  c-sp @ .
  dsp@ .
  0A 0 do
    800 i + .
    yield
  loop
;

: printany
  c-sp @ .
  dsp@ .
  0A 0 do
    dup i + .
    yield
  loop
  drop
;

' print9 co-start .
' print8 co-start .
500 ' printany co-start >co

400 printany

4 pal-bright
80 to vppu-ctrl
