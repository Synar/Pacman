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

func use_half_offset_map():
    return false


func adjust_pos(pos, direction=Vector2(1, 1)):
    return Level.adjust_pos(pos, direction, use_half_offset_map())


func tile_is_wall(pos, tile_wanted = Vector2(0,0)):#, half_offset = false, tile_wanted = Vector2(0,0)):
    return Level.get_tile_name(pos,use_half_offset_map(),tile_wanted) in ["wall","gh_barrier"]


func try_dir(_wanted_dir, delta):
    if tile_is_wall(position, _wanted_dir):
        return false

    var new_pos = position + _wanted_dir * speed * delta
    var new_pos_adj = adjust_pos(new_pos, _wanted_dir)
    return (new_pos - new_pos_adj).length() <= speed * delta



func pick_wanted_dir(_delta):
    pass


func stop_if_wall():
    #BUGGGGGGGGGGGGGGGGGGG
    if tile_is_wall(position, current_dir/2):
        current_dir = Vector2(0, 0)
        var new_position = adjust_pos(position, Vector2(1, 1))
        if new_position != position:
            print("wall wall", new_position, "  ", position)
        position = adjust_pos(position, Vector2(1, 1))


func _move(delta):
    position += current_dir * speed * delta
    var new_position = adjust_pos(position, current_dir)
    if new_position != position:
        print("well ", new_position, "  ", position)
    position = adjust_pos(position, current_dir)


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


func teleport():
    if Level.get_tile_name(position) == "teleport":
            #print("tp",Level.tp_dict)
            var pos_on_grid = Level.pos_to_pos_on_grid(position)
            position += Level.pos_on_grid_to_center_pos(Level.tp_dict[pos_on_grid]) \
                        - Level.pos_on_grid_to_center_pos(pos_on_grid)


func update_speed():
    pass


func entity_rotate():
    pass
