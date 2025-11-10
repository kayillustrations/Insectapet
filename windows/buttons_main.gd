extends HabitatButtons

@onready var clean: TextureButton = $Clean
@onready var eat: TextureButton = $Eat
@onready var info: TextureButton = $Info
@onready var play: TextureButton = $Play
@onready var shop: TextureButton = $Shop

func _on_clean_toggled(toggled_on: bool) -> void:
	
	pass # Replace with function body.

func _on_eat_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.

func _on_info_toggled(toggled_on: bool) -> void:
	%ScreenSprite.visible = toggled_on
	%BugInfo.visible = toggled_on

func _on_play_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.

func _on_shop_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
