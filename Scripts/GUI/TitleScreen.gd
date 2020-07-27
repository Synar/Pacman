extends CanvasLayer

var animationScene = load("res://Scenes/Animations/title_screen_animation.tscn")

func _ready():
    #OS.set_window_size(Vector2(640, 480))
    VisualServer.set_default_clear_color(000000)
    $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/quick_play.text =  \
                                        "  Continue" if Globals.settings.continue_not_new else "  Quick Play"
    #print("  Continue" if Globals.settings.continue_not_new else "  Quick Play")
    #print(Globals.settings.continue_not_new)
    randomize()
    yield(get_tree().create_timer(rand_range(0.2,0.5)), "timeout")
    generate_anim()


func generate_anim():
    var anim = animationScene.instance()
    add_child(anim)
    yield(get_tree().create_timer(rand_range(1,2.5)), "timeout")
    generate_anim()


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
