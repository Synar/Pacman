extends CanvasLayer




# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    $ScoreBox/HBoxContainer/Score.text = str(GlobalPlayer.score)
    pass