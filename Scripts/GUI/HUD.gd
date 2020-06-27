extends CanvasLayer


func _ready():
    pass


func _process(_delta):
    $ScoreBox/HBoxContainer/HBoxContainer2/Score.text = str(GlobalPlayer.score)
    $ScoreBox/HBoxContainer/VBoxContainer/Highscore.text = str(GlobalPlayer.highscore)
    $LivesBox/HBoxContainer/Score.text = str(GlobalPlayer.lives)

