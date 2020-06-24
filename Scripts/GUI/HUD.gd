extends CanvasLayer




# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    $ScoreBox/HBoxContainer/HBoxContainer2/Score.text = str(GlobalPlayer.score)
    $ScoreBox/HBoxContainer/VBoxContainer/Highscore.text = str(GlobalPlayer.highscore)
    $LivesBox/HBoxContainer/Score.text = str(GlobalPlayer.lives)
    pass
