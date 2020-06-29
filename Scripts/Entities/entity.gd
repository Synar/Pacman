class_name Entity
extends Node2D

export(int) var test_id = 0
export(bool) var smooth_game_control = true
var level_prog = 1
onready var Level = GlobalPlayer.level

export(float) var speed = 20
var current_dir = Vector2(0, 0)
var wanted_dir = Vector2(0, 0)
var past_dir = Vector2(1, 0)
var vect_to_dir = {
    Vector2(1, 0): "right",
    Vector2(0, -1): "up",
    Vector2(-1, 0): "left",
    Vector2(0, 1): "down",
}


#func get_tile_coord(pos, tilemap=GlobalPlayer.level.main_tilemap): #position_to_pos_on_grid
#    return GlobalPlayer.level.pos_to_pos_on_grid(pos,tilemap)


#func get_tile_name(pos, vmap=GlobalPlayer.level.virtual_map, tilemap=GlobalPlayer.level.main_tilemap):
#    var pos_on_grid = get_tile_coord(pos,tilemap)
#    if pos_on_grid in vmap:
#        return vmap[pos_on_grid]
#    else :
#        return "ground" #"empty"?


func tile_is_wall(pos):
    return Level.get_tile_name(pos) in ["wall","gh_barrier"]


func try_dir(_wanted_dir, delta):
    if tile_is_wall(position + 16*_wanted_dir):
        return false

    var new_pos = position + _wanted_dir * speed * delta
    var new_pos_adj = Level.adjust_pos(new_pos, _wanted_dir)
    return (new_pos - new_pos_adj).length() <= speed * delta


#func adjust_pos(pos, direction=Vector2(1, 1), half_offset = false):
    #return GlobalPlayer.level.adjust_pos(pos, direction, half_offset)
    #var tile_size = GlobalPlayer.level.tile_size
    #var size_adjust = tile_size / 2

    #var grid_pos = GlobalPlayer.level.grid_pos_half if half_offset else GlobalPlayer.level.grid_pos

    #if direction.x != 0:
    #    pos.y = stepify(pos.y - grid_pos.y - size_adjust, tile_size) + grid_pos.y + size_adjust
    #if direction.y != 0:
    #    pos.x = stepify(pos.x - grid_pos.x - size_adjust, tile_size) + grid_pos.x + size_adjust
    #return pos


func adjust_by_half():
    return false


func pick_wanted_dir(_delta):
    pass


func teleport():
    if Level.get_tile_name(position) == "teleport":
            #print("tp",Level.tp_dict)
            var pos_on_grid = Level.pos_to_pos_on_grid(position)
            position += Level.pos_on_grid_to_center_pos(Level.tp_dict[pos_on_grid] - pos_on_grid)



func _process(delta):
    update_speed()
    pick_wanted_dir(delta)

    if try_dir(wanted_dir, delta):
        current_dir = wanted_dir

    if current_dir != Vector2(0,0):
        past_dir = current_dir

    if !smooth_game_control:
         wanted_dir = current_dir

    stop_if_wall()
    entity_rotate()
    _move(delta)
    teleport()


func stop_if_wall():
    if tile_is_wall(position + 8*current_dir):
        current_dir = Vector2(0, 0)
        position = Level.adjust_pos(position, Vector2(1, 1))


func _move(delta):
    position += current_dir * speed * delta
    position = Level.adjust_pos(position, current_dir)


func update_speed():
    pass


func entity_rotate():
    pass
