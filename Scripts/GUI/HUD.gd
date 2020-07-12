extends CanvasLayer

#var lives


func _ready():
    GlobalPlayer.connect("lives_set",self,"_on_lives_set")
    $DebugDisp/OS.text = "OS :" + OS.get_name()
    $DebugDisp/Engine.text = "Godot v :" + Engine.get_version_info()["string"]


func _process(_delta):
    $ScoreBox/HBoxContainer/VBox/Score.text = str(GlobalPlayer.score)
    $ScoreBox/HBoxContainer/VBoxContainer/Highscore.text = str(GlobalPlayer.highscore)
    $DebugDisp/FPS.text = "FPS :" + str(Engine.get_frames_per_second())


func _on_lives_set(lives):
    print("test")
    #lives = count
    if 0 <= lives and lives < 6 :
        $LivesBox/NumericLives.hide()
        $LivesBox/SpritesLives.show()
        for i in range(1,6):
            get_node("LivesBox/SpritesLives/HBoxContainer/TextureRect"+str(i)).visible  =  lives >= i
    else :
        $LivesBox/SpritesLives.hide()
        $LivesBox/NumericLives.show()
        $LivesBox/NumericLives/Score.text = str(lives)
