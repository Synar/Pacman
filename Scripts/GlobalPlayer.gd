extends Node

export var basespeed = 75
export var level_prog = 1
export var lives = 3

#var e_controller
var Player
var level
var anticheat = false

var fruits_eaten = []
var score = 0
var highscore
var highscore_dir = "res://SaveFiles"
var highscore_path = highscore_dir + "/highscore.txt"

var debug_mode = true setget set_debug_mode
var god_mode = false setget set_god_mode
var true_god_mode = false setget set_true_god_mode
var infinite_lives = false setget set_infinite_lives

signal lives_set
signal fruit_collected
signal modes_changed

var menu_pause_on = false
var sound_volume = 1


func _read_write_data(mode, path, data = 0):
    var dir = Directory.new( )
    if !dir.dir_exists(path.get_base_dir()):
        #dir.open(base directory for user, else it won't work after import)
        dir.make_dir_recursive(path.get_base_dir())
    var file = File.new()
    var err = file.open(path, mode)
    if err == ERR_FILE_NOT_FOUND:
        err = file.open(path, File.WRITE_READ)
        mode = File.WRITE
    if err != OK:
        print ("err :", err)
        return err
    if mode == File.READ:
        data = parse_json(file.get_as_text())
    if mode == File.WRITE:
        file.store_line(to_json(data))
    file.close()
    return data


func _read_write_score(mode):
    return _read_write_data(mode, highscore_path, score)


func _ready():
    highscore = _read_write_score(File.READ)
    var a = 1
    print("test reading :")
    print( _read_write_data(File.WRITE,highscore_dir + "/test.txt",{0:10,1:[{1: 32}, "er", ['1', 4]]}))
    print( _read_write_data(File.READ,highscore_dir + "/test.txt",1))
    print(a)


func _on_level_loaded():
    emit_signal("lives_set", lives)
    emit_signal("fruit_collected",fruits_eaten)
    emit_signal("modes_changed")


func next_level():
    level_prog += 1
    if level_prog == 2:
        get_tree().change_scene("res://Scenes/Animations/intermission1.tscn")
        yield(get_tree(),"idle_frame")
        yield(get_tree().get_root().get_child(1), "animation_end")
    #print("here :")
    #print(get_tree().get_root().get_child(1))
    #print(get_tree().get_root().get_child(1).filename)
    #print(": here")
    get_tree().change_scene("res://Scenes/Level1.tscn")


func score_increase(score_value):
    score += score_value
    if !anticheat and score > highscore:
        highscore = score
        _read_write_score(File.WRITE)


func life_loss(count=1):
    lives -= count
    if lives <= 0 and !infinite_lives:
        get_tree().change_scene("res://Scenes/GUI/GameOver.tscn")
    emit_signal("lives_set", lives)


func fruit_collected(fruits):
    fruits_eaten += fruits
    emit_signal("fruit_collected",fruits)


func set_debug_mode(value):
    debug_mode = value
    emit_signal("modes_changed")


func set_god_mode(value):
    god_mode = value
    emit_signal("modes_changed")


func set_infinite_lives(value):
    infinite_lives = value
    emit_signal("modes_changed")


func set_true_god_mode(value):
    true_god_mode = value
    emit_signal("modes_changed")


func quit_to_title():
    menu_pause_on = false
    get_tree().paused = false
    get_tree().change_scene("res://Scenes/GUI/TitleScreen.tscn")


func new_game():
    level_prog = 1
    lives = 3
    score = 0
    get_tree().change_scene("res://Scenes/Level1.tscn")



func save_game():
    save_node(level)


func save_node(node):
    if node.has_method("save_node"):
        node.call("save_node")
        return
    for child in node.get_children():
        save_node(child)
    #print(filter(get_script().get_script_property_list()))
    print(filter(get_property_list ()))


func filter(l):
    var r = []
    for d in l:
        r.append(d["name"])
    return r



func load_game():
    #level = load("res://my_scene.tscn").instance()
    get_tree().change_scene("res://my_scene.tscn")
