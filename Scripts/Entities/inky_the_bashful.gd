extends Ghost

var blinky


func _ready():
    respawn_tile = "inky"


func chase_target():  # should target before reaching next tile but whatever # add the up left bug?
    var tile_in_front_of_pacman = Level.adjust_pos(Globals.Player.position) + 2*16*Globals.Player.past_dir
    return 2*tile_in_front_of_pacman - blinky.position

