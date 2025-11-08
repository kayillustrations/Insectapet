extends WindowBase

const INSECTAPET_LAMP = preload("res://art/insectapet_lamp.png")
const INSECTAPET_LAMP_DARK = preload("res://art/insectapet_lamp_dark.png")


func _enter_tree() -> void:
	%Bug.disabled = GameManager.isBugReleased
	#check if light is off
	%Dark.visible = false
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
