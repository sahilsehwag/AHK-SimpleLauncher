#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


global PATH
global GCMD
global commandBarCommand


^t::
	PATH := GETEXPLORERPATH()

	global CommandBar
	global commandBarCommand

	customColor := 333333
	GUI CommandBar: NEW
	GUI CommandBar: FONT, s14 cFFFFFF
	GUI CommandBar: COLOR, %customColor%, %customColor%
	GUI CommandBar: MARGIN, 12, 12

	WINSET, TRANSCOLOR, %customColor% 20, CommandBar
	GUI CommandBar: +LASTFOUND -CAPTION +ALWAYSONTOP

	;GUI CommandBar: ADD, TEXT, y13 c9966FF, %prompt%
	GUI CommandBar: ADD, TEXT, y13, >
	GUI CommandBar: ADD, EDIT, y12 h70  w600 cE6E6E6 r1 -E0x200 vcommandBarCommand
	GUI CommandBar: SHOW, xCENTER	y100, CommandBar
RETURN




#IFWINACTIVE CommandBar
enter::
	GUI CommandBar: SUBMIT
	GCMD = %commandBarCommand%
	RUNCOMMAND(GCMD, PATH)
RETURN

escape::GUI CommandBar: DESTROY




#IF
GETEXPLORERPATH(handler=""){
	IF (handler = "" )
  		handler := WINEXIST("A")
	WINGET process, ProcessName, ahk_id %handler%
	IF (process = "explorer.exe"){
		WINGETCLASS windowClass, ahk_id %handler%
		IF (windowClass ~= "Progman|WorkerW")
			windowPath := A_Desktop
		ELSE IF (windowClass ~= "(Cabinet|Explore)WClass"){
		 	FOR window IN ComObjCreate("Shell.Application").Windows
		    IF (window.HWnd == handler){
		       	URL := window.LocationURL
		       	BREAK
		    }
			STRINGTRIMLEFT, windowPath, URL, 8 ; remove "file:///"
			STRINGREPLACE windowPath, windowPath, /, \, All
		}
	}
	RETURN windowPath
}


RUNCOMMAND(command, path){
	SETWORKINGDIR %path%
	RUN %command%	
}
