extends CanvasLayer


func _ready():
    #OS.set_window_size(Vector2(640, 480))
    VisualServer.set_default_clear_color(000000)
    pass


#func _process(delta):
#    pass


func _on_quick_play_pressed():
    GlobalPlayer.new_game()


func _on_continue_pressed():
    GlobalPlayer.load_game()


func _on_choose_mode_pressed():
    pass # Replace with function body.


func _on_settings_pressed():
    pass # Replace with function body.


func _on_exit_game_pressed():
    get_tree().quit()
