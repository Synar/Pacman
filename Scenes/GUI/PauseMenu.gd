extends Control

func _ready():
    hide()

func _process(_delta):
    if !Globals.menu_pause_on:
        if Input.is_action_just_pressed("pause"):
            visible = !visible
