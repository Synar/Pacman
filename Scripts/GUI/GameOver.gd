extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    OS.set_window_size(Vector2(640, 480))
    VisualServer.set_default_clear_color(000000)
    pass # Replace with function body.

func _input(event):
    if event is InputEventKey:
        if event.pressed:
            get_tree().change_scene("res://Scenes/GUI/TitleScreen.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
