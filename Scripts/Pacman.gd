extends KinematicBody2D 


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var pickup = get_node("/root/Node2D/Coin")
#GlobalPlayer.Player=self
#onready var player = get_node("/root/GlobalPlayer")
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    GlobalPlayer.Player=self
    #player.Player = self
    pass # Replace with function body.

#func _on_pickup_body_entered(body):
    #print("tiggered,b")
    #queue_free()

export(float) var speed = 0
var current_dir = Vector2(0, 0)
var wanted_dir = Vector2(0, 0)

func _on_pickup_body_entered(body):
    score+=1
    print("Score : ",score," !")
    #print(get_node("/root/Node2D/Coin").get_overlapping_bodies())
    pass

func try_dir(wanted_dir):
    return wanted_dir

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    if Input.is_action_pressed("move_left"):
        wanted_dir = Vector2(-1, 0)

    if Input.is_action_pressed("move_right"):
        wanted_dir = Vector2(1, 0)

    if Input.is_action_pressed("move_up"):
        wanted_dir = Vector2(0, -1)


    if Input.is_action_pressed("move_down"):
        wanted_dir = Vector2(0, 1)

    current_dir=try_dir(wanted_dir)
    rotation = current_dir.angle()
    position += current_dir * speed * delta
