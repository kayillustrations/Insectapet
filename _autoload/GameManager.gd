extends Node
const TESTBUG = preload("res://resources/bugs/testbug.tres")
#enum NeedType {WATER,UP,POTTY,BREAK}
signal need_timeout(need_button)

var need_queue:Array = []

var default_times: Array[float]=[.1,65,95,115]

var snooze_time: float = 2
var current_window_position: Vector2

var current_bug: BugInfo
var isBugReleased = false

func _ready() -> void:
	var bug = BugInfo.new()
	bug = TESTBUG
	bug.stats = GameSave.

func ReleaseBug(b:bool):
	if b:
		WindowManager.main_window.add_window(WindowManager.BUG_WINDOW)
	else: WindowManager.main_window.find_child("Window").queue_free()
