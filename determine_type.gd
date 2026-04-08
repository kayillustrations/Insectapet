extends Node

@export var isEmbed:bool = true
@onready var screen_size = DisplayServer.screen_get_size()
@onready var screen_rect = DisplayServer.screen_get_usable_rect().size

func _ready() -> void:
	print(screen_size)
	WindowManager.anchor_dict = WindowManager.getScreenAnchors(screen_size,Vector2(0,0),Vector2(0,0))
	isEmbed = CheckForOverride()
	if isEmbed:
		GameManager.isEmbed = true
		get_tree().change_scene_to_file("res://windows/embed.tscn")
	else:
		GameManager.isEmbed = false
		get_window().min_size = Vector2(1,1)
		get_window().reset_size()
		get_window().size_changed.emit()
		get_tree().change_scene_to_file("res://windows/mini_habitat.tscn")

func CheckForOverride():
	if FileAccess.file_exists("res://override.cfg"):
		return false
	else: return true
