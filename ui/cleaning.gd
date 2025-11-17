extends Control

@export var textures: Array[Texture2D]

var currently_holding

func _on_bottle_pressed() -> void:
	currently_holding = %Bottle
	%ReleaseBug.disabled = true
	%Bottle.active = true
	SharedActions()
	%SprayHere.visible = true
	pass # Replace with function body.
	
func _on_cotton_pressed() -> void:
	currently_holding = %Cotton
	SharedActions()
	%FogControl.active = true
	pass # Replace with function body.

func SharedActions():
	%MainButtons._on_clean_toggled(false)
	%MainButtons.ActivateAllButtons(false)
	currently_holding.visible = true
	pass
