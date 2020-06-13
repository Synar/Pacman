extends "res://Scripts/entity.gd"


var target_pos = Vector2(0,0)
var not_snapped = true

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func target_tile():
    pass

var frame_count_post_turn = 0

func pick_wanted_dir(delta):
    if not_snapped:
        position = adjust_pos(position)
        not_snapped = false

    if frame_count_post_turn != 0:
        frame_count_post_turn = (frame_count_post_turn + 1) % 10
        return

    var potentialDir = [Vector2(-1, 0),Vector2(1, 0),Vector2(0, -1),Vector2(0, 1)]
    potentialDir.erase(-current_dir)
    for dir in potentialDir.duplicate():
        if tile_is_wall(position + 16*dir):
            potentialDir.erase(dir)

    wanted_dir = potentialDir[0]
    for dir in potentialDir:
        if (position+dir).distance_to(target_pos) < (position+wanted_dir).distance_to(target_pos):
            wanted_dir = dir

    if wanted_dir != current_dir:
        frame_count_post_turn += 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
