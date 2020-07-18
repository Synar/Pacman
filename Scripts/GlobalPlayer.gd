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


func _read_write_score(mode):
    var _highscore = 0
    var dir = Directory.new( )
    if !dir.dir_exists(highscore_dir):
        dir.make_dir(highscore_dir)
    var highscore_file = File.new()
    var err = highscore_file.open(highscore_path, mode)
    # If the file does not exist, create it
    if err == ERR_FILE_NOT_FOUND:
        err = highscore_file.open(highscore_path, File.WRITE_READ)
    if err != OK:
        return _highscore
    if mode == File.READ:
        _highscore = int(highscore_file.get_as_text())
    if mode == File.WRITE:
        highscore_file.store_string(str(score))
    highscore_file.close()
    return _highscore


func _ready():
    highscore = _read_write_score(File.READ)


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


var packed_scene = PackedScene.new()

func save_game():
    #packed_scene.pack(get_tree().get_current_scene())
    var scene_root = level
    _set_owner(scene_root, scene_root)
    packed_scene.pack(scene_root)
    ResourceSaver.save("res://my_scene.tscn", packed_scene)


func _set_owner(node, root): #credit to Justo Delgado
    if node != root:
        node.owner = root
    for child in node.get_children():
        _set_owner(child, root)


func load_game():
    #level = load("res://my_scene.tscn").instance()
    get_tree().change_scene("res://my_scene.tscn")
