extends Ghost


func chase_target():  # should target before reaching next tile but whatever # add the up left bug?
    return Level.adjust_pos(GlobalPlayer.Player.position)+ 4*16*GlobalPlayer.Player.past_dir
