extends HBoxContainer
class_name HabitatButtons

var children

func _enter_tree() -> void:
	children = get_children()
	ConnectChildren()

func ConnectChildren():
	for i in children.size():
		children[i].connect("pressed",UnToggleAllOthers.bind(children[i]))
	pass

func ActivateAll(activate:bool):
	for i in children.size():
		ActivateButton(children[i],activate)

func ActivateButton(button,activate:bool):
	button.disabled = !activate

func UnToggleAllOthers(current_button):
	for i in children.size():
		if children[i] != current_button:
			children[i].button_pressed = false
