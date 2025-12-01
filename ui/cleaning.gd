extends Control

@export var textures: Array[Texture2D]

var currently_holding

func _on_bottle_pressed() -> void:
	currently_holding = %Bottle
	%ActivateBug.disabled = true
	%Bottle.active = true
	SharedActions()
	%SprayHere.visible = true
	pass # Replace with function body.
	
func _on_cotton_pressed() -> void:
	%FogControl.EditFog(GameManager.habitat_stats["Cleanliness"])
	currently_holding = %Cotton
	SharedActions()
	%FogControl.active = true
	pass # Replace with function body.

func SharedActions():
	%MainButtons.ActivateAllButtons(false)
	%MainButtons.clean.button_pressed = false
	currently_holding.visible = true
	pass


func _on_jar_pressed() -> void:
	if GameManager.current_stats["Stage"] < 3:
		Utils.Error(self,"Cannot Release Yet")
	else:
		Utils.Error(self,"Coming Soon")
		print("Release")
	pass # Replace with function body.
