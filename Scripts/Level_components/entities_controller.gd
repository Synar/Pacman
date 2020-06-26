extends Node

var pacmanScene = load("res://Scenes/Entities/pacman.tscn")
var coinScene = load("res://Scenes/pickup/coin.tscn")
var fruitScene = load("res://Scenes/pickup/Fruit.tscn")
var ghostScene = load("res://Scenes/Entities/ghost.tscn")
var inkyScene = load("res://Scenes/Entities/inky_the_bashful.tscn")
var pinkyScene = load("res://Scenes/Entities/pinky_the_ambusher.tscn")
var blinkyScene = load("res://Scenes/Entities/blinky_who_shadows.tscn")
var clydeScene = load("res://Scenes/Entities/clyde_who_feigns_ignorance.tscn")

var level_prog

var pacman_spawn = Vector2(0,0)
var ghost_spawn = Vector2(0,0)
var gh_barrier = Vector2(0,0)
var fruit_spawn = []
var inky_spawn = Vector2(0,0)
var clyde_spawn = Vector2(0,0)
var blinky_spawn = Vector2(0,0)
var pinky_spawn = Vector2(0,0)
var inky_target = Vector2(0,0)
var clyde_target = Vector2(0,0)
var blinky_target = Vector2(0,0)
var pinky_target = Vector2(0,0)
var gh_1 = Vector2(0,0)
var gh_entrance = Vector2(0,0)

var highscore_path = "res://SaveFiles/highscore.txt"
enum State {free, lockedin, leavinggh_1, leavinggh_2, dead}

var inky
var blinky
var pinky
var clyde
var ghosts = []
var entities = []

var coins_remaining = 0 # set to 240 in base levels on ready
var coins_eaten = 0

var fright_time = 6

func _ready():
    GlobalPlayer.e_controller=self
    level_prog = GlobalPlayer.level_prog
    randomize()

func _on_map_loaded():
    var pacman = pacmanScene.instance()
    add_child(pacman)
    pacman.position = pacman_spawn#tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)

    var ghost = ghostScene.instance()
    add_child(ghost)
    ghost.position = ghost_spawn
    ghost.state = State.free
    ghosts.append(ghost)

    blinky = blinkyScene.instance()
    add_child(blinky)
    blinky.position = blinky_spawn
    blinky.scatter_target = blinky_target
    ghosts.append(blinky)

    inky = inkyScene.instance()
    add_child(inky)
    inky.position = inky_spawn
    inky.blinky = blinky
    inky.scatter_target = inky_target
    ghosts.append(inky)

    clyde = clydeScene.instance()
    add_child(clyde)
    clyde.position = clyde_spawn
    clyde.scatter_target = clyde_target
    ghosts.append(clyde)

    pinky = pinkyScene.instance()
    add_child(pinky)
    pinky.position = pinky_spawn
    pinky.scatter_target = pinky_target
    ghosts.append(pinky)

    entities = ghosts + [pacman]

    for ghost in ghosts:
        ghost.gh_1 = gh_1
        ghost.gh_entrance = gh_entrance

    for entity in entities:
        entity.level_prog = level_prog

    for id in range(fruit_spawn.size()):
        _spawn_fruit(id)
        fruit_timer.append(-1)

    print("coins_remaining", coins_remaining)

func _spawn_fruit(id):
        var fruit = fruitScene.instance()
        fruit.position = fruit_spawn[id]
        fruit.id = id
        fruit.fruit = fruit.fruit_from_level(level_prog)
        add_child(fruit)

enum {generic_pickup, pellet, fruit, coin}
func _on_pickup_body_entered(_body, score_value, pickup_type, id):
    GlobalPlayer.score+=score_value
    score_save()
    match pickup_type :
        pellet :
            frighten()
        coin :
            coins_remaining-=1
            if coins_remaining == 0:
                GlobalPlayer.next_level()
            coins_eaten+=1
            dot_eaten_lib()
        fruit :
            fruit_timer[id] = rand_range(9,10)



var frightened_timer = -1
func frighten():
    for entity in entities:
        print ("entity ", entity)
        entity.frighten()
    frightened_timer = fright_time

func score_save():
    if GlobalPlayer.score > GlobalPlayer.highscore:
        GlobalPlayer.highscore = GlobalPlayer.score
        var highscore_file = File.new()
        var err = highscore_file.open(highscore_path, File.WRITE)
        if err != OK:
            return
        highscore_file.store_string(str(GlobalPlayer.score))
        highscore_file.close()

func _on_ghost_body_entered(_body):
    print('loooooooooooooooooooooooooooooooooooooooooooool')
    #global_counter_activated

var timer = 0
var fruit_timer = []



func _process(delta):
    for id in range(fruit_spawn.size()):
        if fruit_timer[id] != -1 :
            fruit_timer[id] -= delta
            if fruit_timer[id] < 0 :
                _spawn_fruit(id)
                fruit_timer[id] = -1

    if frightened_timer!=-1:
        frightened_timer -= delta
        if frightened_timer < 0 :
            for entity in entities:
                entity.calm()
            frightened_timer = -1

    liberate_trigger(delta)

var time_since_dot_eaten = 0
var dots_eaten_since_death = 0
var dots_eaten_since_ghost_activated = [0,0,0]
var global_counter_activated = false
var ghost_activated = 0
var ghosts_activation_thresholds = [0,30,60]

func dot_eaten_lib():
    time_since_dot_eaten = 0
    if global_counter_activated:
        dots_eaten_since_death += 1
        if dots_eaten_since_death == 7:
            pinky.liberate()
        if dots_eaten_since_death == 17:
            inky.liberate()
        if dots_eaten_since_death == 32:
            if clyde.state == State.lockedin:
                ghost_activated = 0
            clyde.liberate()
    else:
        if ghost_activated != 3:
            dots_eaten_since_ghost_activated[ghost_activated] += 1
            if dots_eaten_since_ghost_activated[ghost_activated] == ghosts_activation_thresholds[ghost_activated]:
                ghost_activated += 1


func liberate_trigger(delta):
    time_since_dot_eaten += delta
    if time_since_dot_eaten > 4:
        for ghost in [pinky,inky,clyde]:
            if ghost.state == State.lockedin:
                ghost.liberate()
                time_since_dot_eaten = 0
                break
    for i in range(3):
        if dots_eaten_since_ghost_activated[i] >= ghosts_activation_thresholds[i]:
            var ghost = [pinky,inky,clyde][i]
            if ghost.state == State.lockedin:
                ghost.liberate()

