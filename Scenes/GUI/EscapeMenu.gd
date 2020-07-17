extends Control


onready var volume_slider = $CenterContainer/PanelContainer/VBoxContainer2/HSlider

var sound_volume = 0.5

func _ready():
    volume_slider.value = sound_volume
    hide()


func _input(event):
    if event.is_action_pressed("escape_menu"):
        visible = !visible


func _on_HSlider_value_changed(value):
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))
    sound_volume = value
    print(linear2db(value), "   ", value)


func _on_Quit_to_title_pressed():
    GlobalPlayer.quit_to_title()


func _on_Exit_game_pressed():
    get_tree().quit()

