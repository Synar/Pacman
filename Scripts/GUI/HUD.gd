extends CanvasLayer

var lives


func _ready():
    GlobalPlayer.connect("lives_set",self,"_on_lives_set")


func _process(_delta):
    $ScoreBox/HBoxContainer/VBox/Score.text = str(GlobalPlayer.score)
    $ScoreBox/HBoxContainer/VBoxContainer/Highscore.text = str(GlobalPlayer.highscore)


func _on_lives_set(count):
    print("test")
    lives = count
    if 0 <= lives and lives < 6 :
        $LivesBox/NumericLives.hide()
        $LivesBox/SpritesLives.show()
    else :
        $LivesBox/SpritesLives.hide()
        $LivesBox/NumericLives.show()
        $LivesBox/NumericLives/Score.text = str(lives)
