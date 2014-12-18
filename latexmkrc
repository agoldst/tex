# config file for the latexmk build tool
# 
# see "man latexmk" for more. This is perl code which is evaluated when
# latexmk is run.
#
# save as ~/.latexmkrc for latexmk to use this by default

# default to xelatex
$pdflatex=q/xelatex %O %S/;
$pdf_mode = 1;
$dvi_mode = 0;
$postscript_mode = 0;

# default to MacOS Preview for latexmk -pv or latexmk -pvc
$pdf_previewer = 'open %S';

# send almost all latex output to /dev/null
$silent = 1;

# vim: ft=perl
