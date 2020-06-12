extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tilemap
var pacmanScene = load("res://Scenes/pacman.tscn")
var CoinScene = load("res://Scenes/pickup/Coin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    tilemap = get_node("TileMap")
    for pos in tilemap.get_used_cells_by_id(1):
        var atlasPos = tilemap.get_cell_autotile_coord(pos.x, pos.y)
        if atlasPos == Vector2(2, 0):
            var pacman = pacmanScene.instance()
            add_child(pacman)
            pacman.speed = 50
            pacman.position = tilemap.map_to_world(pos) + tilemap.position
            tilemap.set_cell(pos.x, pos.y, 1, false, false, false, Vector2(0, 0))
    for pos in tilemap.get_used_cells_by_id(1):
        var atlasPos = tilemap.get_cell_autotile_coord(pos.x, pos.y)
        if atlasPos == Vector2(1, 0): # dot
            var coin = CoinScene.instance()
            add_child(coin)
            coin.position = tilemap.map_to_world(pos) + tilemap.position
            tilemap.set_cell(pos.x, pos.y, 1, false, false, false, Vector2(0, 0))



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
