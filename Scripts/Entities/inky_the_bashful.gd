extends "res://Scripts/Entities/ghost.gd"
var blinky

func chase_target():  #should target before reaching next tile but whatever #add the up left bug?
    var tile_in_front_of_pacman = adjust_pos(GlobalPlayer.Player.position)+2*16*GlobalPlayer.Player.past_dir
    return 2*tile_in_front_of_pacman - blinky.position
