extends "res://Scripts/Entities/entity.gd"


var target_pos = Vector2(-10,5)
var not_snapped = true
var state = "free"
var mode = "scatter" #"chase" "dead" "frightened" "lockedIn" #"init"?
var reverse_upon_leaving = [false,Vector2(0,0)]
var scatter_timer = 0

var chase_scatter_times = [7,20,7,20,5,20,5,-1]
var fright_time = 6

func whatever():
    var new_chase_scatter_times = [chase_scatter_times[0]]
    for i in range(1,chase_scatter_times.size()):
        new_chase_scatter_times.append(chase_scatter_times[i]+new_chase_scatter_times[i-1])
    chase_scatter_times = new_chase_scatter_times



# Called when the node enters the scene tree for the first time.
func _ready():
    z_index = 3
    randomize()
    #whatever()

func target_tile():
    pass

var frame_count_post_turn = 0

func liberate():
    pass



func chase_target():
    return adjust_pos(GlobalPlayer.Player.position)

var chase_or_scatter_timer = chase_scatter_times[0]
var chase_or_scatter_index = 0

func pls_reverse_upon_leaving():
    reverse_upon_leaving = [true, adjust_pos(position)]

func chase_or_scatter(delta):
    if chase_or_scatter_timer == -1 :
        return
    chase_or_scatter_timer -= delta
    if chase_or_scatter_timer < 0 :
        chase_or_scatter_index += 1
        chase_or_scatter_timer = chase_scatter_times[chase_or_scatter_index]
        mode = "chase" if mode == "scatter" else "scatter"
        print("mc 1 : ",mode)
        pls_reverse_upon_leaving()

var frightened_timer = -1

func frighten():
    if mode != "frightened":
        pls_reverse_upon_leaving()
    mode = "frightened"
    print("mc 2 : ",mode)
    frightened_timer = fright_time

func update_mode(delta):
    if mode == "scatter" or mode == "chase":
        chase_or_scatter(delta)

    if mode == "frightened":
        print(frightened_timer,delta)
        frightened_timer -= delta
        if frightened_timer < 0 :
            mode = "chase" if chase_or_scatter_index%2 == 1 else "scatter"
            print("mc 3 : ",mode)



func pick_wanted_dir(delta):
    #if not_snapped:
    #    position = adjust_pos(position)
    #    not_snapped = false

    update_mode(delta)

    if frame_count_post_turn != 0:
        frame_count_post_turn = (frame_count_post_turn + 1) % 10
        return

    if reverse_upon_leaving[0] and reverse_upon_leaving[1]!=adjust_pos(position):
        wanted_dir = - current_dir
        reverse_upon_leaving = [false,Vector2(0,0)]


    else :
        var potentialDir = [Vector2(0, 1),Vector2(-1, 0),Vector2(0, -1),Vector2(1, 0)]
        potentialDir.erase(-current_dir)
        for dir in potentialDir.duplicate():
            if tile_is_wall(position + 16*dir):
                potentialDir.erase(dir)
        if mode == "frightened" and potentialDir.size() > 1:
            wanted_dir = potentialDir[randi()%potentialDir.size()]
        else :
            wanted_dir = potentialDir[0]
            for dir in potentialDir:
                if (position+dir).distance_to(target_pos) < (position+wanted_dir).distance_to(target_pos):
                    wanted_dir = dir

    if wanted_dir != current_dir:
        frame_count_post_turn += 1




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
