extends Node

const BUG_WINDOW = preload("res://windows/bug_window.tscn")
const FULL_HABITAT = preload("res://windows/full_habitat.tscn")

var screen_size

var title_size: int = 40
var main_window: WindowBase

var anchor_dict: Dictionary = {
	"TopL" : Vector2.ZERO,
	"TopR" : Vector2.ZERO,
	"MidL" : Vector2.ZERO,
	"MidR" : Vector2.ZERO,
	"BotL" : Vector2.ZERO,
	"BotR" : Vector2.ZERO,
	"Center": Vector2.ZERO
	}

func _init() -> void:
	screen_size = DisplayServer.screen_get_usable_rect().size

func getScreenAnchors(screen_size,toolbar_size,toolbar_offset):
	var temp_dict:Dictionary = {
		"TopL" : Vector2 (0,title_size),
		"TopR" : Vector2 (screen_size.x-toolbar_size.x,title_size) - toolbar_offset,
		"MidL" : Vector2 (0,screen_size.y/2 - 100),
		"MidR" : Vector2 (screen_size.x-toolbar_size.x,screen_size.y/2 - 100) - toolbar_offset,
		"BotL" : Vector2 (0,screen_size.y-toolbar_size.y),
		"BotR" : Vector2 (screen_size.x-toolbar_size.x,screen_size.y-toolbar_size.y) - toolbar_offset,
		"Center": Vector2(screen_size/2)
	}
	return temp_dict

func setWindowPosition(window,position):
	var temp: Vector2
	if typeof(position) == TYPE_STRING:
		temp = anchor_dict[position]
	else: temp = position
	window.SetPosition(temp)
