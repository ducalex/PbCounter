Global.l UpdateBtn, QuitBtn, KeyMapBtn, StatisticsLabel, WebUpdateEnabledCheckbox ; Gadgets
Global.l mouseHook, keyboardHook                                                  ; Hooks
Global.l NextUpdate, WebUpdateEnabled, WebUpdateInterval                          ; Config
Global.s ComputerName, LastReset, WebUpdateUrl                                    ; Config
Global.l MouseLeft, MouseMiddle, MouseExtra, MouseRight, MouseWheel, KeyPresses	  ; Statistics
Global Dim KeyMap.l(255)                                                          ; Statistics
Global TB_Message = RegisterWindowMessage_("TaskbarCreated")                      ; Windows Taskbar


IncludeFile "Keyboard.pbi"
 

 Procedure SaveState()
	If OpenPreferences("counter.ini") Or CreatePreferences("counter.ini") ; CreatePreferences is leaking, let's avoid it.
		PreferenceGroup("Global")
			WritePreferenceString("computer", ComputerName)
			WritePreferenceString("lastreset", LastReset)
		PreferenceGroup("Update")
			WritePreferenceString("url", WebUpdateUrl)
			WritePreferenceLong("enabled", WebUpdateEnabled)
			WritePreferenceLong("interval", WebUpdateInterval)
		PreferenceGroup("Counters")
			WritePreferenceLong("left", MouseLeft)
			WritePreferenceLong("right", MouseRight)
			WritePreferenceLong("middle", MouseMiddle)
			WritePreferenceLong("extra", MouseExtra)
			WritePreferenceLong("scroll", MouseWheel)
			WritePreferenceLong("keys", KeyPresses)
			For i = 1 To 254
				WritePreferenceLong("key_" + Str(i), KeyMap(i))
			Next
		ClosePreferences()
		StatusBarText(0, 0, "Disk: " + FormatDate("%mm-%dd %hh:%ii", Date()))
	Else
		StatusBarText(0, 0, "Disk Update Failed")
	EndIf
EndProcedure


 Procedure LoadState()
	OpenPreferences("counter.ini")
		PreferenceGroup("Global")
			ComputerName      = ReadPreferenceString("computer", Hostname())
			LastReset         = ReadPreferenceString("lastreset", FormatDate("%yyyy-%mm-%dd", Date()))
		PreferenceGroup("Update")
			WebUpdateUrl      = ReadPreferenceString("url", "")
			WebUpdateEnabled  = ReadPreferenceLong("enabled", 0)
			WebUpdateInterval = ReadPreferenceLong("interval", 3600)
		PreferenceGroup("Counters")
			MouseLeft         = ReadPreferenceLong("left", 0)
			MouseMiddle       = ReadPreferenceLong("middle", 0)
			MouseExtra        = ReadPreferenceLong("extra", 0)
			MouseRight        = ReadPreferenceLong("right", 0)
			MouseWheel        = ReadPreferenceLong("scroll", 0)
			KeyPresses        = ReadPreferenceLong("keys", 0)
			For i = 1 To 254
				KeyMap(i) = ReadPreferenceLong("key_" + Str(i), 0)
			Next
	ClosePreferences()
EndProcedure


