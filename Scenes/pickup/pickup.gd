extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Pacman = get_node("/root/Node2D/Pacman")

# Called when the node enters the scene tree for the first time.
func _ready():
    
    self.connect("body_entered", self, "_on_pickup_body_entered")

#func _on_pickup_body_entered(body):
    #print("tiggered")
    #queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_pickup_body_entered(body):
    print("ahah-u")
    #print(get_overlapping_bodies())
    pass # Replace with function body.
