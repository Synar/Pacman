extends Node

var pacmanScene = load("res://Scenes/Entities/pacman.tscn")
var fruitScene = load("res://Scenes/pickup/Fruit.tscn")
var ghostScene = load("res://Scenes/Entities/ghost.tscn")
var inkyScene = load("res://Scenes/Entities/inky_the_bashful.tscn")
var pinkyScene = load("res://Scenes/Entities/pinky_the_ambusher.tscn")
var blinkyScene = load("res://Scenes/Entities/blinky_who_shadows.tscn")
var clydeScene = load("res://Scenes/Entities/clyde_who_feigns_ignorance.tscn")

var munch1Sound = load("res://Assets/Sounds/Pac-Man/munch_1.wav")
var munch2Sound = load("res://Assets/Sounds/Pac-Man/munch_2.wav")
var eatGhostSound = load("res://Assets/Sounds/Pac-Man/eat_ghost.wav")
var eatFruitSound = load("res://Assets/Sounds/Pac-Man/eat_fruit.wav")
var death1Sound = load("res://Assets/Sounds/Pac-Man/death_1.wav")
var death2Sound = load("res://Assets/Sounds/Pac-Man/death_2.wav")
var frightSound = load("res://Assets/Sounds/Pac-Man/power_pellet.wav")
var deadGhostSound = load("res://Assets/Sounds/Pac-Man/retreating.wav")
var siren1Sound = load("res://Assets/Sounds/Pac-Man/siren_1.wav")
var siren2Sound = load("res://Assets/Sounds/Pac-Man/siren_2.wav")
var siren3Sound = load("res://Assets/Sounds/Pac-Man/siren_3.wav")
var siren4Sound = load("res://Assets/Sounds/Pac-Man/siren_4.wav")
var siren5Sound = load("res://Assets/Sounds/Pac-Man/siren_5.wav")

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

enum State {free, lockedin, leavinggh_1, leavinggh_2, dead1, dead2}

var inky
var blinky
var pinky
var clyde
var ghosts = []
var entities = []

var max_coins = 0
var coins_remaining = 0 # set to 240 in base levels on ready
var coins_eaten = 0

var elroy1_coins
var elroy2_coins

var fright_time
var blink_amount
var frightened_timer = -1

var fruit_timer = -1


func _ready():
    #Globals.e_controller = self
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
    max_coins = coins_remaining
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

    #var ghost = _spawn_ghost(ghostScene, ghost_spawn)
    #ghost.state = State.free

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

    dots_eaten_since_ghost_activated = {pinky:0, inky:0, clyde:0}
    ghosts_activation_thresholds = {pinky : 0, inky : 0 if level_prog > 1 else 30, clyde : 0 if level_prog > 2 else 50}
    if level_prog == 0 :
        ghosts_activation_thresholds[clyde] = 60


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
    Globals.score_increase(score_value)
    match pickup_type :
        pellet :
            frighten()
        coin :
            coins_remaining -= 1
            match coins_remaining:
                0 :
                    Globals.next_level()
                elroy1_coins :
                    print("elroy1_coins", coins_remaining)
                    blinky.elroy1 = true
                elroy2_coins :
                    print("elroy2_coins", coins_remaining)
                    blinky.elroy2 = true
            coins_eaten += 1
            if coins_eaten == 70 or coins_eaten == 170:
                call_deferred ("_spawn_fruits")
            dot_eaten_lib()
            if coins_eaten%2 == 1:
                $sound_controller.play_sfx(munch1Sound)
            else:
                $sound_controller.play_sfx(munch2Sound)
        fruit :
            Globals.fruit_collected([id])
            $sound_controller.play_sfx(eatFruitSound)


func frighten():
    for entity in entities:
        print ("entity ", entity)
        entity.frighten(fright_time)
    frightened_timer = fright_time


func _on_ghost_eaten():
    Globals.score_increase(100)
    $sound_controller.play_sfx(eatGhostSound)
    $pause_controller.gh_death_freeze(0.5)#(50)


func _on_pacman_eaten():
    #Globals.life_loss()
    Globals.Player._on_death()
    $sound_controller.play_sfx_queue([death1Sound,death2Sound,death2Sound])
    $pause_controller.pc_death_freeze(3)


func pc_respawn():
    Globals.life_loss()
    for entity in entities:
        entity.queue_free()
    global_counter_activated = true
    dots_eaten_since_death = 0
    call_deferred("_spawn_entities")


func _process(delta):
    process_input()
    choose_music()

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
onready var max_time_after_dot_eaten = 4 if level_prog <= 5 else 3
var dots_eaten_since_death = 0
var global_counter_activated = false
var ghost_activated = null
var dots_eaten_since_ghost_activated
var ghosts_activation_thresholds


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
                global_counter_activated = false
    else:
        ghost_activated = null
        for ghost in [pinky,inky,clyde]:
            if ghost.state == State.lockedin:
                ghost_activated = ghost
                break
        if ghost_activated != null:
            dots_eaten_since_ghost_activated[ghost_activated] += 1
            for ghost in [pinky,inky,clyde]:
                if dots_eaten_since_ghost_activated[ghost] >= ghosts_activation_thresholds[ghost]:
                    if ghost.state == State.lockedin:
                        ghost.liberate()


func liberate_trigger(delta):
    time_since_dot_eaten += delta
    if time_since_dot_eaten > max_time_after_dot_eaten:
        for ghost in [pinky,inky,clyde]:
            if ghost.state == State.lockedin:
                ghost.liberate()
                time_since_dot_eaten = 0
                break


func _on_clyde_liberated():
    if coins_remaining < elroy2_coins:
        blinky.elroy2 = true
    elif coins_remaining < elroy1_coins:
        blinky.elroy1 = true


func process_input():
    if Globals.dbg_settings.debug_mode and !Globals.menu_pause_on:

        if Input.is_action_just_pressed("fruit_spawn"):
            Globals.anticheat = true
            _spawn_fruits()

        if Input.is_action_just_pressed("kill_ghosts"):
            Globals.anticheat = true
            for ghost in ghosts:
                ghost.state = State.dead1
                ghost.emit_signal("ghost_eaten")

        if Input.is_action_just_pressed("suicide"):
            Globals.anticheat = true
            _on_pacman_eaten()

        if Input.is_action_just_pressed("next_level"):
            Globals.anticheat = true
            Globals.next_level()


func choose_music():
    var ghost_dead = false
    for ghost in ghosts:
        if ghost.state == State.dead1 or ghost.state == State.dead2:
            ghost_dead = true
            break
    if ghost_dead:
        $sound_controller.play_music_once(frightSound)
    elif frightened_timer != -1:
        $sound_controller.play_music_once(frightSound)
    elif coins_remaining < max_coins/10:
        $sound_controller.play_music_once(siren5Sound)
    elif coins_remaining < max_coins/5:
        $sound_controller.play_music_once(siren4Sound)
    elif coins_remaining < max_coins/3:
        $sound_controller.play_music_once(siren3Sound)
    elif coins_remaining < max_coins*0.6:
        $sound_controller.play_music_once(siren2Sound)
    else:
        $sound_controller.play_music_once(siren1Sound)
