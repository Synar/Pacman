extends "res://Scripts/Entities/entity.gd"


var target_pos = Vector2(-10,5)
var scatter_target = Vector2(-10,5)
var not_snapped = true
enum State {free, lockedin, leavinggh_1, leavinggh_2, dead}
var state = State.lockedin
enum Mode {scatter, chase, frightened}
var mode = Mode.scatter
var reverse_upon_leaving = [false,Vector2(0,0)]
var scatter_timer = 0
var gh_1 = Vector2(0,0)
var gh_entrance = Vector2(0,0)

var chase_scatter_times = [7,20,7,20,5,20,5,-1]
var fright_time = 6


# Called when the node enters the scene tree for the first time.
func _ready():
    z_index = 3
    randomize()
    self.connect("body_entered", GlobalPlayer.e_controller, "_on_ghost_body_entered", [])


func target_tile():
    match state :
        State.free :
            match mode :
                Mode.chase:
                    target_pos = chase_target()
                Mode.scatter:
                    target_pos = scatter_target
        State.leavinggh_1 :
                target_pos = gh_entrance
        State.leavinggh_2 :
                target_pos = gh_1

var frame_count_post_turn = 0

func liberate():
    if state == State.lockedin:
        state = State.leavinggh_1

func tile_is_wall(pos):
    if state == State.free or state == State.lockedin:
        return get_tile_name(pos) in ["wall","gh_barrier"]
    else :
        return get_tile_name(pos) == "wall"

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
        mode = Mode.chase if mode == Mode.scatter else Mode.scatter
        print("mc 1 : ",mode)
        pls_reverse_upon_leaving()

var frightened_timer = -1

func frighten():
    if mode != Mode.frightened:
        pls_reverse_upon_leaving()
    mode = Mode.frightened
    print("mc 2 : ",mode)

func calm():
    mode = Mode.chase if chase_or_scatter_index%2 == 1 else Mode.scatter
    print("mc 3 : ",mode)

func update_mode(delta):
    if mode == Mode.scatter or mode == Mode.chase:
        chase_or_scatter(delta)
    if state == State.leavinggh_1:
        if get_tile_name(position,GlobalPlayer.level.off_by_half_map,GlobalPlayer.level.off_by_half_tilemap)=="red_placeholder":
            state = State.leavinggh_2
            print("wesh ça marche du premier coup")


func pick_wanted_dir(delta):
    #if not_snapped:
    #    position = adjust_pos(position)
    #    not_snapped = false

    update_mode(delta)
    target_tile()

    if state == State.lockedin:
            var potentialDir = [Vector2(0, 1),Vector2(0, -1)]
            if not current_dir in potentialDir:
                wanted_dir = potentialDir[0]
            if tile_is_wall(position + 8*wanted_dir):
                wanted_dir = -wanted_dir


    else :
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
            if mode == Mode.frightened and potentialDir.size() > 1:
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


func update_speed():
    if level_prog == 1:
        if get_tile_name(position) in ["slow","teleport","tp_exit"]:
            speed = 0.4*GlobalPlayer.basespeed
        elif mode == Mode.frightened:
            speed = 0.5*GlobalPlayer.basespeed
        else :
            speed = 0.75*GlobalPlayer.basespeed
    elif 4<level_prog:
        if get_tile_name(position) in ["slow","teleport","tp_exit"]:
            speed = 0.45*GlobalPlayer.basespeed
        elif mode == Mode.frightened:
            speed = 0.55*GlobalPlayer.basespeed
        else :
            speed = 0.85*GlobalPlayer.basespeed
    else :
        if get_tile_name(position) in ["slow","teleport","tp_exit"]:
            speed = 0.5*GlobalPlayer.basespeed
        elif mode == Mode.frightened:
            speed = 0.6*GlobalPlayer.basespeed
        else :
            speed = 0.95*GlobalPlayer.basespeed


func entity_rotate():
    var anim_name_start
    var anim_name_end
    if past_dir in vect_to_dir:
        anim_name_end = (vect_to_dir[past_dir])
        rotation = Vector2(1,0).angle()
    else :
        anim_name_end = ("right")
        rotation = past_dir.angle()
        print("WTF")
    if state == State.dead:
        anim_name_start = "dead"
    elif mode == Mode.frightened:
        anim_name_start = "fright"    #needs flashing before return to normal
    else :
        anim_name_start = "normal"

    $AnimatedSprite.play(anim_name_start+"_"+anim_name_end)




