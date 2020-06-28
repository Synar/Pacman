extends Ghost


func chase_target():
    if position.distance_to(GlobalPlayer.Player.position) < 8*16:
        return scatter_target
    return GlobalPlayer.Player.position


signal clyde_liberated


func liberate():
    .liberate()
    emit_signal("clyde_liberated")
