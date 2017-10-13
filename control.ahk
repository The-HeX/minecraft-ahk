#IfWinActive Minecraft
#InstallKeybdHook
#InstallMouseHook
#SingleInstance, force

global x1,y1,z1
global x2,y2,z2
global radius := 3
global InBuildMode:=False

gosub reset

F2::
    InBuildMode:=!InBuildMode
    if (InBuildMode) {
        Display("Build mode is on.")
    } else {
        Display("Build mode is off.")
    }
return 


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
    if(InBuildMode){
            radius+=1
            Display( "radius updated to " . radius )
    }
    else{
        send =
    }
    return

-::
    if(InBuildMode){
        radius-=1
        Display( "radius updated to " . radius )
    }else{
        send -
    }
    return

::drain::
    if(InBuildMode){
            BlockInput, On
            send / 
            sleep 250 
            send fill ~-%radius% ~-2 ~-%radius% ~%radius% ~2 ~%radius% air 0 replace water 0{enter}
            sleep 200
            Display( "water drained at a radius of " . radius )
            BlockInput Off
    }else{
        send drain
    }
    return 
return 
g::
    if(InBuildMode){
            BlockInput, On
            send / fill ~-%radius% ~-1 ~-%radius% ~%radius% ~-1 ~%radius% grass 0 replace dirt{enter}
            sleep 100
            send / fill ~-%radius% ~-1 ~-%radius% ~%radius% ~-1 ~%radius% grass 0 replace stone{enter}
            sleep 200
            Display( "replaced grass to a radius of " . radius )
            BlockInput Off
    }else{
        send g
    }
    return 

+c::
    if(InBuildMode){
            BlockInput On
            send / fill ~-%radius% ~ ~-%radius% ~%radius% ~%radius% ~%radius% air{enter}
            sleep 200
            Display( "cleared blocks to a radius of " . radius )
            BlockInput Off
    }

    return 

+v::
    if(InBuildMode){
            BlockInput On
            Loop %radius% {
                y := A_Index - 1
                dist:=radius + y
                ;this needs to be turned into a circle instead of a square, the end shape is still unnatural
                send / fill ~-%dist% ~%y% ~-%dist% ~%dist% ~%y% ~%dist% air{enter}
                sleep 200
            }
            Display( "cleared blocks to a radius of " . radius )
            BlockInput Off
    }
return 

::/create::
     send create{space}
     input userInput , V, {enter}
          
     args := StrSplit(userInput , A_Space , A_Space)
     ;Display(args.MaxIndex())
     if ( args[1]="circle"){
         ;circle radius [x y z]  [height]
         ;2 circle radius  ;  [x y z= ~ ~ ~]  [height=1]
         if(args.MaxIndex()=2){
             Display("create circle radius")
         }
         ;3 circle radius height
         else if(args.MaxIndex()=3){
             Display("create circle radius height")
         }
         ;5 circle radius x y z ; [height=1]
         else if(args.MaxIndex()=5){
             Display("create circle radius x y z")
         }
         ;6 circle radius x y z  height         
         else if(args.MaxIndex()=6){
             Display("create circle radius x y z  height")
         }
     }
     else if ( args[1]="ring"){
        ;circle x y z radius [height] [thickness]

     }
     else if(args[1]="pyramid"){
        Display("cone is not implemented")
     }
     else if(args[1]="walls"){
        ;walls width height block 
        if(args.MaxIndex()=4){
            BlockInput On
            w:=args[2]
            h:=args[3]
            b:=args[4]        
            Walls(w,w,h,b,"~","~","~")
            BlockInput Off
        }
        ;walls width length height bock 
        else if(args.MaxIndex()=5){
            BlockInput On
            w:=args[2]
            l:=args[3]
            h:=args[4]
            b:=args[5]
            Walls(w,l,h,b,"~","~","~")
            BlockInput Off
        }
        ;walls x y z width length height block
        else if(args.MaxIndex()=8){
            BlockInput On
            x:=args[2]
            y:=args[3]
            z:=args[4]
            w:=args[5]
            l:=args[6]
            h:=args[7]
            b:=args[8]
            Walls(w,l,h,b,x,y,z)
            BlockInput Off            
        }
        
        
        return
     }
     else if(args[1]="sphere"){
        Display("cone is not implemented")
     }
     else if(args[1]="box"){
        Display("cone is not implemented")
     }
     else if(args[1]="cone"){
        Display("cone is not implemented")
     }

 return

Walls(w,l,h,b,cx,cy,cz){
        x:=Round(w/2)
        z:=Round(l/2)
        y:=Round(h-1)
        
        Fill(cx+(x*-1), cy+0,cz+(z*-1),cx+x     , cy+y,cz+(z*-1), b)
        Fill(cx+(x*-1), cy+0,cz+z     ,cx+x     , cy+y,cz+z     , b)
        Fill(cx+(x*-1), cy+0,cz+(z*-1),cx+(x*-1), cy+y,cz+z     , b)
        Fill(cx+x     , cy+0,cz+(z*-1),cx+x     , cy+y,cz+z     , b)
        Display("walls created")    
}

Fill(x1,y1,z1,x2,y2,z2,block){
    sleep 100
    send /
    sleep 250
    send fill ~%x1% ~%y1% ~%z1% ~%x2% ~%y2% ~%z2% %block%{enter}
    sleep 500
    return
}

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

Display(message){
    BlockInput On
    send /
    sleep 100
    send tell @s %message%{enter}
    sleep 100
    BlockInput Off
}