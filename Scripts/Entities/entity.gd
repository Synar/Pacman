class_name Entity
extends Node2D

export(int) var test_id := 0
export(bool) var smooth_game_control := true
var level_prog := 1

export(float) var speed := 20
var current_dir := Vector2(0, 0)
var wanted_dir := Vector2(0, 0)
var past_dir := Vector2(1, 0)
var vect_to_dir := {
    Vector2(1, 0): "right",
    Vector2(0, -1): "up",
    Vector2(-1, 0): "left",
    Vector2(0, 1): "down",
}

var teleported = false


func get_tile_coord(pos, tilemap=GlobalPlayer.level.main_tilemap): #position_to_pos_on_grid
    return GlobalPlayer.level.pos_to_pos_on_grid(pos,tilemap)


func get_tile_name(pos, vmap=GlobalPlayer.level.virtual_map, tilemap=GlobalPlayer.level.main_tilemap):
    #var L = GlobalPlayer.level
    var pos_on_grid = get_tile_coord(pos,tilemap)
    if pos_on_grid in vmap:
        return vmap[pos_on_grid]
    else :
        return "ground" #"empty"?


func tile_is_wall(pos):
    #tilemap = GlobalPlayer.levelTilemap
    #var L = GlobalPlayer.level
    #var pos_on_grid = get_tile_coord(pos)
    return get_tile_name(pos) in ["wall","gh_barrier"]


func try_dir(_wanted_dir, delta):
    if tile_is_wall(position + 16*_wanted_dir):
        return false

    var new_pos = position + _wanted_dir * speed * delta
    var new_pos_adj = adjust_pos(new_pos, _wanted_dir)
    return (new_pos - new_pos_adj).length() <= speed * delta


func adjust_pos(pos, direction=Vector2(1, 1)):
    var size_adjust = 8
    #pos = GlobalPlayer.level.pos_on_grid_to_center_pos(GlobalPlayer.level.pos_to_pos_on_grid(pos, tilemap))
    var grid_pos = GlobalPlayer.level.grid_pos_half if adjust_by_half() else GlobalPlayer.level.grid_pos
    if direction.x != 0:
        pos.y = stepify(pos.y - grid_pos.y - size_adjust, 16) + grid_pos.y + size_adjust

    if direction.y != 0:
        pos.x = stepify(pos.x - grid_pos.x - size_adjust, 16) + grid_pos.x + size_adjust

    return pos

func adjust_by_half():
    return false

func pick_wanted_dir(_delta):
    pass

func teleport():
    if get_tile_name(position) == "teleport":
        if teleported == false:
            print("tp",GlobalPlayer.level.tp_dict)
            position += 16*(GlobalPlayer.level.tp_dict[get_tile_coord(position)]-get_tile_coord(position))
            teleported = true
    else:
        teleported = false

func _process(delta):
    update_speed()
    pick_wanted_dir(delta)

    if try_dir(wanted_dir, delta):
        current_dir = wanted_dir

    if current_dir != Vector2(0,0):
        past_dir = current_dir

    if !smooth_game_control:
         wanted_dir = current_dir

    if tile_is_wall(position + 8*current_dir):
        current_dir = Vector2(0, 0)
        position = adjust_pos(position, Vector2(1, 1))

    entity_rotate()
    position += current_dir * speed * delta
    position = adjust_pos(position, current_dir)
    teleport()


func update_speed():
    pass

func entity_rotate():
    pass
