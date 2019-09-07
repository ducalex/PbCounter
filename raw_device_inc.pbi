;Info: http://msdn2.microsoft.com/en-us/library/ms645536.aspx

;////////////raw input///////////////////////////

  #RID_INPUT              = $10000003
  #RIDEV_NOLEGACY         = $00000030
  #RIM_TYPEMOUSE          = 0
  #RIM_TYPEKEYBOARD       = 1
  #RIM_TYPEHID            = 2
  #MOUSE_MOVE_RELATIVE    = 0
  #MOUSE_MOVE_ABSOLUTE    = 1
  #RID_HEADER             = $10000005
  #RIDEV_INPUTSINK        = $00000100
  #HID_USAGE_PAGE_GENERIC = $00000001
  #RIDEV_REMOVE           = $00000001
  #WM_INPUT               = $000000FF
  #RIDEV_EXCLUDE          = $00000010
  #RIDEV_PAGEONLY         = $00000020
  #RIDEV_CAPTUREMOUSE     = $00000200
  #RIDEV_NOHOTKEYS        = $00000200
  #RIDEV_APPKEYS          = $00000400
  #RIDI_PREPARSEDDATA     = $20000005
  #RIDI_DEVICENAME        = $20000007 ;return value is character length not byte size
  #RIDI_DEVICEINFO        = $2000000b
  #MOUSE_VIRTUAL_DESKTOP  = $02
  #MOUSE_ATTRIBUTES_CHANGED = $04
 
;/////////////////Mouse//////////////////////////
 
  #RI_MOUSE_LEFT_BUTTON_DOWN   = $0001  ;Left Button changed To down.
  #RI_MOUSE_LEFT_BUTTON_UP     = $0002  ;Left Button changed To up.
  #RI_MOUSE_RIGHT_BUTTON_DOWN  = $0004  ;Right Button changed To down.
  #RI_MOUSE_RIGHT_BUTTON_UP    =$0008   ;Right Button changed To up.
  #RI_MOUSE_MIDDLE_BUTTON_DOWN =$0010   ;Middle Button changed To down.
  #RI_MOUSE_MIDDLE_BUTTON_UP   =$0020   ;Middle Button changed To up.
 
  #RI_MOUSE_BUTTON_1_DOWN      = #RI_MOUSE_LEFT_BUTTON_DOWN
  #RI_MOUSE_BUTTON_1_UP        = #RI_MOUSE_LEFT_BUTTON_UP
  #RI_MOUSE_BUTTON_2_DOWN      = #RI_MOUSE_RIGHT_BUTTON_DOWN
  #RI_MOUSE_BUTTON_2_UP        = #RI_MOUSE_RIGHT_BUTTON_UP
  #RI_MOUSE_BUTTON_3_DOWN      = #RI_MOUSE_MIDDLE_BUTTON_DOWN
  #RI_MOUSE_BUTTON_3_UP        = #RI_MOUSE_MIDDLE_BUTTON_UP
 
  #RI_MOUSE_BUTTON_4_DOWN      = $0040
  #RI_MOUSE_BUTTON_4_UP        = $0080
  #RI_MOUSE_BUTTON_5_DOWN      = $0100
  #RI_MOUSE_BUTTON_5_UP        = $0200
 
  #RI_MOUSE_WHEEL              = $0400
 
;/////////////keyboard//////////////////////////
 
  #RI_KEY_MAKE                 = 0
  #RI_KEY_BREAK                = 1
  #RI_KEY_E0                   = 2
  #RI_KEY_E1                   = 4
  #RI_KEY_TERMSRV_SET_LED      = 8
  #RI_KEY_TERMSRV_SHADOW       = $10
 
;///////////////////////////////////////////////

;////////All of the Raw Input structures///////

Structure RAWINPUTDEVICE
    usUsagePage.w
    usUsage.w
    dwFlags.l
    hwndTarget.l
EndStructure

Structure RAWINPUTDEVICELIST
    hDevice.l
    dwType.l
EndStructure

Structure RAWINPUTHEADER
    dwType.l
    dwSize.l
    hDevice.l
    wParam.l
EndStructure

Structure RID_DEVICE_INFO_HID
    dwVendorId.l
    dwProductId.l
    dwVersionNumber.l
    usUsagePage.w
    usUsage.w
EndStructure

Structure RID_DEVICE_INFO_KEYBOARD
    dwType.l
    dwSubType.l
    dwKeyboardMode.l
    dwNumberOfFunctionKeys.l
    dwNumberOfIndicators.l
    dwNumberOfKeysTotal.l
EndStructure

Structure RID_DEVICE_INFO_MOUSE
    dwId.l
    dwNumberOfButtons.l
    dwSampleRate.l
    fHasHorizontalWheel.b
EndStructure

Structure USBUTTON
    usButtonFlags.w
    usButtonData.w
EndStructure
 
Structure RAWMOUSE
    usFlags.w
    StructureUnion
      ulButtons.l
      usButton.USBUTTON
    EndStructureUnion
    ulRawButtons.l
    lLastX.l
    lLastY.l
    ulExtraInformation.l
EndStructure

Structure RAWKEYBOARD
    MakeCode.w
    Flags.w
    Reserved.w
    VKey.w
    Message.l
    ExtraInformation.l
EndStructure

Structure RAWHID
    dwSizeHid.l
    dwCount.l
    bRawData.b
EndStructure

Structure RAWINPUT
    header.RAWINPUTHEADER
    StructureUnion
       mouse.RAWMOUSE
       keyboard.RAWKEYBOARD
       hid.RAWHID
    EndStructureUnion
EndStructure
; IDE Options = PureBasic 5.00 (Windows - x86)
; CursorPosition = 145
; FirstLine = 98
; EnableXP
; CPU = 5