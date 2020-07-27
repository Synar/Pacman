extends CanvasLayer


func _ready():
    #OS.set_window_size(Vector2(640, 480))
    VisualServer.set_default_clear_color(000000)
    pass # Replace with function body.


func _input(event):
    if event.is_action_pressed("insert_coin"):
            Globals.score_increase(-1000)
            get_tree().change_scene("res://Scenes/Level1.tscn")
    elif event is InputEventKey:
        if event.pressed:
            Globals.settings.continue_not_new = false
            Globals.quit_to_title()

