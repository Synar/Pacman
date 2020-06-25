extends "res://Scripts/Entities/ghost.gd"

var elroy1 = false
var elroy2 = false

func _on_elroy_1():
    pass

func _ready():
    state = State.free


func target_tile():
    if elroy1 or mode == Mode.chase:
            target_pos = chase_target()
    elif mode == Mode.scatter:
            target_pos = scatter_target


func update_speed():
    #var new_speed = 0.4*GlobalPlayer.basespeed
    #if level
    #speed = new_speed
    if level_prog == 1:
        if get_tile_name(position) in ["slow","teleport","tp_exit"]:
            speed = 0.4*GlobalPlayer.basespeed
        elif mode == Mode.frightened:
            speed = 0.5*GlobalPlayer.basespeed
        elif elroy2:
            speed = 0.85*GlobalPlayer.basespeed
        elif elroy1:
            speed = 0.8*GlobalPlayer.basespeed
        else :
            speed = 0.75*GlobalPlayer.basespeed
    elif 4<level_prog:
        if get_tile_name(position) in ["slow","teleport","tp_exit"]:
            speed = 0.45*GlobalPlayer.basespeed
        elif mode == Mode.frightened:
            speed = 0.55*GlobalPlayer.basespeed
        elif elroy2:
            speed = 0.95*GlobalPlayer.basespeed
        elif elroy1:
            speed = 0.9*GlobalPlayer.basespeed
        else :
            speed = 0.85*GlobalPlayer.basespeed
    else :
        if get_tile_name(position) in ["slow","teleport","tp_exit"]:
            speed = 0.5*GlobalPlayer.basespeed
        elif mode == Mode.frightened:
            speed = 0.6*GlobalPlayer.basespeed
        elif elroy2:
            speed = 1.05*GlobalPlayer.basespeed
        elif elroy1:
            speed = 1.0*GlobalPlayer.basespeed
        else :
            speed = 0.95*GlobalPlayer.basespeed
