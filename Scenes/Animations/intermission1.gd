extends CanvasLayer


signal animation_end
# Called when the node enters the scene tree for the first time.
func _ready():
    #OS.set_window_size(Vector2(520, 610))
    #OS.set_window_position(screen_size*0.5 - window_size*0.5)
    VisualServer.set_default_clear_color(000000)


func _input(event):
    if !Globals.menu_pause_on:
        if event.is_action_pressed("pause"):
            get_tree().paused = !get_tree().paused
