class_name Pickup
extends Node2D

var score_value = 3
var id = -1

enum Type {generic_pickup, pellet, fruit, coin}
var pickup_type = Type.generic_pickup


func set_attributes():
    pass


func _ready():
    set_attributes()
    z_index = 1
    self.connect("body_entered", self, "_on_pickup_body_entered")
    self.connect("body_entered", Globals.level.get_node("entities_controller"),
                 "_on_pickup_body_entered", [score_value, pickup_type, id])


func _on_pickup_body_entered(_body):
    queue_free()
