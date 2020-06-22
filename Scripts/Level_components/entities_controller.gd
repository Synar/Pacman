extends Node
var score = 0
var pacmanScene = load("res://Scenes/Entities/pacman.tscn")
var coinScene = load("res://Scenes/pickup/coin.tscn")
var fruitScene = load("res://Scenes/pickup/Fruit.tscn")
var ghostScene = load("res://Scenes/Entities/ghost.tscn")
var inkyScene = load("res://Scenes/Entities/inky_the_bashful.tscn")
var pinkyScene = load("res://Scenes/Entities/pinky_the_ambusher.tscn")
var blinkyScene = load("res://Scenes/Entities/blinky_who_shadows.tscn")
var clydeScene = load("res://Scenes/Entities/clyde_who_feigns_ignorance.tscn")
var level_prog = 1

var pacman_spawn = Vector2(0,0)
var ghost_spawn = Vector2(0,0)
var gh_barrier = Vector2(0,0)
var fruit_spawn = []
var inky_spawn = Vector2(0,0)
var clyde_spawn = Vector2(0,0)
var blinky_spawn = Vector2(0,0)
var pinky_spawn = Vector2(0,0)

var inky
var blinky
var pinky
var clyde
var ghosts = []
var entities = []

var coin_count = 0 # set to 240 in base levels on ready
var coins_eaten = 0

var fright_time = 6

func _ready():
    GlobalPlayer.e_controller=self
    randomize()
    var highscore_path = "res://SaveFiles/highscore.txt" #/SaveFiles
    var highscore_file = File.new()

func _on_map_loaded():
    var pacman = pacmanScene.instance()
    add_child(pacman)
    pacman.position = pacman_spawn#tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)

    var ghost = ghostScene.instance()
    add_child(ghost)
    ghost.position = ghost_spawn
    ghosts.append(ghost)

    inky = inkyScene.instance()
    add_child(inky)
    inky.position = inky_spawn
    ghosts.append(inky)

    blinky = blinkyScene.instance()
    add_child(blinky)
    blinky.position = blinky_spawn
    ghosts.append(blinky)

    clyde = clydeScene.instance()
    add_child(clyde)
    clyde.position = clyde_spawn
    ghosts.append(clyde)

    pinky = pinkyScene.instance()
    add_child(pinky)
    pinky.position = pinky_spawn
    ghosts.append(pinky)

    entities = ghosts + [pacman]

    for entity in entities:
        entity.level_prog = level_prog

    _spawn_fruits()

    print("coin_count", coin_count)

func _spawn_fruits():
    for fruit_spawn_pos in fruit_spawn:
        var fruit = fruitScene.instance()
        fruit.position = fruit_spawn_pos
        fruit.fruit = fruit.fruit_from_level(level_prog)
        add_child(fruit)

enum {generic_pickup, pellet, fruit, coin}
func _on_pickup_body_entered(_body, score_value, pickup_type):
    score+=score_value
    GlobalPlayer.score+=score_value
    score_save()
    match pickup_type :
        pellet :
            frighten()
        coin :
            coin_count-=1
            coins_eaten+=1
        fruit :
            fruit_timer = rand_range(9,10)

var frightened_timer = -1
func frighten():
    for entity in entities:
        print ("entity ", entity)
        entity.frighten()
    frightened_timer = fright_time

func score_save():
    #print("Score : ",score," !")
    var highscore_path = "res://SaveFiles/highscore.txt" #/SaveFiles
    var highscore_file = File.new()
    if true: #not highscore_file.file_exists(highscore_path):
        #print(highscore_path)
        highscore_file.open(highscore_path, File.WRITE)
        #highscore_file.store_line(to_json("sd 23"))
        highscore_file.close()


func _on_ghost_body_entered(_body):
    print('loooooooooooooooooooooooooooooooooooooooooooool')


var timer = 0
var fruit_timer = -1

func _process(delta):
    if fruit_timer != -1 :
        fruit_timer -= delta
        if fruit_timer < 0 :
            _spawn_fruits()
            fruit_timer = -1

    if frightened_timer!=-1:
        frightened_timer -= delta
        if frightened_timer < 0 :
            for entity in entities:
                entity.calm()
            frightened_timer = -1
    if timer != -1:
        timer += delta
    if timer > 3:
        timer = -1
        inky.liberate()

