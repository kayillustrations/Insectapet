extends Node

const TESTBUG = preload("res://resources/bugs/testbug.tres")
#enum NeedType {WATER,UP,POTTY,BREAK}
signal need_timeout(need_button)

signal UpdateAll
signal UpdateStats
signal UpdateHabitat

var default_times: Array[float]=[60,40,80,30,20]

var snooze_time: float = 2
var current_window_position: Vector2

var current_bug: BugInfo
var current_stats: Dictionary
var habitat_stats: Dictionary
var isBugReleased = false
var food_given: Texture2D = null
var current_path_location: float

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
