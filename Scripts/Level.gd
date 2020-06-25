extends Node2D

var tilemap
var virtual_map = {}
var off_by_half_map = {}
var tp_dict = {}
var tp_exit_list = []
var grid_pos = 0
var grid_pos_half = 0

export var level_prog = 1

var pacmanScene = load("res://Scenes/Entities/pacman.tscn")
var coinScene = load("res://Scenes/pickup/coin.tscn")
var pelletScene = load("res://Scenes/pickup/pellet.tscn")
var fruitScene = load("res://Scenes/pickup/Fruit.tscn")
var darkTileScene = load("res://Scenes/Level_components/dark_tile.tscn")
var entitiesControllerScene = load("res://Scenes/Level_components/entities_controller.tscn")

onready var main_tilemap = $"Background"
onready var off_by_half_tilemap = $"Offbyhalf"
var entities_controller
#onready var entities_controller = $"entities_controller"
#signal map_loaded

func get_tilemaps():
    var L=[]
    for node in get_children():
        if node is TileMap:
            L.append(node)
    return L



func _ready():
    OS.set_window_size(Vector2(520, 610))
    VisualServer.set_default_clear_color(000000)
    #OS.set_window_position(screen_size*0.5 - window_size*0.5)
    print(get_tilemaps())
    var tilemaps=get_tilemaps()
    print("mais")
    grid_pos = main_tilemap.position
    grid_pos_half = off_by_half_tilemap.position
    GlobalPlayer.level = self
    print("si")

    entities_controller = entitiesControllerScene.instance()
    entities_controller.level_prog = level_prog
    add_child(entities_controller)

    for tilemap in get_tilemaps():#[$"Background"]:#
        read_tilemap(tilemap,entities_controller)

    entities_controller._on_map_loaded()



func pos_to_pos_on_grid(pos, tilemap = main_tilemap):
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
            if tile in ["ground","wall","slow","no_up","teleport","tp_exit","gh_barrier"] :
                virtual_map[pos] = tile

            match tile :
                "gh_barrier": entities_controller.gh_barrier = pos_on_grid_to_center_pos(pos,tilemap)

                "pacman": entities_controller.pacman_spawn = pos_on_grid_to_center_pos(pos,tilemap)

                "ghostspawn": entities_controller.ghost_spawn = pos_on_grid_to_center_pos(pos,tilemap)

                "inky": entities_controller.inky_spawn = pos_on_grid_to_center_pos(pos,tilemap)

                "blinky": entities_controller.blinky_spawn = pos_on_grid_to_center_pos(pos,tilemap)

                "clyde": entities_controller.clyde_spawn = pos_on_grid_to_center_pos(pos,tilemap)

                "pinky": entities_controller.pinky_spawn = pos_on_grid_to_center_pos(pos,tilemap)

                "inky_target": entities_controller.inky_target = pos_on_grid_to_center_pos(pos,tilemap)

                "blinky_target": entities_controller.blinky_target = pos_on_grid_to_center_pos(pos,tilemap)

                "clyde_target": entities_controller.clyde_target = pos_on_grid_to_center_pos(pos,tilemap)

                "pinky_target": entities_controller.pinky_target = pos_on_grid_to_center_pos(pos,tilemap)

                "fruit": entities_controller.fruit_spawn.append(pos_on_grid_to_center_pos(pos,tilemap))

                "invisible_wall":
                    virtual_map[pos] = "wall"
                    tilemap.set_cellv(pos, 1)

                "tp_exit":
                    tp_exit_list.append(pos)
                    add_black_foreground(pos,tilemap)

                "coin":
                    var coin = coinScene.instance()
                    add_child(coin)
                    coin.position = pos_on_grid_to_center_pos(pos,tilemap)
                    entities_controller.coin_count += 1

                "pellet":
                    var pellet = pelletScene.instance()
                    add_child(pellet)
                    pellet.position = pos_on_grid_to_center_pos(pos,tilemap)

                "red_placeholder":
                    entities_controller.gh_entrance = pos_on_grid_to_center_pos(pos,tilemap)

                "gh_1":
                    entities_controller.gh_1 = pos_on_grid_to_center_pos(pos,tilemap)

            if tile in ["red_placeholder","gh_1","gh_2"] :
                off_by_half_map[pos] = tile


    for pos in tilemap.get_used_cells():
            var tile = ts.tile_get_name(tilemap.get_cell(pos.x, pos.y))

            if tile=="teleport":
                for tps in tp_exit_list:
                    if (tps.x==pos.x or tps.y==pos.y) and tps.distance_to(pos)>2:
                        tp_dict[pos]=tps
                if not pos in tp_dict:
                    tp_dict[pos]=pos
                add_black_foreground(pos,tilemap)

            if not tile in ["ground","wall","gh_barrier"] :
                tilemap.set_cellv(pos, 1)


    #print(tp_dict)
    #print(virtual_map)


#func _process(delta):
#    pass
