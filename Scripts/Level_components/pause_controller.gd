extends Node



enum State {free, lockedin, leavinggh_1, leavinggh_2, dead1, dead2}
var pc_death_freeze_on = false
var gh_death_freeze_on = false
var input_pause_on = false
#var menu_pause_on = false
#var pause_list = [input_pause_on, gh_death_freeze_on, pc_death_freeze_on, menu_pause_on]

#var Mode = preload("res://path/to/enum.gd").Enum
onready var entities_controller = get_parent()

var pc_freeze_timer = -1
var gh_freeze_timer = -1


func _process(delta):

    if pc_freeze_timer != -1 and !input_pause_on and !GlobalPlayer.menu_pause_on:
        pc_freeze_timer -= delta
        if pc_freeze_timer <= 0 :
            pc_freeze_timer = -1
            pc_death_freeze_on = false
            check_pause()
            entities_controller.pc_respawn()

    if gh_freeze_timer != -1 and !input_pause_on and !GlobalPlayer.menu_pause_on:
        gh_freeze_timer -= delta
        if gh_freeze_timer <= 0 :
            gh_freeze_timer = -1
            gh_death_freeze_on = false
            check_pause()


func check_pause():
    get_tree().paused = pc_death_freeze_on or gh_death_freeze_on or input_pause_on or GlobalPlayer.menu_pause_on

    for node in entities_controller.get_children():
        if node is Pacman :
            for snode in node.get_children():
                if snode is Pacman_death :
                    unpause_node_if(snode, pc_death_freeze_on and !input_pause_on and !GlobalPlayer.menu_pause_on)
        if node is Ghost:
            if node.state == Ghost.State.dead1 or node.state == Ghost.State.dead2:
                unpause_node_if(node, gh_death_freeze_on and !input_pause_on and !GlobalPlayer.menu_pause_on)
            unpause_node_if(node.get_node("AnimatedSprite"),!input_pause_on and !GlobalPlayer.menu_pause_on)


func unpause_node_if(node, condition):
    node.pause_mode = Node.PAUSE_MODE_PROCESS if condition else Node.PAUSE_MODE_INHERIT


func gh_death_freeze(duration):
    gh_death_freeze_on = true
    check_pause()
    gh_freeze_timer = duration


func pc_death_freeze(duration):
    pc_death_freeze_on = true
    check_pause()
    pc_freeze_timer = duration


func pause_input():
    input_pause_on = !input_pause_on
    check_pause()


func escape_pause_input():
    GlobalPlayer.menu_pause_on = !GlobalPlayer.menu_pause_on
    check_pause()


func _input(event):
    if event.is_action_pressed("escape_menu"):
        escape_pause_input()
    if !GlobalPlayer.menu_pause_on:
        if event.is_action_pressed("pause"):
            pause_input()
        if event.is_action_pressed("break"):
            pass
        if event.is_action_pressed("debug_mode"):
            GlobalPlayer.debug_mode = !GlobalPlayer.debug_mode
            GlobalPlayer.anticheat = true
        if GlobalPlayer.debug_mode:
            if event.is_action_pressed("god_mode"):
                GlobalPlayer.god_mode = !GlobalPlayer.god_mode
                GlobalPlayer.anticheat = true
            if event.is_action_pressed("infinite_lives"):
                GlobalPlayer.infinite_lives = !GlobalPlayer.infinite_lives
                GlobalPlayer.anticheat = true
            if event.is_action_pressed("true_god_mode"):
                GlobalPlayer.true_god_mode = !GlobalPlayer.true_god_mode
                GlobalPlayer.anticheat = true
