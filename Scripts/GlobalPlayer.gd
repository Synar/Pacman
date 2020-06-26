extends Node

var Player
var level
var score := 0
var highscore
var lives := 3
var e_controller
export var basespeed := 75
var level_prog := 1


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


#func _process(delta):
#    pass