Procedure SendWebStats(force = #False)
	If force Or (WebUpdateEnabled And NextUpdate < Date())
		URL$ = WebUpdateUrl +
			"?al="    + ComputerName +
			"&reset=" + LastReset +
			"&lb="    + Str(MouseLeft) +
			"&rb="    + Str(MouseRight) +
			"&mb="    + Str(MouseMiddle) +
			"&eb="    + Str(MouseExtra) +
			"&scr="	  + Str(MouseWheel) +
			"&ks="    + Str(KeyPresses)
		If (FindString(GetHTTPHeader(URL$), "200 OK"))
			StatusBarText(0, 1, "Web: " + FormatDate("%mm-%dd %hh:%ii", Date()))
		Else
			StatusBarText(0, 1, "Web Update Failed")
		EndIf
		NextUpdate = Date() + WebUpdateInterval
	EndIf
EndProcedure


Procedure UpdateDisplay()
	SysTrayIconToolTip(1, 
		"Clicks: "  + FormatNumber(MouseLeft + MouseRight + MouseMiddle + MouseExtra, 0) + #CRLF$ + 
		"Scrolls: " + FormatNumber(MouseWheel, 0) + #CRLF$ + 
		"Keys: "    + FormatNumber(KeyPresses, 0))
	SetGadgetText(StatisticsLabel, 
		"Computer: "    + ComputerName + #CRLF$ + 
		"Last reset: "  + LastReset + #CRLF$ + 
		"Next Update: " + FormatDate("%yyyy-%mm-%dd %hh:%ii", NextUpdate) + #CRLF$ + 
		"Left: "        + FormatNumber(MouseLeft, 0) + #CRLF$ + 
		"Right: "       + FormatNumber(MouseRight, 0) + #CRLF$ + 
		"Middle: "      + FormatNumber(MouseMiddle, 0) + #CRLF$ + 
		"Extra: "       + FormatNumber(MouseExtra, 0) + #CRLF$ + 
		"Scroll: "      + FormatNumber(MouseWheel, 0) + #CRLF$ + 
		"Keys: "        + FormatNumber(KeyPresses, 0))
EndProcedure


Procedure FixSystray(hWnd, uMsg, WParam, LParam) 
	If uMsg = TB_Message
		AddSysTrayIcon(1, WindowID(Window_0), ImageID(0))
	EndIf
	ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure


Procedure ShowMainWindow()
	AddWindowTimer(0, 1, 1000)
	UpdateDisplay()
	HideWindow(0, #False)
	SetForegroundWindow_(WindowID(0))
EndProcedure


Procedure InitMainWindow()
	OpenWindow(0, 0, 0, 230, 260, "PbCounter - Build " + Str(#PB_Editor_BuildCount), #PB_Window_SystemMenu | #PB_Window_Invisible | #PB_Window_ScreenCentered)
	
	CreateStatusBar(0, WindowID(0))
		AddStatusBarField(115)
		StatusBarText(0, 0, "Last Disk Write")
		AddStatusBarField(115)
		StatusBarText(0, 1, "Last WebUpdate")
	
	UpdateBtn = ButtonGadget(#PB_Any, 5, 200, 85, 30, "Update Now")
	KeyMapBtn = ButtonGadget(#PB_Any, 95, 200, 60, 30, "Keys")
	QuitBtn = ButtonGadget(#PB_Any, 160, 200, 65, 30, "Quit")
	StatisticsLabel = TextGadget(#PB_Any, 10, 10, 210, 160, "")
		SetGadgetFont(StatisticsLabel, FontID(LoadFont(#PB_Any,"Tahoma", 9)))
	WebUpdateEnabledCheckbox = CheckBoxGadget(#PB_Any, 10, 175, 200, 20, "Enable Web WebUpdate")
		SetGadgetState(WebUpdateEnabledCheckbox, WebUpdateEnabled)
	
	CatchImage(0, ?Image)
	AddSysTrayIcon(1, WindowID(Window_0), ImageID(0))
	AddWindowTimer(0, 0, 600000) ; 10 minutes  
	SetWindowCallback(@FixSystray())
EndProcedure


Procedure MainWindowEvents(event)
	Select event
		Case TB_Message
			AddSysTrayIcon(1, WindowID(Window_0), ImageID(0))
			
		Case #WM_KEYDOWN
			HideWindow(0, #True)
			
		Case #PB_Event_CloseWindow
			RemoveWindowTimer(0, 1)
			HideWindow(0, #True)
			
		Case #PB_Event_Timer
			If EventTimer() = 0
				CreateThread(@SendWebStats(), 0)
				SaveState()
			ElseIf EventTimer() = 1
				UpdateDisplay()
			EndIf
				
		Case #PB_Event_SysTray
			Select EventType()
				Case #PB_EventType_RightDoubleClick
					ProcedureReturn #False
				Case #PB_EventType_RightClick
					ShowMainWindow()
				Case #PB_EventType_LeftClick
					ShowMainWindow()
			EndSelect
				
		Case #PB_Event_Gadget
			Select EventGadget()
				Case UpdateBtn
					CreateThread(@SendWebStats(), #True)
					SaveState()
				Case KeyMapBtn
					InitWindow_KeyBoard()
				Case WebUpdateEnabledCheckbox
					WebUpdateEnabled = GetGadgetState(WebUpdateEnabledCheckbox)
					If WebUpdateEnabled 
						url$ = InputRequester("Update URL", "The address to send statistics", WebUpdateUrl)
						If url$ <> ""
							WebUpdateUrl = url$
						EndIf
					EndIf
				Case QuitBtn
					ProcedureReturn #False
			EndSelect
	EndSelect
	ProcedureReturn #True
EndProcedure


Procedure KeyboardEvents(nCode,wParam, *lParam.KBDLLHOOKSTRUCT)
	If wParam	= #WM_KEYUP
		KeyPresses + 1
		KeyMap(*lParam\vkCode) + 1
	EndIf
	ProcedureReturn CallNextHookEx_(keyboardHook, nCode, wParam, lParam)	 
 EndProcedure
 

Procedure MouseEvents(nCode,wParam,lParam)
	Select wParam
		Case #WM_LBUTTONUP
			MouseLeft + 1
		Case #WM_MBUTTONUP
			MouseMiddle + 1
		Case #WM_RBUTTONUP
			MouseRight + 1
		Case #WM_XBUTTONUP
			MouseExtra + 1
		Case #WM_MOUSEWHEEL
			MouseWheel + 1
	EndSelect
	ProcedureReturn CallNextHookEx_(mouseHook, nCode, wParam, lParam)	 
EndProcedure


InitNetwork()
LoadState()
InitMainWindow()
CompilerIf #PB_Compiler_Debugger
	ShowMainWindow()
CompilerEndIf


keyboardHook = SetWindowsHookEx_(#WH_KEYBOARD_LL, @KeyboardEvents(), GetModuleHandle_(0), 0)
mouseHook    = SetWindowsHookEx_(#WH_MOUSE_LL, @MouseEvents(), GetModuleHandle_(0), 0)


Repeat
	event = WaitWindowEvent()
	If EventWindow() = KeyBoardWindow
		KeyBoardWindowEvents(event)
	ElseIf MainWindowEvents(event) = #False
		Break
	EndIf
ForEver


UnhookWindowsHookEx_(mouseHook)
UnhookWindowsHookEx_(keyboardHook)
SaveState()


DataSection
	Image: 
		IncludeBinary "PbCounter.ico"
EndDataSection

; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 249
; FirstLine = 220
; Folding = --
; EnableXP