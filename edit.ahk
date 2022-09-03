#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



#SingleInstance Ignore			;;执行程序前先关闭程序
#Persistent

IsRemnoteOrBrowser() {
    isRemnoteClient := WinActive("ahk_exe RemNote.exe")
    isBrowser := WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe") or WinActive("ahk_exe firefox.exe")
    flag := isRemnoteClient or isBrowser

    ; MsgBox, %currentUrl% %isRemnoteClient%? %isBrowser%  %isRemnoteUrl%  %flag%
    Return flag
}

#If, IsRemnoteOrBrowser()
:*:>>::
Send,{Text}`>`>
Input, ov,  L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
If (ov = ">")
	Send {Text}`>
Return

#If, IsRemnoteOrBrowser()
:T*:<<::<<

#If, IsRemnoteOrBrowser()
:*:::::
Send,{Text}`:`:
Input, ov,  L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
If (ov = ":")
	Send {Text}`:
Return

#If, IsRemnoteOrBrowser()
:*:;;::
Send,{Text};;
Input, ov,  L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
If (ov = ";")
	Send {Text};
Return

#If, IsRemnoteOrBrowser()
<+1::
if (A_PriorHotkey = "<+1")
{
    ; Too much time between presses, so this isn't a double-press.
    Send,{Text}`!
    return
}
Send,{Text}`!
return

#If, IsRemnoteOrBrowser()
<+3::
if (A_PriorHotkey = "<+3")
{
    ; Too much time between presses, so this isn't a double-press.
    Send,{Text}`#
    return
}
Send,{Text}`#
return

#If, IsRemnoteOrBrowser()
<+4::
if (A_PriorHotkey = "<+4")
{
    ; Too much time between presses, so this isn't a double-press.
    Send,{Text}`$
    Send, ^{space}
    return
}
Send,{Text}`$
return

#If, IsRemnoteOrBrowser()
<+5::
if (A_PriorHotkey = "<+5")
{
    ; Too much time between presses, so this isn't a double-press.
    Send,{Text}`%
    return
}
Send,{Text}`%
return
