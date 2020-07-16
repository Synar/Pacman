extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var loop_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if !self.playing:
        if loop_count < 2:
            loop_count += 1
            self.play()
        else:
            $"..".emit_signal("animation_end")
