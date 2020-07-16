extends CanvasLayer


func _ready():
    #OS.set_window_size(Vector2(640, 480))
    VisualServer.set_default_clear_color(000000)
    pass # Replace with function body.


func _input(event):
    if event.is_action_pressed("insert_coin"):
            GlobalPlayer.score_increase(-1000)
            get_tree().change_scene("res://Scenes/Level1.tscn")
    elif event is InputEventKey:
        if event.pressed:
            get_tree().change_scene("res://Scenes/GUI/TitleScreen.tscn")


#func _process(delta):
#    pass
