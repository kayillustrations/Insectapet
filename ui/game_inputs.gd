extends Control

@onready var dino_game = $DinoGame
var current_game

func _ready() -> void:
	for i in %GameButtons.children.size():
		%GameButtons.children[i].connect("pressed",PressedButton.bind(%GameButtons.children[i].name))
	dino_game.visible = false
	#snake_game.visible = false
	pass

func ActivateGame(b:bool):
	%SubViewportContainer.visible = b
	visible = b
	%MainButtons.visible = !b
	%GameButtons.visible = b
	if GameManager.current_bug.category == 0:
		dino_game.Activated()
	elif GameManager.current_bug.category == 1:
		#snake
		pass
	#else: 
		#current_game.queue_free()
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
