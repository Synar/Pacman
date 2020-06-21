extends Node
var score = 0
var pacmanScene = load("res://Scenes/Entities/pacman.tscn")
var coinScene = load("res://Scenes/pickup/coin.tscn")
var fruitScene = load("res://Scenes/pickup/Fruit.tscn")
var ghostScene = load("res://Scenes/Entities/ghost.tscn")

var pacman_spawn = Vector2(0,0)
var ghost_spawn = Vector2(0,0)
var gh_barrier = Vector2(0,0)
var fruit_spawn = []
var level_prog = 1

var inky_spawn = Vector2(0,0)
var clyde_spawn = Vector2(0,0)
var blinky_spawn = Vector2(0,0)
var pinky_spawn = Vector2(0,0)

var inky
var ghosts = []

func _ready():
    GlobalPlayer.e_controller=self
    pass
    var highscore_path = "res://SaveFiles/highscore.txt" #/SaveFiles
    var highscore_file = File.new()

func _on_map_loaded():
    var pacman = pacmanScene.instance()
    add_child(pacman)
    pacman.speed = 50
    pacman.position = pacman_spawn#tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)

    var ghost = ghostScene.instance()
    add_child(ghost)
    ghost.position = ghost_spawn#tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)
    #ghosts.append(ghost)

    inky = ghostScene.instance()
    add_child(inky)
    inky.position = inky_spawn#tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)
    ghosts.append(inky)

    var blinky = ghostScene.instance()
    add_child(blinky)
    blinky.position = inky_spawn#tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)

    for fruit_spawn_pos in fruit_spawn:
        var fruit = fruitScene.instance()
        fruit.position = fruit_spawn_pos
        fruit.fruit = fruit.fruit_from_level(level_prog)
        add_child(fruit)

func _on_pickup_body_entered(_body, score_value, pellet):
    score+=score_value
    GlobalPlayer.score+=score_value
    print("Score : ",score," !")
    var highscore_path = "res://SaveFiles/highscore.txt" #/SaveFiles
    var highscore_file = File.new()
    if true: #not highscore_file.file_exists(highscore_path):
        print(highscore_path)
        highscore_file.open(highscore_path, File.WRITE)
        #highscore_file.store_line(to_json("sd 23"))
        highscore_file.close()

    if pellet :
        print(ghosts)
        for ghost in ghosts:
            print ("ghost ", ghost)
            ghost.frighten()


var timer = 0

func _process(delta):
    if timer != -1:
        timer += delta
    if timer > 3:
        timer = -1
        inky.liberate()

