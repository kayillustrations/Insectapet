extends Node

@export var isEmbed:bool = true
@onready var screen_size = DisplayServer.screen_get_size()
@onready var screen_rect = DisplayServer.screen_get_usable_rect().size

func _ready() -> void:
	WindowManager.anchor_dict = WindowManager.getScreenAnchors(screen_size,screen_size-screen_rect,Vector2(0,-10))
	
	if isEmbed:
		GameManager.isEmbed = true
		get_tree().change_scene_to_file("res://windows/embed.tscn")
	else:
		GameManager.isEmbed = false
		get_tree().change_scene_to_file("res://windows/desktop.tscn")
