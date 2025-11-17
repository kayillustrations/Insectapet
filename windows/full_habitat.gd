extends WindowBase

const INSECTAPET_LAMP = preload("res://art/insectapet_lamp.png")
const INSECTAPET_LAMP_DARK = preload("res://art/insectapet_lamp_dark.png")

@onready var all_screens: Array = %Screens.get_children()
@onready var bug_info: Control = %BugInfo

func _ready() -> void:
	#screens set
	%SubViewportContainer.visible = false
	for i in all_screens.size():
		all_screens[i].visible = false
	
	HabitatChecks()
	pass

func HabitatChecks():
	_on_light_toggled(GameManager.habitat_stats["isLampOn"])
	%ReleaseBug.disabled = GameManager.isBugReleased
	%FogControl.EditFog(GameManager.habitat_stats["Cleanliness"])

func _on_x_pressed() -> void:
	WindowManager.main_window._on_texture_button_toggled(false)
	pass # Replace with function body.

func _on_bug_pressed() -> void:
	GameManager.ReleaseBug(true)
	%ReleaseBug.disabled = true
	pass # Replace with function body.

func _on_light_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		%Lamp.texture = INSECTAPET_LAMP
		%Dark.visible = false
	else:
		%Lamp.texture = INSECTAPET_LAMP_DARK
		%Dark.visible = true
	GameManager.habitat_stats["isLampOn"] = !toggled_on
	%LightButton.button_pressed = toggled_on
	pass # Replace with function body.
