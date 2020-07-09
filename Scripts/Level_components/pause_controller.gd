extends Node



enum State {free, lockedin, leavinggh_1, leavinggh_2, dead1, dead2}
var pc_death_freeze_on = false
var gh_death_freeze_on = false
var input_pause_on = false

#var Mode = preload("res://path/to/enum.gd").Enum
onready var entities_controller = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

var pc_freeze_timer = -1
var gh_freeze_timer = -1

func _process(delta):
    if pc_freeze_timer != -1 :
        pc_freeze_timer -= delta
        if pc_freeze_timer <= 0 :
            pc_freeze_timer = -1
            pc_death_freeze_on = false
            check_pause()
            entities_controller.pc_respawn()

    if gh_freeze_timer != -1 :
        gh_freeze_timer -= delta
        if gh_freeze_timer <= 0 :
            gh_freeze_timer = -1
            gh_death_freeze_on = false
            check_pause()


func check_pause():
    get_tree().paused = pc_death_freeze_on or gh_death_freeze_on or input_pause_on

    for node in entities_controller.get_children():
        if node is Pacman_death :
            node.pause_mode =  Node.PAUSE_MODE_PROCESS if pc_death_freeze_on and !input_pause_on else Node.PAUSE_MODE_INHERIT
        if node is Ghost:
            if node.mode == Ghost.State.dead1 or node.mode == Ghost.State.dead2:
                node.pause_mode = Node.PAUSE_MODE_PROCESS if gh_death_freeze_on and !input_pause_on else Node.PAUSE_MODE_INHERIT

func gh_death_freeze(duration):
    gh_death_freeze_on = true
    check_pause()
    gh_freeze_timer = duration

func pc_death_freeze(duration):
    pc_death_freeze_on = true
    check_pause()
    pc_freeze_timer = duration
