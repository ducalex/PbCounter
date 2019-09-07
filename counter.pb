Global.l UpdateBtn, QuitBtn, KeyMapBtn, StatisticsLabel, UpdateEnabledCheckbox,
          NextUpdate, UpdateEnabled, UpdateInterval, MouseLeft, MouseMiddle, MouseExtra, MouseRight, MouseWheel, Keys,
          mouseHook, keyboardHook
Global.s ComputerName, LastReset, UpdateUrl
Global Dim KeyMap.l(255)

Global TB_Message = RegisterWindowMessage_("TaskbarCreated")


IncludeFile "keyboard.pbi"


; Structure KBDLLHOOKSTRUCT
;   vkCode.l
;   scanCode.l
;   flags.l
;   time.l
;   dwExtraInfo.l
; EndStructure 


 Procedure.s NumberFormat(i.l)
   Protected s.s = Str(i)
   i.l = Len(s)
   While i > 3
      i - 3
      s = InsertString(s,",", i + 1)
   Wend
   ProcedureReturn s
 EndProcedure
 

 Procedure SaveState()
  If OpenPreferences("counter.ini") Or CreatePreferences("counter.ini") ; CreatePreferences is leaking, let's avoid it.
    PreferenceGroup("Global")
      WritePreferenceString("computer", ComputerName)
      WritePreferenceString("lastreset", LastReset)
    PreferenceGroup("Update")
      WritePreferenceString("url", UpdateUrl)
      WritePreferenceLong("enabled", UpdateEnabled)
      WritePreferenceLong("interval", UpdateInterval)
    PreferenceGroup("Counters")
      WritePreferenceLong("left", MouseLeft)
      WritePreferenceLong("right", MouseRight)
      WritePreferenceLong("middle", MouseMiddle)
      WritePreferenceLong("extra", MouseExtra)
      WritePreferenceLong("scroll", MouseWheel)
      WritePreferenceLong("keys", keys)
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
      ComputerName   = ReadPreferenceString("computer", Hostname())
      LastReset      = ReadPreferenceString("lastreset", FormatDate("%yyyy-%mm-%dd", Date()))
    PreferenceGroup("Update")
      UpdateUrl      = ReadPreferenceString("url", "http://alexou.net/pub/PbCounter/php/")
      UpdateEnabled  = ReadPreferenceLong("enabled", 0)
      UpdateInterval = ReadPreferenceLong("interval", 3600)
    PreferenceGroup("Counters")
      MouseLeft      = ReadPreferenceLong("left", 0)
      MouseMiddle    = ReadPreferenceLong("middle", 0)
      MouseExtra     = ReadPreferenceLong("extra", 0)
      MouseRight     = ReadPreferenceLong("right", 0)
      MouseWheel     = ReadPreferenceLong("scroll", 0)
      Keys = ReadPreferenceLong("keys", 0)
      For i = 1 To 254
        KeyMap(i) = ReadPreferenceLong("key_" + Str(i), 0)
      Next
  ClosePreferences()
EndProcedure


