extends Node2D

var tilemap
var virtual_map = {}
var off_by_half_map = {}
var tp_dict = {}
var tp_exit_list = []
var grid_pos = 0

export var level_prog = 1

var pacmanScene = load("res://Scenes/Entities/pacman.tscn")
var coinScene = load("res://Scenes/pickup/coin.tscn")
var fruitScene = load("res://Scenes/pickup/Fruit.tscn")
var darkTileScene = load("res://Scenes/Level_components/dark_tile.tscn")
var entitiesControllerScene = load("res://Scenes/Level_components/entities_controller.tscn")

onready var main_tilemap = $"Background"
var entities_controller
#onready var entities_controller = $"entities_controller"
#signal map_loaded

func get_tilemaps():
    var L=[]
    for node in get_children():
        if node is TileMap:
            L.append(node)
    return L


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

    entities_controller = entitiesControllerScene.instance()
    entities_controller.level_prog = level_prog
    add_child(entities_controller)

    for tilemap in get_tilemaps():#[$"Background"]:#
        read_tilemap(tilemap,entities_controller)

    entities_controller._on_map_loaded()



func pos_to_pos_on_grid(pos):
    return tilemap.world_to_map(pos - tilemap.position)

func pos_on_grid_to_center_pos(pos, tilemap = main_tilemap):
    return tilemap.map_to_world(pos) + tilemap.position + Vector2(8, 8)

func add_black_foreground(pos, tilemap = main_tilemap):
    var tp = darkTileScene.instance()
    add_child(tp)
    tp.position = pos_on_grid_to_center_pos(pos,tilemap)

func read_tilemap(tilemap,entities_controller):
    var ts = tilemap.get_tileset()
    for pos in tilemap.get_used_cells():
            var tile = ts.tile_get_name(tilemap.get_cell(pos.x, pos.y))
            if tilemap!=get_node("Background"):
                print(tilemap," ",pos," ",tile)
            if tile in ["ground","wall","slow","no_up"] :
                virtual_map[pos] = tile
            if tile == "gh_barrier" :
                entities_controller.gh_barrier = pos_on_grid_to_center_pos(pos,tilemap)
            if tile=="pacman":
                print("nice")
                entities_controller.pacman_spawn = pos_on_grid_to_center_pos(pos,tilemap)

            if tile=="ghostspawn":
                entities_controller.ghost_spawn = pos_on_grid_to_center_pos(pos,tilemap)

            if tile=="inky":
                entities_controller.inky_spawn = pos_on_grid_to_center_pos(pos,tilemap)

            if tile=="blinky":
                entities_controller.blinky_spawn = pos_on_grid_to_center_pos(pos,tilemap)

            if tile=="clyde":
                entities_controller.clyde_spawn = pos_on_grid_to_center_pos(pos,tilemap)

            if tile=="pinky":
                entities_controller.pinky_spawn = pos_on_grid_to_center_pos(pos,tilemap)

            if tile=="fruit":
                entities_controller.fruit_spawn.append(pos_on_grid_to_center_pos(pos,tilemap))

            if tile=="invisible_wall":
                virtual_map[pos] = "wall"
                add_black_foreground(pos,tilemap)

            if tile=="tp_exit":
                tp_exit_list.append(pos)
                add_black_foreground(pos,tilemap)

            if tile=="coin":
                var coin = coinScene.instance()
                add_child(coin)
                coin.position = pos_on_grid_to_center_pos(pos,tilemap)

    for pos in tilemap.get_used_cells():
            var tile = ts.tile_get_name(tilemap.get_cell(pos.x, pos.y))
            #print(virtual_map[pos])

            if tile=="teleport":
                for tps in tp_exit_list:
                    if (tps.x==pos.x or tps.y==pos.y) and tps.distance_to(pos)>2:
                        tp_dict[pos]=tps
                if not pos in tp_dict:
                    tp_dict[pos]=pos
                add_black_foreground(pos,tilemap)

            if not tile in ["ground","wall","gh_barrier"] :
                tilemap.set_cell(pos.x, pos.y, 1)


    print(tp_dict)
    #print(virtual_map)


#func _process(delta):
#    pass
