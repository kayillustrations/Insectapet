extends Node

@export var isEmbed:bool = true
@onready var screen_size = DisplayServer.screen_get_size()
@onready var screen_rect = DisplayServer.screen_get_usable_rect().size

func _ready() -> void:
	WindowManager.anchor_dict = WindowManager.getScreenAnchors(screen_size,screen_size-screen_rect,Vector2(0,-10))
	isEmbed = CheckForOverride()
	if isEmbed:
		GameManager.isEmbed = true
		get_tree().change_scene_to_file("res://windows/embed.tscn")
	else:
		GameManager.isEmbed = false
		get_tree().change_scene_to_file("res://windows/mini_habitat.tscn")

func CheckForOverride():
	if FileAccess.file_exists("res://override.cfg"):
		return false
	else: return true
