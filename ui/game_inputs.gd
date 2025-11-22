extends ColorRect

const DINO_GAME = preload("res://games/dino_game.tscn")

var current_game

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
	if b == true:
		var temp_game = DINO_GAME.instantiate()
		add_child(temp_game)
		current_game = temp_game #TODO: depending on bug category in future
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
