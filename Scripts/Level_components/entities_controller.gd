extends Node
var score = 0


func _ready():
    GlobalPlayer.e_controller=self
    pass    
    var highscore_path = "res://SaveFiles/highscore.txt" #/SaveFiles
    var highscore_file = File.new()
        
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

    

#func _process(delta):
#    pass
