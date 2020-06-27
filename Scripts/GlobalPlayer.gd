extends Node

export var basespeed = 75
export var level_prog = 1
export var lives = 3

var e_controller
var Player
var level

var score = 0
var highscore
var highscore_path = "res://SaveFiles/highscore.txt"

func next_level():
    level_prog += 1
    get_tree().change_scene("res://Scenes/Level1.tscn")


func _ready():
    var highscore_dir = "res://SaveFiles"
    var dir = Directory.new( )
    if !dir.dir_exists(highscore_dir):
        dir.make_dir("res://SaveFiles")
    var highscore_path = highscore_dir + "/highscore.txt"
    var highscore_file = File.new()
    highscore_file.open(highscore_path, File.READ)
    highscore = int(highscore_file.get_as_text())
    highscore_file.close()


func score_increase(score_value):
    score += score_value
    if score > highscore:
        highscore = score
        var highscore_file = File.new()
        var err = highscore_file.open(highscore_path, File.WRITE)
        if err != OK:
            return
        highscore_file.store_string(str(score))
        highscore_file.close()
