extends Node

const STICKBUG = preload("res://resources/bugs/stickbug.tres")
signal need_timeout(need_button)

signal UpdateAll
signal UpdateStats
signal UpdateHabitat
signal BugEmote(emote:Texture)
signal StatWarning(stat:String, activate:bool)

var default_times: Array[float]=[60,40,80,30,20,50]
var life_times: Array[float] = [10,60,60] #seconds * 20 (3.3 min, 20 min, 20 min)

var snooze_time: float = 2
var current_window_position: Vector2

var current_bug: BugInfo
var isNewGame:bool = false

var bug_color: Color
var current_stats: Dictionary
var habitat_stats: Dictionary
var current_path_location: float = 0
var isBugReleased = false

var food_given: Texture2D = null
var food_life: float

var habitat_warning: bool = false

func _ready() -> void:
	current_bug = BugInfo.new()
	current_stats = GameSave.DefaultBugStats
	habitat_stats = GameSave.DefaultHabitatStats

func isNewBug(b:bool):
	if b:
		current_bug = STICKBUG
		GameSave.bug_info["bug_resource_name"] = "stickbug"
	else:
		var load_bug = load("res://resources/bugs/" + str(GameSave.bug_info["bug_resource_name"]) + ".tres")
		current_bug = load_bug
		pass
	

func ReleaseBug(b:bool):
	isBugReleased = b
	if b:
		WindowManager.main_window.add_window(WindowManager.BUG_WINDOW_PATH)
	else: 
		WindowManager.main_window.find_child("Window").queue_free()


func EditStat(stat:String,amount:int):
	if current_stats[stat] - amount <= 0:
		current_stats[stat] = 0
		printerr(stat+" Empty")
	elif current_stats[stat] - amount > 100:
		current_stats[stat] = 100
		printerr(stat+" Full")
	else:
		current_stats[stat] -= amount
	
	if stat == "XP" && current_stats[stat] == 100 && GameManager.current_stats["Stage"] < 3:
			#Emote(Exports.emote_dictionary["Oh?"])
			StatWarning.emit("XP",true)
	elif current_stats[stat] < 25:
		StatWarning.emit(stat,true)
	else: StatWarning.emit(stat,false)
	
	UpdateStats.emit()
	GameSave.SaveGame()

func EditHabitat(stat:String, amount:int):
	if habitat_stats[stat] - amount <= 0:
		habitat_stats[stat] = 0
		printerr(stat+" Empty")
	elif habitat_stats[stat] - amount > 100:
		habitat_stats[stat] = 100
		printerr(stat+" Full")
	else:
		habitat_stats[stat] -= amount
	if habitat_stats[stat] < 25:
		habitat_warning = true
	else: habitat_warning = false
	UpdateHabitat.emit()
	GameSave.SaveGame()
	pass

func Emote(stat:String):
	pass
