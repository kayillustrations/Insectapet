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
var isNewBug:bool = false

var habitat_window
var bug_color: Color
var current_stats: Dictionary
var habitat_stats: Dictionary
var current_path_location: float = 0
var isBugWindow = false

var isGameMusicOn: bool = true

var food_given: Texture2D = Texture2D.new()
var food_life: float = 100

var habitat_warning: bool = false

var isEmbed:bool = true

#func _init() -> void:
	#if ProjectSettings.get_setting("application/run/main_scene") == "uid://r2tsosqw2in3":
		#isEmbed = true
		#default_times = [30,20,25,15,10,20]
		#life_times = [5,30,30]
	#else: 
		#isEmbed = false

func _ready() -> void:
	current_bug = BugInfo.new()
	current_stats = GameSave.DefaultBugStats
	habitat_stats = GameSave.DefaultHabitatStats

func NewBug(newBugInfo:BugInfo):
	GameSave.bug_info["bug_resource_name"] = newBugInfo.resource_name
	current_bug = newBugInfo
	current_stats = GameSave.DefaultBugStats
	isNewBug = true
	#Bug animation
	GameSave.SaveGame()
	pass

func ReleaseBug():
	pass

func SpawnBugWindow(b:bool):
	isBugWindow = b
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
	
	if stat == "XP" && GameManager.current_stats["Stage"] < 3:
		if current_stats[stat] == 100:
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
