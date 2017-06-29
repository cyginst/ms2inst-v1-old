@if(0)==(0) echo off
:: URL: https://github.com/cyginst/cyginst-v1/blob/master/cyginst.bat
setlocal ENABLEDELAYEDEXPANSION

if "%1"=="SUBPROC" goto skip_init

set CYG_NAME=ms2inst
set CYG_BITS=32
set CYG_PKGS=procps,psmisc,tmux-git,diffutils,vim,emacs,glib2,libhogweed,mingw-w64-i686-gcc,mingw-w64-i686-emacs,mingw-w64-x86_64-emacs
set DT_ICONS=1
::set CYG_HOME=.
::set CYG_ASIS=1

set CYG_DEBUG=0
set CYG_SITE=http://mirrors.kernel.org/sourceware/cygwin/
set CYG_FONT=MS Gothic
set CYG_FONT_HEIGHT=12
set CYG_CURSOR_TYPE=block
set CYG_CONFIRM_EXIT=no

:skip_init

set SCRIPT=%~0
for /f "delims=\ tokens=*" %%z in ("%SCRIPT%") do (set SCRIPT_CURRENT_DIR=%%~dpz)

if "%CYG_DEBUG%"=="1" echo on
set CYG_SETUP=
if "%CYG_BITS%"=="32" (
    set CYG_SETUP=msys2-i686-20161025.7z
) else if "%CYG_BITS%"=="64" (
    set CYG_SETUP=msys2-x86_64-20161025.7z
) else (
    echo CYG_BITS must be 32 or 64. [Current CYG_BITS: %CYG_BITS%] Aborting!
    if not "%1"=="SUBPROC" pause
    exit /b
)
call :dl_from_url %CYG_SETUP% https://raw.githubusercontent.com/cyginst/ms2inst-v1/master/binaries/%CYG_SETUP%
call :dl_from_url 7z.exe      https://raw.githubusercontent.com/cyginst/ms2inst-v1/master/binaries/7z.exe
call :dl_from_url 7z.dll      https://raw.githubusercontent.com/cyginst/ms2inst-v1/master/binaries/7z.dll
set CYG_ROOT=%SCRIPT_CURRENT_DIR%%CYG_NAME%.m%CYG_BITS%
if not exist "%CYG_ROOT%" (
    if exist "%CYG_ROOT%.tmp" rmdir /s /q "%CYG_ROOT%.tmp"
    7z.exe x -y -o"%CYG_ROOT%.tmp" "%CYG_SETUP%" && move "%CYG_ROOT%.tmp" "%CYG_ROOT%"
)
rem set cmd="%CYG_ROOT%\usr\bin\bash.exe" -l -c "pacman --noconfirm -Syuu"
rem echo %cmd%
rem %cmd%
if not "%CYG_PKGS%"=="" (
  for %%a in ("%CYG_PKGS:,=" "%") do (
      set cmd="%CYG_ROOT%\usr\bin\bash.exe" -l -c "pacman -Qi %%~a >& /dev/null || pacman --noconfirm -S %%~a"
      echo !cmd!
      !cmd!
  )
)
cscript.exe //nologo //E:JScript "%~f0"

echo Installation for %CYG_NAME% finished!

