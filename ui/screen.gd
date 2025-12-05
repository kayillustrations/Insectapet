extends Node

@onready var button_click: AudioStreamPlayer = %Audio/ButtonClick
@onready var button_hover: AudioStreamPlayer = %Audio/ButtonHover


var all_buttons
var testbutton: Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	all_buttons = find_children("*","Button")
	ButtonConfig()

func ButtonConfig():
	if all_buttons[0].is_connected("mouse_entered",PlayButtonAudio):
		return
	for i in all_buttons.size():
		all_buttons[i].connect("mouse_entered",PlayButtonAudio.bind(false))
		all_buttons[i].connect("pressed",PlayButtonAudio.bind(true))

func PlayButtonAudio(isPressed:bool):
	if isPressed:button_click.play()
	else:button_hover.play()
