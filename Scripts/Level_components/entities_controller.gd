extends Node

var pacmanScene = load("res://Scenes/Entities/pacman.tscn")
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
var gh_2 = Vector2(0,0)
var gh_entrance = Vector2(0,0)
var god_mode = false

enum State {free, lockedin, leavinggh_1, leavinggh_2, dead}

var inky
var blinky
var pinky
var clyde
var ghosts = []
var entities = []

var coins_remaining = 0 # set to 240 in base levels on ready
var coins_eaten = 0

var elroy1_coins
var elroy2_coins

var fright_time
var blink_amount
var frightened_timer = -1

var fruit_timer = -1


func _ready():
    GlobalPlayer.e_controller = self
    randomize()


func _spawn_ghost(_ghostScene,_ghost_spawn,_scatter_target = false, _ghost_respawn = false):
    var ghost = _ghostScene.instance()
    add_child(ghost)
    ghost.position = _ghost_spawn
    ghost.connect("ghost_eaten", self, "_on_ghost_eaten", [])
    ghost.connect("pacman_eaten", self, "_on_pacman_eaten", [])
    ghost.respawn_point = _ghost_respawn if _ghost_respawn else _ghost_spawn
    if _scatter_target:
        ghost.scatter_target = _scatter_target
    ghosts.append(ghost)
    return ghost


func _on_map_loaded():
    fright_time = [6, 5, 4, 3, 2, 5, 2, 2, 1, 5, 2, 1, 1, 3, 1, 1, 0, 1][level_prog-1] if level_prog < 19 else 0
    blink_amount = 3 if fright_time==1 else 5

    elroy1_coins = [20, 30, 40, 40, 40, 50, 50, 50, 60, 60,
                        60, 80, 80, 80, 100, 100, 100, 100] [level_prog-1] if level_prog < 19 else 120
    elroy2_coins = [10, 15, 20, 20, 20, 25, 25, 25, 30, 30,
                        30, 40, 40, 40, 50, 50, 50, 50] [level_prog-1] if level_prog < 19 else 60

    _spawn_entities()

    print("coins_remaining", coins_remaining)


func _spawn_entities():
    var pacman = pacmanScene.instance()
    add_child(pacman)
    pacman.position = pacman_spawn #tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)

    ghosts = []

    var ghost = _spawn_ghost(ghostScene, ghost_spawn)
    ghost.state = State.free

    blinky = _spawn_ghost(blinkyScene, blinky_spawn, blinky_target, inky_spawn)

    inky = _spawn_ghost(inkyScene, inky_spawn, inky_target)
    inky.blinky = blinky

    clyde = _spawn_ghost(clydeScene, clyde_spawn, clyde_target)
    clyde.connect("clyde_liberated", self, "_on_clyde_liberated")

    pinky = _spawn_ghost(pinkyScene, pinky_spawn, pinky_target)

    entities = ghosts + [pacman]

    for ghost in ghosts:
        ghost.gh_1 = gh_1
        ghost.gh_2 = gh_2
        ghost.gh_entrance = gh_entrance
        #ghost.gh_entrance_front = blinky_spawn
        ghost.blink_amount = blink_amount
        match level_prog:
            1 : ghost.chase_scatter_times = [7, 20, 7, 20, 5, 20, 5, -1]
            2,3,4 : ghost.chase_scatter_times = [7, 20, 7, 20, 5, 1033, 1/60, -1]
            _ : ghost.chase_scatter_times = [5, 20, 5, 20, 5, 1037, 1/60, -1]

    for entity in entities:
        entity.level_prog = level_prog


func _spawn_fruits():
        for id in fruit_spawn.size():
            var fruit = fruitScene.instance()
            fruit.position = fruit_spawn[id]
            fruit.id = id
            fruit.fruit = fruit.fruit_from_level(level_prog)
            add_child(fruit)
        fruit_timer = rand_range(9,10)


enum {generic_pickup, pellet, fruit, coin}
func _on_pickup_body_entered(_body, score_value, pickup_type, id):
    GlobalPlayer.score_increase(score_value)
    match pickup_type :
        pellet :
            frighten()
        coin :
            coins_remaining -= 1
            match coins_remaining:
                0 :
                    GlobalPlayer.next_level()
                elroy1_coins :
                    blinky.elroy1 = true
                elroy2_coins :
                    blinky.elroy2 = true
            coins_eaten += 1
            if coins_eaten == 70 or coins_eaten == 170:
                call_deferred ("_spawn_fruits")
            dot_eaten_lib()


func frighten():
    for entity in entities:
        print ("entity ", entity)
        entity.frighten(fright_time)
    frightened_timer = fright_time


func _on_ghost_body_entered(_body):
    #globalcounter
    if frightened_timer == -1:
        if !god_mode :
            GlobalPlayer.lives -= 1
            GlobalPlayer.Player._on_death()
            $pause_controller.pc_death_freeze(3)
    else:
        GlobalPlayer.score_increase(100)


func _on_ghost_eaten():
    GlobalPlayer.score_increase(100)
    $pause_controller.gh_death_freeze(0.5)#(50)


func _on_pacman_eaten():
    if !god_mode :
        GlobalPlayer.life_loss()
        GlobalPlayer.Player._on_death()
        $pause_controller.pc_death_freeze(3)


func pc_respawn():
        for entity in entities:
            entity.queue_free()
        call_deferred("_spawn_entities")


func _process(delta):
    process_input()

    if fruit_timer != -1 :
        fruit_timer -= delta
        if fruit_timer < 0 :
            fruit_timer = -1
            for node in get_children():
                if(node is Fruit):
                    node.free()

    if frightened_timer != -1:
        frightened_timer -= delta
        if frightened_timer < 0 :
            for entity in entities:
                entity.calm()
            frightened_timer = -1

    liberate_trigger(delta)


var time_since_dot_eaten = 0
var dots_eaten_since_death = 0
var dots_eaten_since_ghost_activated = [0, 0, 0]
var global_counter_activated = false
var ghost_activated = 0
var ghosts_activation_thresholds = [0, 30, 60]


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


func liberate_trigger(delta):
    time_since_dot_eaten += delta
    if time_since_dot_eaten > 4:
        for ghost in [pinky,inky,clyde]:
            if ghost.state == State.lockedin:
                ghost.liberate()
                time_since_dot_eaten = 0
                break

    if ghost_activated != 3:
        if dots_eaten_since_ghost_activated[ghost_activated] == ghosts_activation_thresholds[ghost_activated]:
            ghost_activated += 1

    for i in range(3):
        if dots_eaten_since_ghost_activated[i] >= ghosts_activation_thresholds[i]:
            var ghost = [pinky,inky,clyde][i]
            if ghost.state == State.lockedin:
                ghost.liberate()


func _on_clyde_liberated():
    if coins_remaining > elroy2_coins:
        blinky.elroy2 = true
    elif coins_remaining > elroy1_coins:
        blinky.elroy1 = true


func process_input():
    if Input.is_action_just_pressed("god_mode"):
        god_mode = !god_mode
        GlobalPlayer.anticheat = true
