extends AudioStreamPlayer


var loop_count = 0


func _process(_delta):
    if !self.playing:
        if loop_count < 2:
            loop_count += 1
            self.play()
        else:
            $"..".emit_signal("animation_end")
