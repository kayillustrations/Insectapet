extends Control

@onready var dino_game = $DinoGame
@onready var happiness: Label = $HUD/GameOver/Panel/VBoxContainer/Happiness
@onready var energy: Label = $HUD/GameOver/Panel/VBoxContainer/Energy
@onready var game_over_audio: AudioStreamPlayer = $GameOver
@onready var music_toggle: CheckButton = $"HUD/Pause Screen/Panel/VBoxContainer/MusicToggle"

var current_game

func _ready() -> void:
	for i in %GameButtons.children.size():
		%GameButtons.children[i].connect("button_down",PressedButton.bind(%GameButtons.children[i].name,true))
		%GameButtons.children[i].connect("button_up",PressedButton.bind(%GameButtons.children[i].name,false))
	
	$"HUD/Pause Screen".visible = false
	$HUD/GameOver.visible = false
	dino_game.visible = false
	music_toggle.button_pressed = GameManager.isGameMusicOn
	#snake_game.visible = false

func DecideGame():
	if GameManager.current_bug.category == 0:
		current_game = dino_game
		%GameButtons.find_child("Left").disabled = true
		%GameButtons.find_child("Right").disabled = true
	elif GameManager.current_bug.category == 1:
		pass
		#snake

func ActivateGame(b:bool):
	%SubViewportContainer.visible = b
	visible = b
	%MainButtons.visible = !b
	%GameButtons.visible = b
	current_game.Activated(b)
	current_game.new_game()
	if b:
		if GameManager.isEmbed: 
			music_toggle.visible = false
		else: _on_music_toggle_toggled(GameManager.isGameMusicOn)
	else: $Music.stop()

func GameOver(score,highscore):
	$HUD/GameOver.visible = true
	game_over_audio.play()
	happiness.text = "Happiness Earned = " + str(score/100)
	energy.text = "Energy Lost = " + str(score/200)
	GameManager.EditStat("Happiness",-score/100)
	GameManager.EditStat("Energy",roundi(score/200))
	GameSave.highscores["Dino"] = highscore
	GameSave.SaveGame()

func PressedButton(button_name:String,b:bool):
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
			if b:
				$"HUD/Pause Screen".visible = !$"HUD/Pause Screen".visible
				current_game.isPaused = $"HUD/Pause Screen".visible
	pass

func _on_resume_pressed() -> void:
	$"HUD/Pause Screen".visible = false
	current_game.isPaused = false
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	dino_game.Activated(false)
	%MainButtons._on_play_toggled(false)
	$HUD/GameOver.visible = false
	$"HUD/Pause Screen".visible = false
	pass # Replace with function body.

func _on_restart_pressed() -> void:
	$HUD/GameOver.visible = false
	current_game.new_game()
	pass # Replace with function body.

func _on_music_toggle_toggled(toggled_on: bool) -> void:
	if !visible: return
	$Music.playing = toggled_on
	GameManager.isGameMusicOn = toggled_on
	pass # Replace with function body.
