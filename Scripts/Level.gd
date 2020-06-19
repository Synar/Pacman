extends Node2D

var tilemap
var virtual_map = {}
var tp_dict = {}
var tp_exit_list = []
var grid_pos = 0

var pacmanScene = load("res://Scenes/Entities/pacman.tscn")
var coinScene = load("res://Scenes/pickup/coin.tscn")
var fruitScene = load("res://Scenes/pickup/Fruit.tscn")
var darkTileScene = load("res://Scenes/Level_components/dark_tile.tscn")


func get_tilemaps():
    var L=[]
    for node in get_children():
        if node is TileMap:
            L.append(node)
    return L

func pos_to_pos_on_grid(pos):
    return tilemap.world_to_map(pos)

# Called when the node enters the scene tree for the first time.
func _ready():
    OS.set_window_size(Vector2(520, 610))
    VisualServer.set_default_clear_color(000000)
    #OS.set_window_position(screen_size*0.5 - window_size*0.5)
    print(get_tilemaps())
    var tilemaps=get_tilemaps()
    print("mais")
    tilemap = get_node("Background")
    grid_pos = tilemap.position
    GlobalPlayer.level = self
    print("si")
    print(($"Background"))
    for tilemap in get_tilemaps():#[$"Background"]:#
        read_tilemap(tilemap)

func read_tilemap(tilemap):
    var ts = tilemap.get_tileset()
    for pos in tilemap.get_used_cells():
            var tile = ts.tile_get_name(tilemap.get_cell(pos.x, pos.y))
            if tilemap!=get_node("Background"):
                print(tilemap," ",pos," ",tile)
            if true : #else :
                virtual_map[pos] = tile
            if tile=="pacman":
                print("nice")
                var pacman = pacmanScene.instance()
                add_child(pacman)
                pacman.speed = 50
                pacman.position = tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)
            
            if tile=="invisible_wall":
                virtual_map[pos] = "wall"
                var tp = darkTileScene.instance()
                add_child(tp)
                tp.position = tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)

            if tile=="tp_exit":
                var tp = darkTileScene.instance()
                add_child(tp)
                tp.position = tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)
                tp_exit_list.append(pos)

            if tile=="fruit":
                var fruit = fruitScene.instance()
                fruit.position = tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)
                fruit.fruit = "bell"
                print(fruit.z_index)
                add_child(fruit)
                print(fruit.z_index,fruit.fruit,fruit.position)

    for pos in tilemap.get_used_cells():
            var tile = ts.tile_get_name(tilemap.get_cell(pos.x, pos.y))
            #print(virtual_map[pos])
            if tile=="coin":
                var coin = coinScene.instance()
                add_child(coin)
                coin.position = tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)

            if tile=="teleport":
                var tp = darkTileScene.instance()
                add_child(tp)
                tp.position = tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)
                for tps in tp_exit_list:
                    if (tps.x==pos.x or tps.y==pos.y) and tps.distance_to(pos)>2:
                        tp_dict[pos]=tps
                if not pos in tp_dict:
                    tp_dict[pos]=pos

            if not tile in ["ground","wall"] :  
                tilemap.set_cell(pos.x, pos.y, 1, false, false, false, Vector2(0, 0))


    print(tp_dict)
    #print(virtual_map)


#func _process(delta):
#    pass
