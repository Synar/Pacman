extends KinematicBody2D

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    GlobalPlayer.Player=self


export(float) var speed = 0
var current_dir = Vector2(0, 0)
var wanted_dir = Vector2(0, 0)
var past_dir = Vector2(0, 0)

func _on_pickup_body_entered(body):
    score+=1
    print("Score : ",score," !")
    #print(get_node("/root/Node2D/Coin").get_overlapping_bodies())

func tile_is_wall(pos):
    var tilemap = GlobalPlayer.levelTilemap
    pos = pos - tilemap.position
    var tilemap_pos = tilemap.world_to_map(pos)
    if tilemap.get_cellv(tilemap_pos)!=1:
        return false
    return tilemap.get_cell_autotile_coord(tilemap_pos.x,tilemap_pos.y)==Vector2(0,1)


func try_dir(wanted_dir):
    return !tile_is_wall(position + 16*wanted_dir)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    if Input.is_action_pressed("move_left"):
        wanted_dir = Vector2(-1, 0)

    if Input.is_action_pressed("move_right"):
        wanted_dir = Vector2(1, 0)

    if Input.is_action_pressed("move_up"):
        wanted_dir = Vector2(0, -1)

    if Input.is_action_pressed("move_down"):
        wanted_dir = Vector2(0, 1)

    if try_dir(wanted_dir):
        current_dir = wanted_dir
        past_dir = current_dir

    if tile_is_wall(position + 8*current_dir):
        current_dir = Vector2(0, 0)


    rotation = past_dir.angle()
    position += current_dir * speed * delta
