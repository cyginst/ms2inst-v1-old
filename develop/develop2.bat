@if(0)==(0) echo off
:: URL: http://bit.ly/cyginst
:: Last Update: 2017/06/29 21:21
setlocal

REM --- EDIT THIS PART(START) ---
set CYG_NAME=develop2
set CYG_BITS=32
set CYG_PKGS=diffutils,man-db,procps,psmisc
set CYG_PKGS=%CYG_PKGS%,tmux-git               &:: THIS IS GIT
set CYG_PKGS=%CYG_PKGS%,vim                    &:: THIS IS VIM
set CYG_PKGS=%CYG_PKGS%,emacs,glib2,libhogweed &:: THIS IS EMACS
set DT_ICONS=1
set CYG_HOME=.
::set CYG_ASIS=1
REM --- EDIT THIS PART(END) ---

REM --- DEBUG/CUSTOMIZE(START) ---
set CYG_DEBUG=0
set CYG_FONT=MS Gothic
set CYG_FONT_HEIGHT=12
set CYG_CURSOR_TYPE=block
set CYG_CONFIRM_EXIT=no
REM --- DEBUG/CUSTOMIZE(END) ---

cscript.exe //nologo //E:JScript "%~f0"
call ms2inst.bat SUBPROC
endlocal
pause
exit /b
goto :EOF
@end
var fso = new ActiveXObject("Scripting.FileSystemObject");
var SCRIPT_CURRENT_DIR = fso.getParentFolderName(WScript.ScriptFullName);
var url = "https://raw.githubusercontent.com/cyginst/ms2inst-v1/master/ms2inst.bat";
var fileName = SCRIPT_CURRENT_DIR + "\\ms2inst.bat";
try {
  downloadFile(url, fileName);
} catch (e) {
  WScript.Echo("Could not download: ms2inst.bat");
}
WScript.Quit();
function downloadFile(url, fileName) {
  var StreamTypeEnum  = { adTypeBinary: 1, adTypeText: 2 };
  var SaveOptionsEnum = { adSaveCreateNotExist: 1, adSaveCreateOverWrite: 2 };
  var http = WScript.CreateObject("MSXML2.XMLHTTP");
  var strm = WScript.CreateObject("ADODB.Stream");
  http.Open("GET", url, false);
  http.Send();
  strm.Type = StreamTypeEnum.adTypeBinary;
  strm.Open();
  strm.Write(http.responseBody);
  strm.SaveToFile(fileName, SaveOptionsEnum.adSaveCreateOverWrite);
}

