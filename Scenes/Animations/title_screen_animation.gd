extends Node2D


var vect_to_dir = {Vector2(1, 0): "right", Vector2(0, -1): "up", Vector2(-1, 0): "left", Vector2(0, 1): "down"}
var dir_to_vect = {"right": Vector2(1, 0), "up": Vector2(0, -1), "left": Vector2(-1, 0), "down": Vector2(0, 1)}
enum {SOLO_GHOST, SOLO_FRIGHT, SOLO_PACMAN, GH_CHASE, PC_CHASE,}

func _ready():
    randomize()
    var dir = pick_at_rand(["right", "up", "left", "down"])
    var vdir = dir_to_vect[dir]
    var orth_vdir = Vector2(1, 0) if vdir.dot(Vector2(1, 0)) == 0 else Vector2(0, 1)
    print(vdir, orth_vdir)
    var orth_pos = 600*randf()*orth_vdir
    var init_pos = orth_pos + 350*(vdir.abs() - vdir) - 50*vdir.abs()
    var end_pos = orth_pos + 350*(vdir.abs() + vdir) - 50*vdir.abs()
    print(orth_pos,init_pos,end_pos)

    var animation = Animation.new()
    animation.length = 8.5

    var anim_type = pick_at_rand(range(5),[0.7,0.1,0.1,0.05,0.05])
    $pacman.play(dir)
    var ghost = pick_at_rand([$inky,$blinky,$pinky,$clyde])
    ghost.visible = true
    match anim_type:
        SOLO_GHOST:
            $pacman.visible = false
            ghost.play("normal_"+dir)
        SOLO_FRIGHT:
            $pacman.visible = false
            ghost.play("fright_"+dir)
        SOLO_PACMAN:
            ghost.visible = false
        GH_CHASE:
            ghost.play("normal_"+dir)
            var track_index = animation.add_track(Animation.TYPE_VALUE)
            animation.track_set_path(track_index, str(ghost.get_path())+":position")
            animation.track_insert_key(track_index, 0, ghost.position - 38*vdir)
            animation.track_insert_key(track_index, 8, ghost.position - 18*vdir)
        PC_CHASE:
            ghost.play("fright_"+dir)
            var track_index = animation.add_track(Animation.TYPE_VALUE)
            animation.track_set_path(track_index, "pacman:position")
            animation.track_insert_key(track_index, 0, $pacman.position - 30*vdir)
            animation.track_insert_key(track_index, 8, $pacman.position - 15*vdir)

    #add random speed ?
    var track_index = animation.add_track(Animation.TYPE_VALUE)
    animation.track_set_path(track_index, ".:position")
    animation.track_insert_key(track_index, 0.0, init_pos)
    animation.track_insert_key(track_index, 8, end_pos)

    $AnimationPlayer.add_animation("animation", animation)
    $AnimationPlayer.play("animation")
    #print(pick_at_rand([0,10,100,21], [0.1,0.7,0.1,0.2]))


func pick_at_rand(array, proba_array = false):
    if array == []:
        return "Error : empty array"
    if proba_array:
        var x = randf()
        var cumulated_p = 0
        for i in range(proba_array.size()):
            cumulated_p += proba_array[i]
            if cumulated_p >= x:
                return array[i]
        return "Error : probabilities don't add to 1"
    else:
        return array[randi()%array.size()]


func _on_AnimationPlayer_animation_finished(_anim_name):
    queue_free()
