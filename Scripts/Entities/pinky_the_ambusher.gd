extends "res://Scripts/Entities/ghost.gd"

func chase_target():  #should target before reaching next tile but whatever #add the up left bug?
    return adjust_pos(GlobalPlayer.Player.position)+4*16*GlobalPlayer.Player.past_dir
