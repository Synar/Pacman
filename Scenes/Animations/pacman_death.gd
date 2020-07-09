extends AnimatedSprite
class_name Pacman_death

func _ready():
    frame = 0

func _process(delta):
    #print( "my pos is : ", position)
    if frame == 14:
        self.queue_free()
