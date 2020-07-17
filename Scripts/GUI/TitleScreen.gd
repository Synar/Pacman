extends CanvasLayer


func _ready():
    #OS.set_window_size(Vector2(640, 480))
    VisualServer.set_default_clear_color(000000)
    pass


#func _process(delta):
#    pass


func _on_LinkButton_pressed():
    GlobalPlayer.new_game()


func _on_LinkButton2_pressed():
    pass
