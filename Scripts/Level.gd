extends Node2D

var tilemap
var virtual_map = {}

var pacmanScene = load("res://Scenes/entities/pacman.tscn")
var coinScene = load("res://Scenes/pickup/coin.tscn")

var tilemap_to_map_dict = {[1,Vector2(0,0)]:"ground",[1,Vector2(0,1)]:"coin",[1,Vector2(0,2)]:"pacman_origin",
                            [1,Vector2(1,0)]:"wall",[1,Vector2(1,1)]:"teleport",[1,Vector2(1,2)]:"no_up",
                            [1,Vector2(2,0)]:"house_barrier",[1,Vector2(2,1)]:"pellet", [1,Vector2(2,2)]:"slow",
                            [1,Vector2(0,3)]:"ghost_origin",[1,Vector2(1,3)]:"red_placeholder", [1,Vector2(2,3)]:"cherry_origin"}
                            
func tilemap_to_map(tile,coord):
    if [tile,coord] in tilemap_to_map_dict:
        return tilemap_to_map_dict[[tile,coord]]
    return str([tile,coord])

# Called when the node enters the scene tree for the first time.
func _ready():
    #OS.set_window_position(screen_size*0.5 - window_size*0.5)

    tilemap = get_node("TileMap")
    GlobalPlayer.levelTilemap = tilemap
    for pos in tilemap.get_used_cells_by_id(1):
        virtual_map[pos] = tilemap_to_map(1,tilemap.get_cell_autotile_coord(pos.x, pos.y))
        var atlasPos = tilemap.get_cell_autotile_coord(pos.x, pos.y)
        if atlasPos == Vector2(2, 0):
            var pacman = pacmanScene.instance()
            add_child(pacman)
            pacman.speed = 50
            pacman.position = tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)
            tilemap.set_cell(pos.x, pos.y, 1, false, false, false, Vector2(0, 0))
    for pos in tilemap.get_used_cells_by_id(1):
        var atlasPos = tilemap.get_cell_autotile_coord(pos.x, pos.y)
        if atlasPos == Vector2(1, 0): # dot
            var coin = coinScene.instance()
            add_child(coin)
            coin.position = tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)
            tilemap.set_cell(pos.x, pos.y, 1, false, false, false, Vector2(0, 0))
    
    #print(virtual_map)
    


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
