extends Node

export var basespeed = 75
export var first_level = 1

#var e_controller
var Player
var level
var anticheat = false

var highscore
const save_dir = "res://SaveFiles"
const highscore_path = save_dir + "/highscore.txt"
const settings_path = save_dir + "/settings.txt"
const ls_save_path = save_dir + "/ls_save.txt"
var lives_at_the_beggininging_of_the_level
var score_at_the_beggininging_of_the_level #for continuing, both when losing and quitting
#check that level_prog doesn't increase
#maybe make a copy of the game vars in an object or a dict?


var debug_mode = true setget set_debug_mode
var god_mode = false setget set_god_mode
var true_god_mode = false setget set_true_god_mode
var infinite_lives = false setget set_infinite_lives

signal lives_set
signal fruit_collected
signal modes_changed

var menu_pause_on = false
var sound_volume = 1
var level_autoload = true

onready var settings = settings_class.new()
onready var game_var = game_var_class.new()
onready var level_start_game_var = game_var_class.new()


class settings_class:
    signal sound_volume_set
    var master_volume = 0.2 setget set_master_volume
    var sfx_volume = 0.2 setget set_sfx_volume
    var music_volume = 0.2 setget set_music_volume
    var starting_lives = 3
    var basespeed_factor = 1

    var continue_not_new = false


    func set_master_volume(value):
        master_volume = value
        emit_signal("sound_volume_set")
        print("sound_volume_set")

    func set_sfx_volume(value):
        sfx_volume = value

    func set_music_volume(value):
        music_volume = value

    func _init():
        var var_dict = Globals._read_write_data(File.READ, Globals.settings_path, {})
        for var_name in var_dict:
            self.set(var_name, var_dict[var_name])
        #continue_not_new = false #override save
        save()


    func save():
        var var_dict = {}
        for var_name in Globals.filter(self.get_script().get_script_property_list()):
            var_dict[var_name] = self.get(var_name)
            print(var_name, " ", self.get(var_name))
        Globals._read_write_data(File.WRITE, Globals.settings_path, var_dict)




class game_var_class:
    #func _init():
    #    lives = Globals.settings.starting_lives
    var fruits_eaten = []
    var score = 0
    var basespeed_factor = 1
    var level_prog = Globals.first_level
    var lives = Globals.settings.starting_lives
    var starting_lives_factor = 1

    func save():
        var var_dict = {}
        for var_name in Globals.filter(self.get_script().get_script_property_list()):
            var_dict[var_name] = self.get(var_name)
            print(var_name, " ", self.get(var_name))
        Globals._read_write_data(File.WRITE, Globals.ls_save_path, var_dict)



class dbg_settings:
    var placeholder



func _read_write_data(mode, path, data = 0):
    var dir = Directory.new( )
    if !dir.dir_exists(path.get_base_dir()):
        #dir.open(base directory for user, else it won't work after import)
        dir.make_dir_recursive(path.get_base_dir())
    var file = File.new()
    var err = file.open(path, mode)
    if err == ERR_FILE_NOT_FOUND:
        err = file.open(path, File.WRITE_READ)
        mode = File.WRITE
    if err != OK:
        print ("err :", err)
        return err
    if mode == File.READ:
        data = parse_json(file.get_as_text())
    if mode == File.WRITE:
        file.store_line(to_json(data))
    file.close()
    return data


func _read_write_score(mode):
    return _read_write_data(mode, highscore_path, game_var.score)


#var test = 30
func _ready():
    #test = 20
    highscore = _read_write_score(File.READ)
    #print("test reading :")
    #print( _read_write_data(File.WRITE,save_dir + "/test.txt",{0:10,1:[{1: 32}, "er", ['1', 4]]}))
    #print( _read_write_data(File.READ,save_dir + "/test.txt",1))
    #test = 10


func _on_level_loaded():
    emit_signal("lives_set", game_var.lives)
    emit_signal("fruit_collected", game_var.fruits_eaten)
    emit_signal("modes_changed")


func next_level():
    game_var.level_prog += 1
    if game_var.level_prog == 2:
        get_tree().change_scene("res://Scenes/Animations/intermission1.tscn")
        yield(get_tree(),"idle_frame")
        yield(get_tree().get_root().get_child(1), "animation_end")
    #print("here :")
    #print(get_tree().get_root().get_child(1))
    #print(get_tree().get_root().get_child(1).filename)
    #print(": here")
    get_tree().change_scene("res://Scenes/Level1.tscn")


func score_increase(score_value):
    game_var.score += score_value*game_var.basespeed_factor*game_var.starting_lives_factor
    if !anticheat and game_var.score > highscore:
        highscore = game_var.score
        _read_write_score(File.WRITE)


func life_loss(count=1):
    game_var.lives -= count
    if game_var.lives <= 0 and !infinite_lives:
        get_tree().change_scene("res://Scenes/GUI/GameOver.tscn")
    emit_signal("lives_set", game_var.lives)


func fruit_collected(fruits):
    game_var.fruits_eaten += fruits
    emit_signal("fruit_collected",fruits)


func set_debug_mode(value):
    debug_mode = value
    emit_signal("modes_changed")


func set_god_mode(value):
    god_mode = value
    emit_signal("modes_changed")


func set_infinite_lives(value):
    infinite_lives = value
    emit_signal("modes_changed")


func set_true_god_mode(value):
    true_god_mode = value
    emit_signal("modes_changed")


func quit_to_title():
    menu_pause_on = false
    get_tree().paused = false
    get_tree().change_scene("res://Scenes/GUI/TitleScreen.tscn")


func copy_object(object, obj_class):
    var object_copy = obj_class.new()#get_class().new()
    for var_name in filter(object.get_script().get_script_property_list()):
        object_copy.set(var_name, object.get(var_name))



func new_game():
    game_var = game_var_class.new()
    level_start_game_var = copy_object(game_var, game_var_class)
    get_tree().change_scene("res://Scenes/Level1.tscn")


func save_game():
    _read_write_data(File.READ, save_dir + "/testsave3.txt", save_node(level))


func save_node(node):
    if node.has_method("save_node"):
        node.call("save_node")
        return
    var children_name = []
    for child in node.get_children():
        children_name.append(child.get_name())
    var var_dict = {}
    for variable in filter(node.get_property_list ()):
        var_dict[variable] = node.get(variable)
    var children_var_dict = {}
    for child in node.get_children():
        children_var_dict[child.get_name()] = save_node(child)
    var data = {"name": node.get_name(), "children_name": children_name, "var_dict": var_dict, "children_var_dict": children_var_dict}
    return data
    #print(filter(get_script().get_script_property_list()))
    print(filter(get_property_list ()))


func filter(l):
    var r = []
    for d in l:
        r.append(d["name"])
    return r


func load_game():
    #level = load("res://my_scene.tscn").instance()
    #get_tree().change_scene("res://my_scene.tscn")
    level_start_game_var