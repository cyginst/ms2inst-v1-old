@echo off
setlocal

REM --- EDIT THIS PART(START) ---
set CYG_NAME=develop1
set CYG_BITS=32
set CYG_PKGS=diffutils,man-db,procps,psmisc
set CYG_USE_MINGW32=1
::set CYG_USE_MINGW64=1
::set CYG_USE_MSYS=1
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

attrib -H ms2inst-dl.wsf >NUL 2>&1
attrib -H ms2inst.bat    >NUL 2>&1
@echo off
for /f "delims=:" %%a in ('findstr -n "^___" %0') do set "LINE=%%a"
(for /f "skip=%LINE% tokens=* eol=_" %%a in ('type %0') do echo(%%a) > ms2inst-dl.wsf
@echo on
cscript.exe //nologo ms2inst-dl.wsf
if "%CYG_DEBUG%"=="1" (set HIDE_OPT=-H) else (set HIDE_OPT=+H)
attrib %HIDE_OPT% ms2inst-dl.wsf
attrib %HIDE_OPT% ms2inst.bat
@echo on
call ms2inst.bat SUBPROC
endlocal
pause
exit /b
goto :EOF
___DATA___
<package>
<job>
<script language="JavaScript">
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
</script>
</job>
</package>

