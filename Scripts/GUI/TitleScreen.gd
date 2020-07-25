extends CanvasLayer


func _ready():
    #OS.set_window_size(Vector2(640, 480))
    VisualServer.set_default_clear_color(000000)
    $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/quick_play.text =  \
                                        "  Continue" if Globals.settings.continue_not_new else "  Quick Play"
    print("  Continue" if Globals.settings.continue_not_new else "  Quick Play")

    print(Globals.settings.continue_not_new)
#func _process(delta):
#    pass


func _on_quick_play_pressed():
    if Globals.settings.continue_not_new:
        Globals.load_game()
    else:
        Globals.new_game()


func _on_credits_pressed():
    pass


func _on_choose_mode_pressed():
    pass # Replace with function body.


func _on_settings_pressed():
    pass # Replace with function body.


func _on_exit_game_pressed():
    get_tree().quit()
