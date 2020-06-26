extends CanvasLayer


func _ready():
    OS.set_window_size(Vector2(640, 480))
    VisualServer.set_default_clear_color(000000)
    pass


#func _process(delta):
#    pass


func _on_LinkButton_pressed():
    get_tree().change_scene("res://Scenes/Level1.tscn")


func _on_LinkButton2_pressed():
    pass
