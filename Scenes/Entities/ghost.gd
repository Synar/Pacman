extends "res://Scripts/entity.gd"


var target_pos = Vector2(0,0)
var not_snapped = true
var mode = "scatter" #"chase" "dead" "frightened" "waiting" #"init"?
var reverse_upon_leaving = [false,Vector2(0,0)]
var scatter_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()

func target_tile():
    pass

var frame_count_post_turn = 0



func update_mode(delta):
    if mode == "scatter" or mode == "frightened":
        scatter_timer+=delta
    if fmod(scatter_timer,20.0)>=10.0:
        reverse_upon_leaving = [true, adjust_pos(position)]

func pick_wanted_dir(delta):
    if not_snapped:
        position = adjust_pos(position)
        not_snapped = false

    update_mode(delta)

    if frame_count_post_turn != 0:
        frame_count_post_turn = (frame_count_post_turn + 1) % 10
        return

    if reverse_upon_leaving[0] and reverse_upon_leaving[1]!=adjust_pos(position):
        wanted_dir = - current_dir
        reverse_upon_leaving = [false,Vector2(0,0)]

    elif mode == "frightened":
        wanted_dir = [Vector2(-1, 0),Vector2(1, 0),Vector2(0, -1),Vector2(0, 1)][randi()%4]

    else :
        var potentialDir = [Vector2(0, 1),Vector2(-1, 0),Vector2(0, -1),Vector2(1, 0)]
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
