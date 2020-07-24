extends Node


class game_var_class:
    func _init():
        lives = Globals.test
    var fruits_eaten = []
    var score = 0
    var level_prog = 1
    var lives = Globals.test + 10000

# Called when the node enters the scene tree for the first time.
func _ready():
    for i in 4:
        print (i)
    for i in range(4):
        print (i)
    print(Color8(250,185,176,255))
    print(Color8(33,33,255,255))
    print(Color8(193,11,37,255))
    print(Color8(218,222,242,255))

    #print(Ghost.scatter_target)
    if Vector2(0,0):
        print (Vector2(0,0))
    if Vector2(1,0):
        print (Vector2(1,0))
    print(Vector2(1,2)*Vector2(10,100))

    Globals.test = 100
    var game_var = game_var_class.new()
    Globals.test = 200
    print("game_var.lives", game_var.lives)
    game_var = game_var_class.new()
    print("game_var.lives", game_var.lives)

#func _process(delta):
#    pass
