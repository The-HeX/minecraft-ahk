#IfWinActive Minecraft
#InstallKeybdHook
#InstallMouseHook
#SingleInstance, force

global x1,y1,z1
global x2,y2,z2
global radius := 3

gosub reset

^z::
    gosub reset
    return 

reset:
    global point1 := [0,0,0]
    global point2 := [0,0,0]
return

::/pos1::
    point1:=GetCoordinates()
return

::/pos2::
    point2:=GetCoordinates()
return

::/s circle::

return 

GetCoordinates()
{    
    send {esc}
    sleep 100
    send !#{PrintScreen}
    sleep 750
    RunWait, parse.exe "results.txt", Min
    sleep 250
    FileRead, result, results.txt
    Out("Identified position " . result )
    send {enter}
    sleep 100
    send /tell @s %result% {enter}
    r:= StrSplit(result," ")

}

=::
 radius+=1
 send /tell @s radius updated to %radius%{enter}
return

-::
 radius-=1
 send /tell @s radius updated to %radius%{enter}
return 

g::
    send / fill ~-%radius% ~ ~-%radius% ~%radius% ~%radius% ~%radius% air{enter}
    sleep 100
    send / fill ~-%radius% ~-1 ~-%radius% ~%radius% ~-1 ~%radius% grass{enter}
return 

c::
    send / fill ~-%radius% ~ ~-%radius% ~%radius% ~%radius% ~%radius% air{enter}
return 

:?:/clone::
    x1:=point1[1]+0
    y1:=point1[2]+0
    z1:=point1[3]+0
    x2:=point2[1]+0
    y2:=point2[2]+0
    z2:=point2[3]+0
    
    
    send {esc}
    sleep 100
    send /
    sleep 100
    Send, clone %x1% %y1% %z1% %x2% %y2% %z2% ~ ~ ~{space}
Return

Out(message){
    outputdebug mc . %message%
}
return


sendkey(key){
    if(IfWinActive "Minecraft"){
        out("sending key " . key)
        send %key%
        sleep 100
    }else{
        out("cannot send " . key)
    }
}

