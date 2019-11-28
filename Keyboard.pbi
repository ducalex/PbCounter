Global KeyBoardWindow = -1
Global FontID = FontID(LoadFont(#PB_Any, "Courrier", 8))

Procedure.s GetKeyName(keyCode.l)
	Protected buffer.s = RSet("", 128, " ")
	Select keyCode
		Case #VK_CANCEL, #VK_NUMLOCK, #VK_PRIOR, #VK_NEXT, #VK_END, #VK_HOME, #VK_INSERT, #VK_DELETE,#VK_LEFT, #VK_RIGHT, #VK_UP, #VK_DOWN,#VK_LWIN, #VK_RWIN, #VK_APPS, #VK_RCONTROL, #VK_RMENU
			Extended.l = 1
		Default
			Extended.l = 0
	EndSelect
	GetKeyNameText_((MapVirtualKey_(keyCode, 0) << 16) | (Extended << 24), @Buffer, 128)
	
	ProcedureReturn buffer
EndProcedure

	
Procedure GetColourTemp(min, max, actual)
	midVal = (max-min) /2
	B = 0
	If actual >= mid
		R = 255
		G = Round(255 * ((max - actual) / (max - mid)), 0)
		B = G
	Else
		G = 255
		R = Round(255 * ((actual - min) / (mid - min)), 0)
		B = G
	EndIf
	ProcedureReturn RGB(R, G, B)
EndProcedure


Procedure ButtonColorGadget(num, x, y, w, h, text$, fcolor = #Black,bcolor = #White, flags = 0)
	CreateImage(num + 10000, w, h)
	If StartDrawing(ImageOutput(num + 10000))
		DrawingFont(FontID) : Box(0, 0, w, h, bcolor)
		DrawText(w/2-TextWidth(text$)/2, h/2-TextHeight(text$)/2, text$, fcolor, bcolor)
		StopDrawing()
	EndIf
	ProcedureReturn ButtonImageGadget(num, x, y, w, h, ImageID(num + 10000), flags)
EndProcedure


Procedure KeyboardButtonGadget(num,x,y,w,h,text$)
	Protected min.l, max.l
	
	For i = 1 To 254
		If KeyMap(i) > max
			max = KeyMap(i)
		ElseIf min > KeyMap(i)
			min = KeyMap(i)
		EndIf
	Next

	ProcedureReturn ButtonColorGadget(num,x,y,w,h,text$, #Black, GetColourTemp(min, max, KeyMap(num)))
EndProcedure


Procedure InitWindow_KeyBoard()
	If IsWindow(KeyBoardWindow)
		ProcedureReturn SetActiveWindow(KeyBoardWindow)
	EndIf

	KeyBoardWindow = OpenWindow(#PB_Any, 0, 0, 580, 210, "Keyboard Heat Map", #PB_Window_SystemMenu)
	KeyboardButtonGadget(#VK_ESCAPE, 10, 10, 30, 30, "Esc")
	KeyboardButtonGadget(#VK_F1, 60, 10, 30, 30, "F1")
	KeyboardButtonGadget(#VK_F2, 90, 10, 30, 30, "F2")
	KeyboardButtonGadget(#VK_F3, 120, 10, 30, 30, "F3")
	KeyboardButtonGadget(#VK_F4, 150, 10, 30, 30, "F4")
	KeyboardButtonGadget(#VK_F5, 200, 10, 30, 30, "F5")
	KeyboardButtonGadget(#VK_F6, 230, 10, 30, 30, "F6")
	KeyboardButtonGadget(#VK_F7, 260, 10, 30, 30, "F7")
	KeyboardButtonGadget(#VK_F8, 290, 10, 30, 30, "F8")
	KeyboardButtonGadget(#VK_F9, 340, 10, 30, 30, "F9")
	KeyboardButtonGadget(#VK_F10, 370, 10, 30, 30, "F10")
	KeyboardButtonGadget(#VK_F11, 400, 10, 30, 30, "F11")
	KeyboardButtonGadget(#VK_F12, 430, 10, 30, 30, "F12")
	KeyboardButtonGadget(#VK_OEM_3, 10, 50, 30, 30, "`")
	KeyboardButtonGadget(#VK_1, 40, 50, 30, 30, "1")
	KeyboardButtonGadget(#VK_2, 70, 50, 30, 30, "2")
	KeyboardButtonGadget(#VK_3, 100, 50, 30, 30, "3")
	KeyboardButtonGadget(#VK_4, 130, 50, 30, 30, "4")
	KeyboardButtonGadget(#VK_5, 160, 50, 30, 30, "5")
	KeyboardButtonGadget(#VK_6, 190, 50, 30, 30, "6")
	KeyboardButtonGadget(#VK_7, 220, 50, 30, 30, "7")
	KeyboardButtonGadget(#VK_8, 250, 50, 30, 30, "8")
	KeyboardButtonGadget(#VK_9, 280, 50, 30, 30, "9")
	KeyboardButtonGadget(#VK_0, 310, 50, 30, 30, "0")
	KeyboardButtonGadget(#VK_OEM_MINUS, 340, 50, 30, 30, "-")
	KeyboardButtonGadget(#VK_OEM_PLUS, 370, 50, 30, 30, "=")
	KeyboardButtonGadget(#VK_BACK, 400, 50, 60, 30, "Backspace")
	KeyboardButtonGadget(#VK_TAB, 10, 80, 40, 30, "Tab")
	KeyboardButtonGadget(#VK_Q, 50, 80, 30, 30, "Q")
	KeyboardButtonGadget(#VK_W, 80, 80, 30, 30, "W")
	KeyboardButtonGadget(#VK_E, 110, 80, 30, 30, "E")
	KeyboardButtonGadget(#VK_R, 140, 80, 30, 30, "R")
	KeyboardButtonGadget(#VK_T, 170, 80, 30, 30, "T")
	KeyboardButtonGadget(#VK_Y, 200, 80, 30, 30, "Y")
	KeyboardButtonGadget(#VK_U, 230, 80, 30, 30, "U")
	KeyboardButtonGadget(#VK_I, 260, 80, 30, 30, "I")
	KeyboardButtonGadget(#VK_O, 290, 80, 30, 30, "O")
	KeyboardButtonGadget(#VK_P, 320, 80, 30, 30, "P")
	KeyboardButtonGadget(#VK_OEM_4, 350, 80, 30, 30, "[")
	KeyboardButtonGadget(#VK_OEM_6, 380, 80, 30, 30, "]")
	KeyboardButtonGadget(#VK_CAPITAL, 10, 110, 50, 30, "CAPS")
	KeyboardButtonGadget(#VK_OEM_5, 410, 80, 50, 30, "\")
	KeyboardButtonGadget(#VK_A, 60, 110, 30, 30, "A")
	KeyboardButtonGadget(#VK_S, 90, 110, 30, 30, "S")
	KeyboardButtonGadget(#VK_D, 120, 110, 30, 30, "D")
	KeyboardButtonGadget(#VK_F, 150, 110, 30, 30, "F")
	KeyboardButtonGadget(#VK_G, 180, 110, 30, 30, "G")
	KeyboardButtonGadget(#VK_H, 210, 110, 30, 30, "H")
	KeyboardButtonGadget(#VK_J, 240, 110, 30, 30, "J")
	KeyboardButtonGadget(#VK_K, 270, 110, 30, 30, "K")
	KeyboardButtonGadget(#VK_L, 300, 110, 30, 30, "L")
	KeyboardButtonGadget(#VK_OEM_1, 330, 110, 30, 30, ";")
	KeyboardButtonGadget(#VK_OEM_7, 360, 110, 30, 30, "'")
	KeyboardButtonGadget(#VK_RETURN, 390, 110, 70, 30, "ENTER")
	KeyboardButtonGadget(#VK_LSHIFT, 10, 140, 60, 30, "SHIFT")
	KeyboardButtonGadget(#VK_Z, 70, 140, 30, 30, "Z")
	KeyboardButtonGadget(#VK_X, 100, 140, 30, 30, "X")
	KeyboardButtonGadget(#VK_C, 130, 140, 30, 30, "C")
	KeyboardButtonGadget(#VK_V, 160, 140, 30, 30, "V")
	KeyboardButtonGadget(#VK_B, 190, 140, 30, 30, "B")
	KeyboardButtonGadget(#VK_N, 220, 140, 30, 30, "N")
	KeyboardButtonGadget(#VK_M, 250, 140, 30, 30, "M")
	KeyboardButtonGadget(#VK_OEM_COMMA, 280, 140, 30, 30, ",")
	KeyboardButtonGadget(#VK_OEM_PERIOD, 310, 140, 30, 30, ".")
	KeyboardButtonGadget(#VK_OEM_2, 340, 140, 30, 30, "/")
	KeyboardButtonGadget(#VK_RSHIFT, 370, 140, 90, 30, "SHIFT")
	KeyboardButtonGadget(#VK_LCONTROL, 10, 170, 40, 30, "CTRL")
	KeyboardButtonGadget(#VK_LWIN, 50, 170, 40, 30, "WIN")
	KeyboardButtonGadget(#VK_LMENU, 90, 170, 40, 30, "ALT")
	KeyboardButtonGadget(#VK_SPACE, 130, 170, 210, 30, "SPACE")
	KeyboardButtonGadget(#VK_RMENU, 340, 170, 40, 30, "ALT")
	KeyboardButtonGadget(#VK_RWIN, 380, 170, 40, 30, "WIN")
	KeyboardButtonGadget(#VK_RCONTROL, 420, 170, 40, 30, "CTRL")
	KeyboardButtonGadget(#VK_INSERT, 480, 50, 30, 30, "Ins")
	KeyboardButtonGadget(#VK_HOME, 510, 50, 30, 30, "Hm")
	KeyboardButtonGadget(#VK_PRIOR, 540, 50, 30, 30, "PgU")
	KeyboardButtonGadget(#VK_NEXT, 540, 80, 30, 30, "PgD")
	KeyboardButtonGadget(#VK_END, 510, 80, 30, 30, "End")
	KeyboardButtonGadget(#VK_DELETE, 480, 80, 30, 30, "Del")
	KeyboardButtonGadget(#VK_UP , 510, 140, 30, 30, "↑")
	KeyboardButtonGadget(#VK_LEFT, 480, 170, 30, 30, "←")
	KeyboardButtonGadget(#VK_DOWN, 510, 170, 30, 30, "↓")
	KeyboardButtonGadget(#VK_RIGHT, 540, 170, 30, 30, "→")
EndProcedure


Procedure KeyBoardWindowEvents(event)
	Select event
		Case #PB_Event_CloseWindow
			CloseWindow(KeyBoardWindow)
		Case #PB_Event_Gadget			
			MessageRequester(GetKeyName(EventGadget()), Str(KeyMap(EventGadget())))
	EndSelect
EndProcedure

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 150
; FirstLine = 129
; Folding = --
; EnableXP
; UseMainFile = counter.pb
; Executable = counter.exe
; CPU = 5