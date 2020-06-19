extends "res://Scripts/Entities/entity.gd"

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    test_id = 1
    z_index = 2
    GlobalPlayer.Player=self
    GlobalPlayer.score=0

func _on_pickup_body_entered(_body):
    score+=1
    GlobalPlayer.score+=1
    print("Score : ",score," !")

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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
