class_name Pacman
extends Entity

var ghosts_frightened = false


func _ready():
    test_id = 1
    z_index = 2
    GlobalPlayer.Player = self


func entity_rotate():
    if past_dir in vect_to_dir:
        $AnimatedSprite.play(vect_to_dir[past_dir])
        rotation = Vector2(1,0).angle()
    else :
        $AnimatedSprite.play("right")
        rotation = past_dir.angle()
        print("WTF")


func pick_wanted_dir(_delta):
    if Input.is_action_pressed("move_left"):
        wanted_dir = Vector2(-1, 0)

    if Input.is_action_pressed("move_right"):
        wanted_dir = Vector2(1, 0)

    if Input.is_action_pressed("move_up"):
        wanted_dir = Vector2(0, -1)

    if Input.is_action_pressed("move_down"):
        wanted_dir = Vector2(0, 1)


func update_speed():
    if level_prog == 1:
        if ghosts_frightened:
            speed = 0.9*GlobalPlayer.basespeed
        else:
            speed = 0.8*GlobalPlayer.basespeed

    elif 4 < level_prog and level_prog < 21:
        if ghosts_frightened:
            speed = 0.95*GlobalPlayer.basespeed
        else:
            speed = 0.9*GlobalPlayer.basespeed
    else:
        speed = GlobalPlayer.basespeed


func frighten():
    ghosts_frightened = true


func calm():
    ghosts_frightened = false

#func _process(delta):
