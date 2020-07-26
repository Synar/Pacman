extends Node

var paused = false

signal animation_end
# Called when the node enters the scene tree for the first time.
func _ready():
    #OS.set_window_size(Vector2(520, 610))
    #OS.set_window_position(screen_size*0.5 - window_size*0.5)
    VisualServer.set_default_clear_color(000000)


func _input(event):
    if event.is_action_pressed("pause"):
        paused = !paused
        get_tree().paused = !get_tree().paused
    if !paused and event.is_action_pressed("skip_animation"):
        emit_signal("animation_end")
