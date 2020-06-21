extends "res://Scripts/pickup/pickup.gd"

var fruit="cherries"

func set_attributes():
    score_value = {"cherries":100,"strawberry":300,"peach":500,"grapes":700,"galaxian":1000,"bell":3000,"key":5000}[fruit]
    pickup_type = Type.fruit

func fruit_from_level(level_prog):
    if level_prog>5 :
        return "key"
    return ["peach","cherries","cherries","strawberry","strawberry"][level_prog-1]

func _ready():
    $AnimatedSprite.play(fruit)
