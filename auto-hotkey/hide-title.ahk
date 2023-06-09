#Requires AutoHotkey v2.0

;#HotIf WinActive("Plex")
;This is the shortcut key for ALT+SHIFT+A
+!a::
{
    WinSetStyle "^0xC00000", "A" ;Used for the caption  
    WinSetStyle "^0x40000", "A" ;Used for the sizebox
    WinSetStyle "^0x800000", "A" ;Used for the border
}