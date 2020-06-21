extends Node

var Player
var level
#var levelTilemap
var score
var lives = 3
var e_controller

# Called when the node enters the scene tree for the first time.
func _ready():
    var highscore_dir = "res://SaveFiles"
    var dir = Directory.new( )
    if !dir.dir_exists(highscore_dir):
        dir.make_dir("res://SaveFiles")
    var highscore_path = highscore_dir + "/highscore.txt"
    var highscore_file = File.new()
    if true: #not highscore_file.file_exists(highscore_path):
        print(highscore_path)
        highscore_file.open(highscore_path, File.WRITE)
        highscore_file.store_line(to_json("sd 23"))
        highscore_file.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
