extends Node

enum NeedType {WATER,UP,POTTY,BREAK}
signal need_timeout(need_button)

var need_queue:Array = []

var default_times: Array[float]=[.1,65,95,115]

var snooze_time: float = 2
var current_toolbar_position: Vector2
