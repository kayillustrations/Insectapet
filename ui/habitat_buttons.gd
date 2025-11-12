extends HBoxContainer
class_name HabitatButtons

var children
var current_panel
var current_button

func _enter_tree() -> void:
	children = get_children()

func PressButton(button:TextureButton):
	current_button = button
	print(button)

func ActivateAllButtons(activate:bool):
	for i in children.size():
		ActivateButton(children[i],activate)

func ActivateButton(button,activate:bool):
	button.disabled = !activate

func UnToggleAllOthers(current_button:TextureButton):
	for i in children.size():
		if children[i] != current_button:
			children[i].button_pressed = false
