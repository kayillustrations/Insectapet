extends ColorRect


func _ready() -> void:
	for i in %GameButtons.children.size():
		%GameButtons.children[i].connect("pressed",PressedButton.bind(%GameButtons.children[i].name))
	visible=false
	pass

func ActivateGame(b:bool):
	%SubViewportContainer.visible = b
	visible = b
	%MainButtons.visible = !b
	%GameButtons.visible = b
	pass

func PressedButton(button_name:String):
	print(button_name)
	match button_name:
		"Left":
			pass
		"Right":
			pass
		"Up":
			pass
		"Down":
			pass
		"Pause":
			%MainButtons._on_play_toggled(false)
	pass
