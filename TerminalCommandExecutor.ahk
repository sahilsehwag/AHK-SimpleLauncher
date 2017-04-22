#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


global PATH
global GCMD


^t::
	PATH := GETEXPLORERPATH()

	customColor = 333333
	GUI TERMINAL: NEW
	GUI TERMINAL: FONT, s14 cFFFFFF
	GUI TERMINAL: COLOR, %customColor%, %customColor%
	GUI TERMINAL: MARGIN, 0, 0

	WINSET, TRANSCOLOR, %customColor% 20, TERMINAL	
	GUI TERMINAL: +LASTFOUND -CAPTION +ALWAYSONTOP

	GUI TERMINAL: ADD, EDIT, w500 r1 vcommand	
	GUI TERMINAL: SHOW, xCENTER	y100, TERMINAL
RETURN




#IFWINACTIVE TERMINAL
enter::
	GUI TERMINAL: SUBMIT
	GCMD = %command%
	RUNCOMMAND(GCMD, PATH)
RETURN

escape::GUI TERMINAL: DESTROY




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
