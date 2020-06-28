extends Node

export var basespeed = 75
export var level_prog = 1
export var lives = 3

var e_controller
var Player
var level

var score = 0
var highscore
var highscore_dir = "res://SaveFiles"
var highscore_path = highscore_dir + "/highscore.txt"


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


func next_level():
    level_prog += 1
    get_tree().change_scene("res://Scenes/Level1.tscn")


func score_increase(score_value):
    score += score_value
    if score > highscore:
        highscore = score
        _read_write_score(File.WRITE)