Procedure UpdateStats(force = #False)
  If force Or (UpdateEnabled And NextUpdate < Date())
    Protected url.s = UpdateUrl; SetURLPart?
    url + "?al=" + ComputerName
    url + "&reset=" + LastReset
    url + "&lb=" + Str(MouseLeft)
    url + "&rb=" + Str(MouseRight)
    url + "&mb=" + Str(MouseMiddle)
    url + "&eb=" + Str(MouseExtra)
    url + "&scr=" + Str(MouseWheel)
    url + "&ks=" + Str(Keys)
    If (FindString(GetHTTPHeader(url), "200 OK"))
      StatusBarText(0, 1, "Web: " + FormatDate("%mm-%dd %hh:%ii", Date()))
    Else
      StatusBarText(0, 1, "Web Update Failed")
    EndIf
    NextUpdate = Date() + UpdateInterval
  EndIf
EndProcedure


Procedure UpdateDisplay()
  SysTrayIconToolTip(1, "Clicks: " + NumberFormat(MouseLeft + MouseRight + MouseMiddle + MouseExtra) + #CRLF$ + "Scrolls: " + NumberFormat(MouseWheel) + #CRLF$ + "Keys: " + NumberFormat(Keys))
  SetGadgetText(StatisticsLabel, "Computer: " + ComputerName + #CRLF$ + "Last reset: " + LastReset + #CRLF$ + "Next Update: " + FormatDate("%yyyy-%mm-%dd %hh:%ii", NextUpdate) + #CRLF$ + "Left: " + NumberFormat(MouseLeft) + #CRLF$ + "Right: " + NumberFormat(MouseRight) + #CRLF$ + "Middle: " + NumberFormat(MouseMiddle) + #CRLF$ + "Extra: " + NumberFormat(MouseExtra) + #CRLF$ + "Scroll: " + NumberFormat(MouseWheel) + #CRLF$ + "Keys: " + NumberFormat(Keys))   
EndProcedure


Procedure InitWindow()
  OpenWindow(0, 0, 0, 230, 260, "PbCounter - Build " + Str(#PB_Editor_BuildCount), #PB_Window_SystemMenu | #PB_Window_Invisible | #PB_Window_ScreenCentered)
  
  CreateStatusBar(0, WindowID(0))
    AddStatusBarField(115)
    StatusBarText(0, 0, "Last Disk Write")
    AddStatusBarField(115)
    StatusBarText(0, 1, "Last Update")
  
  UpdateBtn = ButtonGadget(#PB_Any, 5, 200, 85, 30, "Update Now")
  KeyMapBtn = ButtonGadget(#PB_Any, 95, 200, 60, 30, "Keys")
  QuitBtn = ButtonGadget(#PB_Any, 160, 200, 65, 30, "Quit")
  StatisticsLabel = TextGadget(#PB_Any, 10, 10, 210, 160, "")
    SetGadgetFont(StatisticsLabel, FontID(LoadFont(#PB_Any,"Tahoma", 9)))
  UpdateEnabledCheckbox = CheckBoxGadget(#PB_Any, 10, 175, 200, 20, "Enable Web Update")
    SetGadgetState(UpdateEnabledCheckbox, UpdateEnabled)
  
  CatchImage(0, ?Image)
  AddSysTrayIcon(1, WindowID(Window_0), ImageID(0))
  AddWindowTimer(0, 0, 600000) ; 10 minutes
EndProcedure


Procedure Window_Events(event)
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
        CreateThread(@UpdateStats(), 0)
        SaveState()
      Else
        UpdateDisplay()
      EndIf
        
    Case #PB_Event_SysTray
      Select EventType()
        Case #PB_EventType_RightDoubleClick
          ProcedureReturn #False
        Case #PB_EventType_RightClick
;          ProcedureReturn #False
        Case #PB_EventType_LeftClick
          AddWindowTimer(0, 1, 1000)
          UpdateDisplay()
          HideWindow(0, #False)
          SetForegroundWindow_(WindowID(0))
      EndSelect
        
    Case #PB_Event_Gadget
      Select EventGadget()
        Case UpdateBtn
          CreateThread(@UpdateStats(), #True)
          SaveState()
        Case QuitBtn
          ProcedureReturn #False
        Case KeyMapBtn
          InitWindow_KeyBoard()
        Case UpdateEnabledCheckbox
          UpdateEnabled = GetGadgetState(UpdateEnabledCheckbox)
          If UpdateEnabled 
            url$ = InputRequester("Update URL", "The address to send statistics", UpdateUrl)
            If url$ <> ""
              UpdateUrl = url$
            EndIf
          EndIf
      EndSelect
  EndSelect
  ProcedureReturn #True
EndProcedure


Procedure FixSystray(hWnd, uMsg, WParam, LParam) 
  If uMsg = TB_Message
    AddSysTrayIcon(1, WindowID(Window_0), ImageID(0))
  EndIf
  
  ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure


Procedure KeyboardEvents(nCode,wParam, *lParam.KBDLLHOOKSTRUCT)
  If wParam  = #WM_KEYUP
    Keys + 1
    KeyMap(*lParam\vkCode) + 1
  EndIf 
  ProcedureReturn CallNextHookEx_(keyboardHook,nCode,wParam,lParam)   
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
  ProcedureReturn CallNextHookEx_(mouseHook,nCode,wParam,lParam)   
EndProcedure



InitNetwork()
LoadState()
InitWindow()

SetWindowCallback(@FixSystray())


CompilerIf #PB_Compiler_Debugger
  UpdateDisplay()
  HideWindow(0, #False)
CompilerEndIf

keyboardHook = SetWindowsHookEx_(#WH_KEYBOARD_LL, @KeyboardEvents(), GetModuleHandle_(0), 0)
mouseHook = SetWindowsHookEx_(#WH_MOUSE_LL, @MouseEvents(), GetModuleHandle_(0), 0)


While #True
  event = WaitWindowEvent()
  Select EventWindow()
    Case 0
      If Window_Events(event) = #False
        Break
      EndIf
    Case KeyBoardWindow
        KeyBoardWindow_Events(event)
  EndSelect
Wend



UnhookWindowsHookEx_(mouseHook)
UnhookWindowsHookEx_(keyboardHook)
SaveState()



DataSection
  Image:
    IncludeBinary "keyboard.ico"
EndDataSection
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 149
; FirstLine = 147
; Folding = --
; EnableUnicode
; EnableThread
; EnableXP
; EnableUser
; UseIcon = keyboard.ico
; Executable = ..\..\..\Apps\counter.exe
; CPU = 5
; DisableDebugger
; Compiler = PureBasic 5.31 (Windows - x64)
; EnablePurifier
; EnableBuildCount = 17