endlocal
if not "%1"=="SUBPROC" pause
exit /b
goto :EOF
:dl_from_url
if not exist "%SCRIPT_CURRENT_DIR%%1" bitsadmin /TRANSFER "%1" "%2" "%SCRIPT_CURRENT_DIR%%1"
exit /b
@end

  if (!String.prototype.format) {
    String.prototype.format = function() {
      var args = arguments;
      return this.replace(/{(\d+)}/g, function(match, number) { 
        return typeof args[number] != 'undefined'
          ? args[number]
          : match
        ;
      });
    };
  }

  if (!String.prototype.startsWith) {
    String.prototype.startsWith = function(prefix) {
      return (this.lastIndexOf(prefix, 0) === 0);
    };
  }

  if (!String.prototype.endsWith) {
    String.prototype.endsWith = function(suffix) {
      var sub = this.length - suffix.length;
      return (sub >= 0) && (this.lastIndexOf(suffix) === sub);
    };
  }

  if (!String.prototype.removeFirst) {
    String.prototype.removeFirst = function(prefix) {
      if (this.lastIndexOf(prefix, 0) === 0) {
        return this.substr(prefix.length);
      } else {
        return this;
      }
    };
  }

  if (!String.prototype.removeLast) {
    String.prototype.removeLast = function(suffix) {
      var sub = this.length - suffix.length;
      if (sub >= 0 && this.lastIndexOf(suffix) === sub) {
        return this.substr(0, this.lastIndexOf(suffix));
      } else {
        return this;
      }
    };
  }

  var env = new ActiveXObject("WScript.Shell").Environment("PROCESS");

  var CYG_OPTS = {
    debug:       (env.item("CYG_DEBUG") == "1"),
    root:         env.item("CYG_ROOT"),
    name:         env.item("CYG_NAME"),
    bits:         env.item("CYG_BITS"),
    dt_icons:    (env.item("DT_ICONS") == "1"),
    home:         env.item("CYG_HOME").replace(/^\s+|\s+$/g, ''), /*trim()*/
    asis:        (env.item("CYG_ASIS") == "1"),
    lang:         env.item("CYG_LANG"),
    font:         env.item("CYG_FONT"),
    font_height:  env.item("CYG_FONT_HEIGHT"),
    cursor_type:  env.item("CYG_CURSOR_TYPE"),
    confirm_exit: env.item("CYG_CONFIRM_EXIT")
  };

  postCygwinInstall(CYG_OPTS);

  WScript.Quit();

  function echo(msg) {
    WScript.Echo(msg);
  }
  function msgbox(msg) {
    var shell = new ActiveXObject("WScript.Shell");
    shell.Popup(msg, 0, "Cygwin Install", 0);
  }

  function postCygwinInstall(opts) {

    var StreamTypeEnum    = { adTypeBinary: 1, adTypeText: 2 };
    var LineSeparatorEnum = { adLF: 10, adCR: 13, adCRLF: -1 };
    var StreamReadEnum    = { adReadAll: -1, adReadLine: -2 };
    var StreamWriteEnum   = { adWriteChar: 0, adWriteLine: 1 };
    var SaveOptionsEnum   = { adSaveCreateNotExist: 1, adSaveCreateOverWrite: 2 };

    function createShorcut(dir, name, icon, target, args) {
      var shell = new ActiveXObject("WScript.Shell");
      var sc = shell.CreateShortcut(dir + "\\" + name + ".lnk");
      sc.IconLocation = icon;
      sc.TargetPath = target;
      sc.Arguments = args;
      sc.WorkingDirectory = "";
      sc.Save();
    }

    function writeTextToFile_Utf8_NoBOM(path, text) {
      var stream = new ActiveXObject("ADODB.Stream");
      stream.Type = StreamTypeEnum.adTypeText;
      stream.Charset = "utf-8";
      stream.Open();
      stream.WriteText(text);
      stream.Position = 0
      stream.Type = StreamTypeEnum.adTypeBinary;
      stream.Position = 3
      var buf = stream.Read();
      stream.Position = 0
      stream.Write(buf);
      stream.SetEOS();
      stream.SaveToFile(path, SaveOptionsEnum.adSaveCreateOverWrite);
      stream.Close();
    }

    function deleteFile(path) {
      var fso = new ActiveXObject("Scripting.FileSystemObject");
      try {
        fso.DeleteFile(path, true);
      } catch(e) {
      }
    }

    function editConfigFile(path, lineStart, lineAfter, override) {
      if (lineAfter == null) override = true;
      var txt = "";
      var found = false;
      var match = false;
      try {
        var stream1 = new ActiveXObject("ADODB.Stream");
        stream1.Type = StreamTypeEnum.adTypeText;
        stream1.Charset = "utf-8";
        stream1.LineSeparator = LineSeparatorEnum.adLF;
        stream1.Open();
        stream1.LoadFromFile(path);
        while (!stream1.EOS) {
          var line = stream1.ReadText(StreamReadEnum.adReadLine);
            if (line.startsWith(lineStart)) {
              found = true;
              if (!override) break;
              if (lineAfter == null) continue;
              if (line == lineAfter) {
                match = true;
                break;
              }
              line = lineAfter;
            }
            txt += line + "\n";
        }
        if (!found && lineAfter != null) txt += lineAfter + "\n";
        stream1.Close();
      } catch(e) {
        if (lineAfter != null) txt = lineAfter + "\n";
      }
      if (match) return;
      if (found && !override) return;
      if (txt == "")
        deleteFile(path)
      else
        writeTextToFile_Utf8_NoBOM(path, txt);
    }

    function defaultSetting(path, lineStart, lineAfter) { editConfigFile(path, lineStart, lineAfter, false); }

    function replaceSetting(path, lineStart, lineAfter) { editConfigFile(path, lineStart, lineAfter, true); }

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var shell = new ActiveXObject("WScript.Shell");

    var profilePath = opts.root + "\\etc\\profile";
    if (opts.home == "") {
    } else {
      var absoluteHome = opts.home.endsWith("$");
      opts.home = opts.home.removeLast("$");
      opts.home = fso.GetAbsolutePathName(opts.home).replace(new RegExp("\\\\", "g"), "/");
      opts.home = opts.home.removeLast("/");
      opts.home = opts.home + (absoluteHome ? "" : "/%USERNAME%");
    }

    var bashrcPath = opts.root + "\\etc\\bash.bashrc";
    var bashrcOrig = bashrcPath + ".orig";
    if (fso.FileExists(bashrcPath)) {
      if (!fso.FileExists(bashrcOrig)) {
        fso.CopyFile(bashrcPath, bashrcOrig, true);
      }
      defaultSetting(bashrcPath, "[[ -n \"${MSYS2_PS1}\" ]] && export PS1=", null);
      defaultSetting(bashrcPath, "[[ $(declare -p PS1 2>/dev/null | cut -c 1-11) = 'declare -x ' ]]", null);
          var ps1 = ("if [ \"x$INSIDE_EMACS\" != \"x\" ]; then export PS1='\\[\\e[35m\\]\\u@{0} $MSYSTEM({1}bit) \\w\\[\\e[0m\\]\\n\\$ '; "
                     + "else export PS1='\\[\\e]0;$MSYSTEM({1}bit) @{0} \\w\\a\\]\\n\\[\\e[32m\\]\\u@{0} \\[\\e[35m\\]$MSYSTEM({1}bit)\\[\\e[0m\\] \\[\\e[33m\\]\\w\\[\\e[0m\\]\\n\\$ '; fi")
                    .format(opts.name, opts.bits);
      replaceSetting(bashrcPath, "  export PS1=", ps1);
    }

    var desktopPath = shell.SpecialFolders("Desktop");
    if (opts.debug) echo("desktopPath=" + desktopPath);

    var minttyPath = opts.root + "\\usr\\bin\\mintty.exe";
    if (!fso.FileExists(minttyPath)) return;

    var minttyrcPath = opts.root + "\\etc\\minttyrc";
    if (opts.font != "")         defaultSetting(minttyrcPath, "Font=",        "Font={0}".format(opts.font));
    if (opts.font_height != "")  defaultSetting(minttyrcPath, "FontHeight=",  "FontHeight={0}".format(opts.font_height));
    if (opts.cursor_type != "")  defaultSetting(minttyrcPath, "CursorType=",  "CursorType={0}".format(opts.cursor_type));
    if (opts.confirm_exit != "") defaultSetting(minttyrcPath, "ConfirmExit=", "ConfirmExit={0}".format(opts.confirm_exit));

    var minttyCommon = "--window max";

    var name, icon, target, args;
    function scMingwShell(mingwBits) {
      name = "MINGW{0} Shell @{1} ({2}bit)".format(mingwBits, opts.name, opts.bits);
      icon = opts.root + "\\mingw{0}.exe, 0".format(mingwBits);
      target = minttyPath;
      args = "{1} -i /mingw{0}.exe  /usr/bin/env MSYSTEM=MINGW{0} {2} /usr/bin/bash -l -i".format(mingwBits, minttyCommon, opts.home=="" ? "" : "HOME="+opts.home);
      createShorcut(opts.root, name, icon, target, args);
      if (opts.dt_icons) createShorcut(desktopPath, name, icon, target, args);
    }
    scMingwShell(32);
    scMingwShell(64);

    var vimPath = opts.root + "\\usr\\bin\\vim.exe";
    if (fso.FileExists(vimPath)) {
      var viText = "#!/usr/bin/bash\n/usr/bin/vim $*";
      writeTextToFile_Utf8_NoBOM(opts.root + "\\usr\\bin\\vi", viText);
    }

    var tmuxPath = opts.root + "\\usr\\bin\\tmux.exe";
    if (fso.FileExists(tmuxPath)) {
      var tmuxConfPath = opts.root + "\\etc\\tmux.conf";
      replaceSetting(tmuxConfPath, "bind -n S-up ",
                opts.asis ? null : "bind -n S-up select-pane -U \\; display-panes");
      replaceSetting(tmuxConfPath, "bind -n S-down ",
                opts.asis ? null : "bind -n S-down select-pane -D \\; display-panes");
      replaceSetting(tmuxConfPath, "bind -n S-left ",
                opts.asis ? null : "bind -n S-left select-pane -L \\; display-panes");
      replaceSetting(tmuxConfPath, "bind -n S-right ",
                opts.asis ? null : "bind -n S-right select-pane -R \\; display-panes");
      replaceSetting(tmuxConfPath, "bind-key -n C-Up ",
                opts.asis ? null : "bind-key -n C-Up resize-pane -U \\; display-panes");
      replaceSetting(tmuxConfPath, "bind-key -n C-Down ",
                opts.asis ? null : "bind-key -n C-Down resize-pane -D \\; display-panes");
      replaceSetting(tmuxConfPath, "bind-key -n C-Left ",
                opts.asis ? null : "bind-key -n C-Left resize-pane -L \\; display-panes");
      replaceSetting(tmuxConfPath, "bind-key -n C-Right ",
                opts.asis ? null : "bind-key -n C-Right resize-pane -R \\; display-panes");
      var name, icon, target, args;
      function scTmux(mingwBits) {
        name = "Tmux MINGW{0} @{1} ({2}bit)".format(mingwBits, opts.name, opts.bits);
        icon = opts.root + "\\mingw{0}.exe, 0".format(mingwBits);
        target = minttyPath;
        args = "{1} -i /mingw{0}.exe -t \"Tmux MINGW32 @{2} ({3}bit)\" /usr/bin/env MSYSTEM=MINGW{0} {4} /usr/bin/bash -l -c  \"/usr/bin/tmux\""
               .format(mingwBits, minttyCommon, opts.name, opts.bits, opts.home=="" ? "" : "HOME="+opts.home);
        createShorcut(opts.root, name, icon, target, args);
        if (opts.dt_icons) createShorcut(desktopPath, name, icon, target, args);
      }
      scTmux(32);
      scTmux(64);
    }

    var emacsPath = opts.root + "\\usr\\bin\\emacs.exe";
    if (fso.FileExists(emacsPath)) {
      var name, icon, target, args;
      function scEmacs(mingwBits) {
        name = "Emacs MINGW{0} @{1} ({2}bit)".format(mingwBits, opts.name, opts.bits);
        icon = opts.root + "\\mingw{0}.exe, 0".format(mingwBits);
        target = minttyPath;
        args = "{1} -i /mingw{0}.exe -t \"Emacs MINGW32 @{2} ({3}bit)\" /usr/bin/env MSYSTEM=MINGW{0} {4} /usr/bin/bash -l -c  \"/usr/bin/emacs -nw --eval '(progn (shell) (delete-other-windows))'\""
               .format(mingwBits, minttyCommon, opts.name, opts.bits, opts.home=="" ? "" : "HOME="+opts.home);
        createShorcut(opts.root, name, icon, target, args);
        if (opts.dt_icons) createShorcut(desktopPath, name, icon, target, args);
      }
      scEmacs(32);
      scEmacs(64);
    }

    function editEmacsSiteStart(siteStartPath) {
      if (fso.FolderExists(fso.getParentFolderName(siteStartPath))) {
        echo("EDIT: " + siteStartPath);
        defaultSetting(siteStartPath,
          "(setq frame-title-format ",
          "(setq frame-title-format \"[%b] @{0} - Emacs ({1}bit)\")".format(opts.name, opts.bits));
        defaultSetting(siteStartPath,
          "(set-frame-parameter nil 'fullscreen ",
          opts.asis ? null : "(set-frame-parameter nil 'fullscreen 'maximized)");
        defaultSetting(siteStartPath,
          "(windmove-default-keybindings",
          opts.asis ? null : "(windmove-default-keybindings 'meta)");
        defaultSetting(siteStartPath, "(global-set-key (kbd \"\\e <up>\")",
                   opts.asis ? null : "(global-set-key (kbd \"\\e <up>\") 'windmove-up)");
        defaultSetting(siteStartPath, "(global-set-key (kbd \"\\e <down>\")",
                   opts.asis ? null : "(global-set-key (kbd \"\\e <down>\") 'windmove-down)");
        defaultSetting(siteStartPath, "(global-set-key (kbd \"\\e <left>\")",
                   opts.asis ? null : "(global-set-key (kbd \"\\e <left>\") 'windmove-left)");
        defaultSetting(siteStartPath, "(global-set-key (kbd \"\\e <right>\")",
                   opts.asis ? null : "(global-set-key (kbd \"\\e <right>\") 'windmove-right)");
        defaultSetting(siteStartPath, "(global-set-key (kbd \"\\C-x <kp-add>\")",
                   opts.asis ? null : "(global-set-key (kbd \"\\C-x <kp-add>\") 'balance-windows)");
      }
    }
    editEmacsSiteStart(opts.root + "\\usr\\share\\emacs\\site-lisp\\site-start.el");
    editEmacsSiteStart(opts.root + "\\mingw32\\share\\emacs\\site-lisp\\site-start.el");
    editEmacsSiteStart(opts.root + "\\mingw64\\share\\emacs\\site-lisp\\site-start.el");

  }

