Control.ahk
==============================================================================================
Navigation
    mouse scroll | up/down

Selection
    `           |   assing current hot key to selection. Builds must be assigned a hotkey for auto training to occur.
    tab         |   loop through hotkey selection
    shift+tab   |   reverse loop
    
Build
    F1          |   build scv and Marine
    F9          |   cycle through building (with scv selected)

Training - Loop through hotkey to train unit
    a           |   SCV
    s   m       |   Marine
    d   t       |   Tank    
    f   h       |   wraitH
    z           |   mediC
    x   g       |   Golath
    c   o       |   Observer
    v   b       |   Battle cruiser
    g           |   Ghost
    +           |   start automatic training; every x seconds
    -           |   stop automatic execution; every x seconds
    
Auto Build - display items being auto build and countdown to next 
                |   scv - every X secs execute s

Attack
ctrl + LM       |   Set Move/Attack point
shift + LM      |   Set Rally locations for all buildings
alt + LM        |   
    Q           |   
    W           |   Move All
    E           |   Attack All


Observe.ahk
================================================================================================
    Identify currently selection
    Dump pixels in selection 
    Identify locttion on mini map
    Identify cords of hotkey
    Identify cords of zoom