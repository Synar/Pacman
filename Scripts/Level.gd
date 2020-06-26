extends Node2D

var tilemap
var virtual_map = {}
var off_by_half_map = {}
var tp_dict = {}
var tp_exit_list = []
var grid_pos = 0
var grid_pos_half = 0

var level_prog

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


func get_tilemaps():
    var L = []
    for node in get_children():
        if node is TileMap:
            L.append(node)
    return L


func _ready():
    OS.set_window_size(Vector2(520, 610))
    VisualServer.set_default_clear_color(000000)
    #OS.set_window_position(screen_size*0.5 - window_size*0.5)
    print(get_tilemaps())
    grid_pos = main_tilemap.position
    grid_pos_half = off_by_half_tilemap.position
    GlobalPlayer.level = self
    level_prog = GlobalPlayer.level_prog

    entities_controller = entitiesControllerScene.instance()
    entities_controller.level_prog = level_prog
    add_child(entities_controller)

    for tilemap in get_tilemaps(): # [$"Background"]:
        read_tilemap(tilemap, entities_controller)

    entities_controller._on_map_loaded()


func pos_to_pos_on_grid(pos, _tilemap = main_tilemap):
    return _tilemap.world_to_map(pos - _tilemap.position)


func pos_on_grid_to_center_pos(pos, _tilemap = main_tilemap):
    return _tilemap.map_to_world(pos) + _tilemap.position + Vector2(8, 8)


func add_black_foreground(pos, _tilemap = main_tilemap):
    var tp = darkTileScene.instance()
    add_child(tp)
    tp.position = pos_on_grid_to_center_pos(pos, _tilemap)


func read_tilemap(_tilemap, _entities_controller):
    var ts = _tilemap.get_tileset()
    for pos in _tilemap.get_used_cells():
        var tile = ts.tile_get_name(_tilemap.get_cell(pos.x, pos.y))
        if _tilemap != get_node("Background"):
            print(_tilemap, " ", pos, " ", tile)
        if tile in ["ground","wall","slow","no_up","teleport","tp_exit","gh_barrier"] :
            virtual_map[pos] = tile

        match tile :
            "gh_barrier":
                _entities_controller.gh_barrier = pos_on_grid_to_center_pos(pos, _tilemap)
            "pacman":
                _entities_controller.pacman_spawn = pos_on_grid_to_center_pos(pos, _tilemap)
            "ghostspawn":
                _entities_controller.ghost_spawn = pos_on_grid_to_center_pos(pos, _tilemap)
            "inky":
                _entities_controller.inky_spawn = pos_on_grid_to_center_pos(pos, _tilemap)
            "blinky":
                _entities_controller.blinky_spawn = pos_on_grid_to_center_pos(pos, _tilemap)
            "clyde":
                _entities_controller.clyde_spawn = pos_on_grid_to_center_pos(pos, _tilemap)
            "pinky":
                _entities_controller.pinky_spawn = pos_on_grid_to_center_pos(pos, _tilemap)
            "inky_target":
                _entities_controller.inky_target = pos_on_grid_to_center_pos(pos, _tilemap)
            "blinky_target":
                _entities_controller.blinky_target = pos_on_grid_to_center_pos(pos, _tilemap)
            "clyde_target":
                _entities_controller.clyde_target = pos_on_grid_to_center_pos(pos, _tilemap)
            "pinky_target":
                _entities_controller.pinky_target = pos_on_grid_to_center_pos(pos, _tilemap)
            "fruit":
                _entities_controller.fruit_spawn.append(pos_on_grid_to_center_pos(pos, _tilemap))
            "invisible_wall":
                virtual_map[pos] = "wall"
                _tilemap.set_cellv(pos, 1)

            "tp_exit":
                tp_exit_list.append(pos)
                add_black_foreground(pos, _tilemap)

            "coin":
                var coin = coinScene.instance()
                add_child(coin)
                coin.position = pos_on_grid_to_center_pos(pos, _tilemap)
                _entities_controller.coins_remaining += 1

            "pellet":
                var pellet = pelletScene.instance()
                add_child(pellet)
                pellet.position = pos_on_grid_to_center_pos(pos, _tilemap)

            "red_placeholder":
                _entities_controller.gh_entrance = pos_on_grid_to_center_pos(pos, _tilemap)

            "gh_1":
                _entities_controller.gh_1 = pos_on_grid_to_center_pos(pos, _tilemap)

        if tile in ["red_placeholder","gh_1","gh_2"] :
            off_by_half_map[pos] = tile

    for pos in _tilemap.get_used_cells():
        var tile = ts.tile_get_name(_tilemap.get_cell(pos.x, pos.y))

        if tile == "teleport":
            for tps in tp_exit_list:
                if (tps.x == pos.x or tps.y == pos.y) and tps.distance_to(pos) > 2:
                    tp_dict[pos] = tps
            if not pos in tp_dict:
                tp_dict[pos] = pos
            add_black_foreground(pos, _tilemap)

        if not tile in ["ground","wall","gh_barrier"] :
            _tilemap.set_cellv(pos, 1)


#func _process(delta):
#    pass
