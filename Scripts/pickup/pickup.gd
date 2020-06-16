extends Node2D

var score_value = 3
var pellet = false

func set_attributes():
    pass

func _ready():
    set_attributes()
    z_index = 1
    self.connect("body_entered", self, "_on_pickup_body_entered")
    self.connect("body_entered", GlobalPlayer.e_controller, "_on_pickup_body_entered", [score_value, pellet])



func _on_pickup_body_entered(_body):
    queue_free()
