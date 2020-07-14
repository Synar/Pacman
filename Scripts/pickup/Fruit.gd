extends Pickup
class_name Fruit

var fruit = "cherries"


func set_attributes():
    score_value = {
        "cherries": 100,
        "strawberry": 300,
        "peach": 500,
        "apple": 700,
        "grapes": 1000,
        "galaxian": 2000,
        "bell": 3000,
        "key": 5000,
        }[fruit]
    pickup_type = Type.fruit
    id = fruit


func fruit_from_level(level_prog):
    if level_prog > 12 :
        return "key"
    return ["cherries", "strawberry", "peach", "peach", "apple", "apple",
              "grapes", "grapes", "galaxian", "galaxian", "bell", "bell"] [level_prog-1]


func _ready():
    $AnimatedSprite.play(fruit)
