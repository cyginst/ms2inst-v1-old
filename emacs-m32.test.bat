setlocal

set CYG_NAME=emacs-m32.test
set CYG_BITS=32
set CYG_PKGS=diffutils,man-db,procps,psmisc,tmux-git,vim,mingw-w64-i686-emacs
set DT_ICONS=1
set CYG_USE_MINGW32=1
set CYG_USE_MINGW64=1
::set CYG_USE_MSYS=1
set CYG_HOME=.$
::set CYG_ASIS=1

set CYG_DEBUG=0
set CYG_FONT=MS Gothic
set CYG_FONT_HEIGHT=12
set CYG_CURSOR_TYPE=block
set CYG_CONFIRM_EXIT=no

call ms2inst.bat SUBPROC

endlocal
pause
