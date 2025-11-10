extends WindowBase

const INSECTAPET_LAMP = preload("res://art/insectapet_lamp.png")
const INSECTAPET_LAMP_DARK = preload("res://art/insectapet_lamp_dark.png")

@onready var screen_sprite: Sprite2D = $Shape/UI/Screen/ScreenSprite
@onready var all_screens: Array = $ScreenViewport/ColorRect.get_children()
@onready var bug_info: Control = %BugInfo


func _ready() -> void:
	#screens set
	%ScreenSprite.visible = false
	for i in all_screens.size():
		ActivateScreen(all_screens[i],false)
	
	#checks
	%Dark.visible = false
	%Bug.disabled = GameManager.isBugReleased
	pass

func _on_x_pressed() -> void:
	WindowManager.main_window._on_texture_button_toggled(false)
	pass # Replace with function body.

func _on_bug_pressed() -> void:
	GameManager.ReleaseBug(true)
	%Bug.disabled = true
	pass # Replace with function body.

func _on_light_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		%Lamp.texture = INSECTAPET_LAMP
		%Dark.visible = false
	else:
		%Lamp.texture = INSECTAPET_LAMP_DARK
		%Dark.visible = true
	pass # Replace with function body.

func ActivateScreen(screen,isOn:bool):
	screen_sprite.visible = isOn
	screen.visible = isOn
