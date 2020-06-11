extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

export(float) var speed = 0
var current_dir = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    if Input.is_action_pressed("move_left"):
        current_dir = Vector2(-1, 0)

    if Input.is_action_pressed("move_right"):
        current_dir = Vector2(1, 0)

    if Input.is_action_pressed("move_up"):
        current_dir = Vector2(0, -1)


    if Input.is_action_pressed("move_down"):
        current_dir = Vector2(0, 1)

    position += current_dir * speed * delta
