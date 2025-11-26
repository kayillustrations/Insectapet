extends HabitatButtons

@onready var clean: TextureButton = $Clean
@onready var eat: TextureButton = $Hunger
@onready var info: TextureButton = $Info
@onready var play: TextureButton = $Happiness
@onready var shop: TextureButton = $Shop

func _on_clean_toggled(toggled_on: bool) -> void:
	if toggled_on:
		UnToggleAllOthers(clean)
		ActivateScreen(%Cleaning)
	else:
		ActivateScreen(null)
	pass # Replace with function body.

func _on_eat_toggled(toggled_on: bool) -> void:
	if toggled_on:
		UnToggleAllOthers(eat)
		ActivateScreen(%Feeding)
	else:
		ActivateScreen(null)
	pass # Replace with function body.

func _on_info_toggled(toggled_on: bool) -> void:
	if toggled_on:
		UnToggleAllOthers(info)
		ActivateScreen(%BugInfo)
	else:
		ActivateScreen(null)

func _on_play_toggled(toggled_on: bool) -> void:
	if toggled_on:
		UnToggleAllOthers(play)
		ActivateScreen(%Game)
	else:
		ActivateScreen(null)
		$Play.button_pressed = toggled_on
	%Game.ActivateGame(toggled_on)
	
	pass # Replace with function body.

func _on_shop_toggled(toggled_on: bool) -> void:
	if toggled_on:
		UnToggleAllOthers(shop)
		ActivateScreen(%Shop)
	else:
		ActivateScreen(null)
	pass # Replace with function body.

func ActivateScreen(screen):
	if current_panel != null: 
		current_panel.visible = false
		current_panel = null
	if screen != null:
		screen.visible = true
		current_panel = screen
	
	if current_panel == null:
		%SubViewportContainer.visible = false
	else: 
		%SubViewportContainer.visible = true
