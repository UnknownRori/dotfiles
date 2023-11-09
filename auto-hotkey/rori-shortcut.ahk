#Requires AutoHotkey v2.0

;#HotIf WinActive("Plex")
;This is the shortcut key for ALT+CTRL+A
!^a::
{
    WinSetStyle "^0xC00000", "A" ;Used for the caption  
    WinSetStyle "^0x40000", "A" ;Used for the sizebox
    WinSetStyle "^0x800000", "A" ;Used for the border
}

; This shortcut for ALT+CTRL+L
; To switch virtual desktop to the right
!^l::
{
    Send "^#{Right}"
}

; This shortcut for ALT+CTRL+H
; To switch virtual desktop to the left
!^h::
{
    Send "^#{Left}"
}