extends Node2D

const SIZE = Vector2(2000,1050)

@export var active: bool = false

@onready var clean_sound: AudioStreamPlayer = %Audio/Clean


var click_pos: Array
var dist_traveled

var cleanliness_maths: float

var prev_pos
var current_pos

func _input(event: InputEvent) -> void:
	if !active || not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		clean_sound.playing = false
		return
	var mouse_pos = get_local_mouse_position()
	if abs(mouse_pos.x) > SIZE.x/2:return
	if abs(mouse_pos.y) > SIZE.y/2 + get_parent().position.y:return #TODO RETURN HERE
	if prev_pos == null:
		prev_pos = mouse_pos
		dist_traveled = Vector2.ZERO
	current_pos = mouse_pos
	dist_traveled += abs(current_pos - prev_pos)
	prev_pos = current_pos
	CleanFog()

func CleanFog():
	if clean_sound.playing == false:
		clean_sound.playing = true
	print(clean_sound.playing)
	var min_value = min(dist_traveled.x,dist_traveled.y)
	min_value *= .0002
	min_value += 1-cleanliness_maths
	#print(min_value)
	if min_value >= 1:
		print("CLEAN")
		active = false
		%Sparkles.emitting = true
		%Cleaning.currently_holding.visible = false
		await %Sparkles.finished
		%MainButtons.ActivateAllButtons(true)
		%MainButtons.clean.button_pressed = false
		GameManager.habitat_stats["Cleanliness"] = 100
		#GameManager.UpdateHabitat.emit()
		GameSave.SaveGame()
		return
	var tween:Tween = create_tween()
	tween.tween_property($Fog,"modulate",Color(1,1,1,1-min_value),0)

func EditFog(cleanliness:int):
	if cleanliness == 100: $Fog.modulate = Color.TRANSPARENT
	cleanliness_maths = (100-cleanliness)*.01
	$Fog.modulate =Color(1,1,1,cleanliness_maths)
