extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var loop_count = 0


func _process(delta):
    if !self.playing:
        if loop_count < 2:
            loop_count += 1
            self.play()
        else:
            $"..".emit_signal("animation_end")
