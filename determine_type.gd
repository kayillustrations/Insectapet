extends Node

@export var isEmbed:bool = true

func _ready() -> void:
	if isEmbed:
		GameManager.isEmbed = true
		get_tree().change_scene_to_file("res://windows/embed.tscn")
	else:
		get_tree().change_scene_to_file("res://windows/desktop.tscn")
