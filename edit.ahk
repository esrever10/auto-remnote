#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



#SingleInstance Ignore			;;执行程序前先关闭程序
#Persistent

IsRemnote() {
    isRemnoteClient := WinActive("ahk_exe RemNote.exe")
    isBrowser := WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe") or WinActive("ahk_exe firefox.exe")
    currentUrl := GetActiveBrowserURL()
    isRemnoteUrl := InStr(currentUrl, "www.remnote.com") or InStr(currentUrl, "new.remnote.com") or InStr(currentUrl, "beta.remnote.com") or InStr(currentUrl, "remnote.io")

    flag := isRemnoteClient or (isBrowser and isRemnoteUrl)

    ; MsgBox, %currentUrl% %isRemnoteClient%? %isBrowser%  %isRemnoteUrl%  %flag%
    Return flag
}

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
:*:<<::
Send,{Text}`<`<
Return

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
    inline_math_mode = 1
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

#If, IsRemnoteOrBrowser()
<+6::
Send,{Text}`^
return

#If, IsRemnoteOrBrowser()
<+-::
Send,{Text}`_
return

#If, IsRemnoteOrBrowser()
<+9::
Send,{Text}`(
return

#If, IsRemnoteOrBrowser()
<+0::
Send,{Text}`)
return

GetActiveBrowserURL() {
	WinGetClass, sClass, A
	If sClass In Chrome_WidgetWin_1,Chrome_WidgetWin_0,Maxthon3Cls_MainFrm
		Return GetBrowserURL_ACC(sClass)
	Else
		Return GetBrowserURL_DDE(sClass) ; empty string if DDE not supported (or not a browser)
}

; "GetBrowserURL_DDE" adapted from DDE code by Sean, (AHK_L version by maraskan_user)
; Found at http://autohotkey.com/board/topic/17633-/?p=434518

GetBrowserURL_DDE(sClass) {
	WinGet, sServer, ProcessName, % "ahk_class " sClass
	StringTrimRight, sServer, sServer, 4
	iCodePage := A_IsUnicode ? 0x04B0 : 0x03EC ; 0x04B0 = CP_WINUNICODE, 0x03EC = CP_WINANSI
	DllCall("DdeInitialize", "UPtrP", idInst, "Uint", 0, "Uint", 0, "Uint", 0)
	hServer := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", sServer, "int", iCodePage)
	hTopic := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "WWW_GetWindowInfo", "int", iCodePage)
	hItem := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "0xFFFFFFFF", "int", iCodePage)
	hConv := DllCall("DdeConnect", "UPtr", idInst, "UPtr", hServer, "UPtr", hTopic, "Uint", 0)
	hData := DllCall("DdeClientTransaction", "Uint", 0, "Uint", 0, "UPtr", hConv, "UPtr", hItem, "UInt", 1, "Uint", 0x20B0, "Uint", 10000, "UPtrP", nResult) ; 0x20B0 = XTYP_REQUEST, 10000 = 10s timeout
	sData := DllCall("DdeAccessData", "Uint", hData, "Uint", 0, "Str")
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hServer)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hTopic)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hItem)
	DllCall("DdeUnaccessData", "UPtr", hData)
	DllCall("DdeFreeDataHandle", "UPtr", hData)
	DllCall("DdeDisconnect", "UPtr", hConv)
	DllCall("DdeUninitialize", "UPtr", idInst)
	csvWindowInfo := StrGet(&sData, "CP0")
	StringSplit, sWindowInfo, csvWindowInfo, `"
	Return sWindowInfo2
}

GetBrowserURL_ACC(sClass) {
	global nWindow, accAddressBar
	If (nWindow != WinExist("ahk_class " sClass)) ; reuses accAddressBar if it's the same window
	{
		nWindow := WinExist("ahk_class " sClass)
		accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindow))
	}
	Try sURL := accAddressBar.accValue(0)
	If (sURL == "") {
		sURL := accAddressBar.accDescription(0) ; Origin Chip support
		If (sURL == "") {
			WinGet, nWindows, List, % "ahk_class " sClass ; In case of a nested browser window as in CoolNovo
			If (nWindows > 1) {
				accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindows2))
				sURL := accAddressBar.accValue(0)
			}
		}
	}
	If ((sURL != "") and (SubStr(sURL, 1, 4) != "http")) ; Chromium-based browsers omit "http://"
		sURL := "http://" sURL
	Return sURL
}

; "GetAddressBar" based in code by uname
; Found at http://autohotkey.com/board/topic/103178-/?p=637687

GetAddressBar(accObj) {
	Try If ((accObj.accName(0) != "") and IsURL(accObj.accValue(0)))
		Return accObj
	Try If ((accObj.accName(0) != "") and IsURL("http://" accObj.accValue(0))) ; Chromium omits "http://"
		Return accObj
	Try If (InStr(accObj.accDescription(0), accObj.accName(0)) and IsURL(accObj.accDescription(0))) ; Origin Chip support
		Return accObj
	For nChild, accChild in Acc_Children(accObj)
		If IsObject(accAddressBar := GetAddressBar(accChild))
			Return accAddressBar
}

IsURL(sURL) {
	Return RegExMatch(sURL, "^(?<Protocol>https?|ftp)://(?:(?<Username>[^:]+)(?::(?<Password>[^@]+))?@)?(?<Domain>(?:[\w-]+\.)+\w\w+)(?::(?<Port>\d+))?/?(?<Path>(?:[^/?# ]*/?)+)(?:\?(?<Query>[^#]+)?)?(?:\#(?<Hash>.+)?)?$")
}

; The code below is part of the Acc.ahk Standard Library by Sean (updated by jethrow)
; Found at http://autohotkey.com/board/topic/77303-/?p=491516

Acc_Init()
{
	static h
	If Not h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromWindow(hWnd, idObject = 0)
{
	Acc_Init()
	If DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return ComObjEnwrap(9,pacc,1)
}
Acc_Query(Acc) {
	Try Return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}
Acc_Children(Acc) {
	If ComObjType(Acc,"Name") != "IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	Else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		If DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren%
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
			Return Children.MaxIndex()?Children:
		} Else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
}
