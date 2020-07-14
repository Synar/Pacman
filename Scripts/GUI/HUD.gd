extends CanvasLayer

#var lives
var fruitSpriteScene = load("res://Scenes/pickup/FruitSprite.tscn")


func _ready():
    GlobalPlayer.connect("lives_set",self,"_on_lives_set")
    GlobalPlayer.connect("fruit_collected",self,"_on_fruit_collected")
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

func _on_fruit_collected(fruits):
    for fruit in fruits:
        var center = CenterContainer.new()
        center.rect_min_size.x = 25
        var control = Control.new()
        center.add_child(control)
        var fruitSprite = fruitSpriteScene.instance()
        fruitSprite.scale = Vector2(1.5,1.5)
        fruitSprite.play(fruit)
        control.add_child(fruitSprite)
        $FruitCollected/Control/HBoxContainer.add_child(center)
        $FruitCollected/Control/HBoxContainer.move_child(center, 0)
        print(fruit)
