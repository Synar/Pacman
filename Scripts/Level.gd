extends Node2D

var tilemap
var virtual_map = {}
var tp_dict = {}

var pacmanScene = load("res://Scenes/entities/pacman.tscn")
var coinScene = load("res://Scenes/pickup/coin.tscn")

var tilemap_coord_to_name_dict = {[1,Vector2(0,0)]:"ground",[1,Vector2(1,0)]:"coin",[1,Vector2(2,0)]:"pacman_origin",
                            [1,Vector2(0,1)]:"wall",[1,Vector2(1,1)]:"teleport",[1,Vector2(2,1)]:"no_up",
                            [1,Vector2(0,2)]:"house_barrier",[1,Vector2(1,2)]:"pellet", [1,Vector2(2,2)]:"slow",
                            [1,Vector2(3,0)]:"ghost_origin",[1,Vector2(3,1)]:"red_placeholder", [1,Vector2(3,2)]:"cherry_origin"}
                            
func tilemap_coord_to_name(tile,coord):
    if [tile,coord] in tilemap_coord_to_name_dict:
        return tilemap_coord_to_name_dict[[tile,coord]]
    return str([tile,coord])

# Called when the node enters the scene tree for the first time.
func _ready():
    #OS.set_window_position(screen_size*0.5 - window_size*0.5)

    tilemap = get_node("TileMap")
    GlobalPlayer.levelTilemap = tilemap
    for pos in tilemap.get_used_cells_by_id(1):
        virtual_map[pos] = tilemap_coord_to_name(1,tilemap.get_cell_autotile_coord(pos.x, pos.y))
        var atlasPos = tilemap.get_cell_autotile_coord(pos.x, pos.y)
        if atlasPos == Vector2(2, 0):
            var pacman = pacmanScene.instance()
            add_child(pacman)
            pacman.speed = 50
            pacman.position = tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)
            tilemap.set_cell(pos.x, pos.y, 1, false, false, false, Vector2(0, 0))
            
    for pos in tilemap.get_used_cells_by_id(1):
        var atlasPos = tilemap.get_cell_autotile_coord(pos.x, pos.y)
        if tilemap_coord_to_name(1,atlasPos) == "coin":
            var coin = coinScene.instance()
            add_child(coin)
            coin.position = tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)
        if tilemap_coord_to_name(1,atlasPos) == "teleport":
            for tps in tp_dict:
                if (tps.x==pos.x or tps.y==pos.y) and tps!=pos:
                    tp_dict[pos]=tps
                    tp_dict[tps]=pos
            if not pos in tp_dict:
                tp_dict[pos]=pos
                    
        if not tilemap_coord_to_name(1,atlasPos) in ["ground","wall"] :
            tilemap.set_cell(pos.x, pos.y, 1, false, false, false, Vector2(0, 0))
    
    print(tp_dict)
    #print(virtual_map)
    

#func _process(delta):
#    pass
