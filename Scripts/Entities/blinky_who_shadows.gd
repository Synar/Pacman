extends Ghost

var elroy1 = false
var elroy2 = false


func _on_elroy_1():
    pass


func _on_death():
    elroy1 = false
    elroy2 = false


func _ready():
    respawn_tile = "inky"
    state = State.free


func target_tile():
    if state == State.free :
            if elroy1 or mode == Mode.chase:
                target_pos = chase_target()
            elif mode == Mode.scatter:
                target_pos = scatter_target
    else :
        .target_tile()


func update_speed():
    var level_multiplier = .0 if level_prog == 1 else 0.05 if level_prog < 4 else 0.1
    if Level.get_tile_name(position) in ["slow", "teleport", "tp_exit"]:
        speed = (0.4 + level_multiplier)*GlobalPlayer.basespeed
    elif mode == Mode.frightened:
        speed = (0.5 + level_multiplier)*GlobalPlayer.basespeed
    elif elroy2:
        speed = (0.85 + 2*level_multiplier)*GlobalPlayer.basespeed
    elif elroy1:
        speed = (0.8 + 2*level_multiplier)*GlobalPlayer.basespeed
    else :
        speed = (0.75 + 2*level_multiplier)*GlobalPlayer.basespeed
