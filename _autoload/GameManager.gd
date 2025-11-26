extends Node

const TESTBUG = preload("res://resources/bugs/testbug.tres")
#enum NeedType {WATER,UP,POTTY,BREAK}
signal need_timeout(need_button)

signal UpdateAll
signal UpdateStats
signal UpdateHabitat

var default_times: Array[float]=[60,40,80,30,20,50]

var snooze_time: float = 2
var current_window_position: Vector2

var current_bug: BugInfo
var bug_color: Color
var current_stats: Dictionary
var habitat_stats: Dictionary
var isBugReleased = false
var food_given: Texture2D = null
var current_path_location: float = 0

func _ready() -> void:
	current_bug = BugInfo.new()
	current_bug = TESTBUG
	current_stats = GameSave.DefaultBugStats
	habitat_stats = GameSave.DefaultHabitatStats

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
		if stat == "Hunger": 
			food_given = null
	else:
		current_stats[stat] -= amount
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
	UpdateHabitat.emit()
	GameSave.SaveGame()
	pass
