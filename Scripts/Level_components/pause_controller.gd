extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

var freeze_timer = -1

func _process(delta):
    if freeze_timer != -1 :
        freeze_timer -= delta
        if freeze_timer <= 0 :
            freeze_timer = -1
            get_tree().paused = false
