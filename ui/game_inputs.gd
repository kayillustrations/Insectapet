extends Control

@onready var dino_game = $DinoGame
var current_game

func _ready() -> void:
	for i in %GameButtons.children.size():
		%GameButtons.children[i].connect("button_down",PressedButton.bind(%GameButtons.children[i].name,true))
		%GameButtons.children[i].connect("button_up",PressedButton.bind(%GameButtons.children[i].name,false))
	dino_game.visible = false
	#snake_game.visible = false
	if GameManager.current_bug.category == 0:
		current_game = dino_game
		%GameButtons.find_child("Left").disabled = true
		%GameButtons.find_child("Right").disabled = true
	elif GameManager.current_bug.category == 1:
		pass
		#snake
	pass

func ActivateGame(b:bool):
	%SubViewportContainer.visible = b
	visible = b
	%MainButtons.visible = !b
	%GameButtons.visible = b
	current_game.Activated(b)
	current_game.new_game()

func PressedButton(button_name:String,b:bool):
	print(button_name)
	match button_name:
		"Left":
			current_game.left = b
			pass
		"Right":
			current_game.right = b
			pass
		"Up":
			current_game.up = b
			pass
		"Down":
			current_game.down = b
			pass
		"Pause":
			dino_game.Activated(false)
			%MainButtons._on_play_toggled(false)
	pass
