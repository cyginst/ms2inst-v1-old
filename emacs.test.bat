setlocal

set MSYS2_NAME=emacs.test
set MSYS2_BITS=32
set MSYS2_PKGS=procps,psmisc,tmux-git,diffutils,vim,emacs,glib2,libhogweed
set DT_ICONS=1
set MSYS2_USE_MINGW32=1
::set MSYS2_USE_MINGW64=1
::set MSYS2_USE_MSYS=1
set MSYS2_HOME=.$
::set MSYS2_ASIS=1

set MSYS2_DEBUG=0
set MSYS2_FONT=MS Gothic
set MSYS2_FONT_HEIGHT=12
set MSYS2_CURSOR_TYPE=block
set MSYS2_CONFIRM_EXIT=no

call ms2inst.bat SUBPROC

endlocal
pause
