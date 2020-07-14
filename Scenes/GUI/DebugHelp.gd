extends Control

onready var debug_mode_button = $CenterContainer/PanelContainer/VBoxContainer2/debug_mode/Control/CheckButton
onready var god_mode_button = $CenterContainer/PanelContainer/VBoxContainer2/god_mode/Control/CheckButton
onready var infinite_lives_button = $CenterContainer/PanelContainer/VBoxContainer2/infinite_lives/Control/CheckButton
onready var true_god_mode_button = $CenterContainer/PanelContainer/VBoxContainer2/true_god_mode/Control/CheckButton


func _ready():
    hide()
    debug_mode_button.connect("pressed", self, "switch", ["debug_mode"])
    god_mode_button.connect("pressed", self, "switch", ["god_mode"])
    infinite_lives_button.connect("pressed", self, "switch", ["infinite_lives"])
    true_god_mode_button.connect("pressed", self, "switch", ["true_god_mode"])
    GlobalPlayer.connect("modes_changed",self,"_on_modes_changed")


func _input(event):
    if !GlobalPlayer.menu_pause_on:
        if event.is_action_pressed("debug_help"):
            visible = !visible


func _on_modes_changed():
    debug_mode_button.pressed = GlobalPlayer.debug_mode
    god_mode_button.pressed = GlobalPlayer.god_mode
    infinite_lives_button.pressed = GlobalPlayer.infinite_lives
    true_god_mode_button.pressed = GlobalPlayer.true_god_mode


func switch(bool_var):
    GlobalPlayer.set(bool_var, !GlobalPlayer.get(bool_var))
