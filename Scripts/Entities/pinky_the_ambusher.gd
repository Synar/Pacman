extends Ghost


func _ready():
    respawn_tile = "pinky"


func chase_target():  # should target before reaching next tile but whatever # add the up left bug?
    return Level.adjust_pos(Globals.player.position)+ 4*16*Globals.player.past_dir
