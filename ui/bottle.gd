extends HoldingItem

var active: bool = false

func Clean():
	print("CLEAN")
	%SprayHere.visible = false
	active = false
	%Sparkles.emitting = true
	await %Sparkles.finished
	%MainButtons.ActivateAllButtons(true)
	%MainButtons.clean.button_pressed = false
	%Cleaning.currently_holding.visible = false
	%ReleaseBug.disabled = false
	GameManager.habitat_stats["Hydration"] = 100
	GameSave.SaveGame()

func EditWater():
	var wetness = GameManager.habitat_stats["Hydration"]
	if wetness < 33: $ProgressBar.value = 3
	elif wetness < 66: $ProgressBar.value = 2
	else: $ProgressBar.value = 1

func _on_visibility_changed() -> void:
	if active: 
		EditWater()
	pass # Replace with function body.

func _on_button_pressed() -> void:
	$ProgressBar.value -= 1
	if $ProgressBar.value == 0:
		Clean()
	pass # Replace with function body.
