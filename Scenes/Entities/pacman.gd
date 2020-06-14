extends "res://Scripts/entity.gd"

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    test_id = 1
    GlobalPlayer.Player=self
    GlobalPlayer.score=0

func _on_pickup_body_entered(body):
    score+=1
    GlobalPlayer.score+=1
    print("Score : ",score," !")

func entity_rotate():
    rotation = past_dir.angle()

func pick_wanted_dir(delta):
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
