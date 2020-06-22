extends "res://Scripts/Entities/ghost.gd"



func chase_target():
    if position.distance_to(GlobalPlayer.Player.position)/16 < 8:
        return scatter_target
    return GlobalPlayer.Player.position
