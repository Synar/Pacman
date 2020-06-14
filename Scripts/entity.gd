extends KinematicBody2D

export(int) var test_id = 0
export(bool) var smooth_game_control = true

export(float) var speed = 20
var current_dir = Vector2(0, 0)
var wanted_dir = Vector2(0, 0)
var past_dir = Vector2(0, 0)
var tilemap

    #print(get_node("/root/Node2D/Coin").get_overlapping_bodies())
#func _ready():
    #print("ici",test_id)
    #tilemap = GlobalPlayer.levelTilemap
    #print(tilemap)
    #print(GlobalPlayer.levelTilemap.position)

func tile_is_wall(pos):
    #print("là")
    #print(GlobalPlayer.levelTilemap.position)
    #tilemap = GlobalPlayer.levelTilemap
    var L = GlobalPlayer.level
    var pos_on_grid = L.pos_to_pos_on_grid(pos - L.grid_pos)
    return pos_on_grid in L.virtual_map and L.virtual_map[pos_on_grid]=="wall"


func try_dir(wanted_dir, delta):
    if tile_is_wall(position + 16*wanted_dir):
        return false

    var new_pos = position + wanted_dir * speed * delta
    var new_pos_adj = adjust_pos(new_pos, wanted_dir)
    return (new_pos - new_pos_adj).length() <= speed * delta


func adjust_pos(pos, direction=Vector2(1,1)):
    var size_adjust = 8
    if direction.x != 0:
        pos.y = stepify(pos.y - GlobalPlayer.level.grid_pos.y - size_adjust, 16) + GlobalPlayer.level.grid_pos.y + size_adjust

    if direction.y != 0:
        pos.x = stepify(pos.x - GlobalPlayer.level.grid_pos.x - size_adjust, 16) + GlobalPlayer.level.grid_pos.x + size_adjust

    return pos

func pick_wanted_dir(delta):
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    pick_wanted_dir(delta)

    if try_dir(wanted_dir, delta):
        current_dir = wanted_dir
        past_dir = current_dir

    if !smooth_game_control:
         wanted_dir = current_dir

    if tile_is_wall(position + 8*current_dir):
        current_dir = Vector2(0, 0)
        position = adjust_pos(position, Vector2(1, 1))

    entity_rotate()
    position += current_dir * speed * delta

    position = adjust_pos(position, current_dir)


func entity_rotate():
    pass
