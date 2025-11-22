extends WindowBase


const INSECTAPET_LAMP = preload("res://art/habitat/insectapet_lamp.png")
const INSECTAPET_LAMP_DARK = preload("res://art/habitat/insectapet_lamp_dark.png")

const LEAVES_DRY = preload("res://art/leaves_dry.png")
const LEAVES_HEALTHY = preload("res://art/leaves_healthy.png")

@onready var all_screens: Array = %Screens.get_children()
@onready var bug_info: Control = %BugInfo

@export_enum("IDLE","MOVING","CROUCHING","JUMPING") var current_state:int = 0
@onready var current_spot:float = %PathFollow2D.progress_ratio

func _ready() -> void:
	#screens set
	current_state = 0
	%SubViewportContainer.visible = false
	for i in all_screens.size():
		all_screens[i].visible = false
	_on_light_toggled(GameManager.habitat_stats["isLampOn"])
	GameManager.UpdateHabitat.connect(HabitatChecks)
	HabitatChecks()
	pass

func HabitatChecks():
	%ReleaseBug.disabled = GameManager.isBugReleased
	%FogControl.EditFog(GameManager.habitat_stats["Cleanliness"])
	%FoodIn.texture = GameManager.food_given
	if GameManager.habitat_stats["Hydration"] < 50: 
		%Leaves.texture = LEAVES_DRY
	else: 
		%Leaves.texture = LEAVES_HEALTHY

func ChangeState():
	match current_state:
		0:#idle
			print("idle")
			%Bug.get_child(0).find_child("AnimationPlayer").current_animation = "idle"
			$"State Timer".start(5)
			pass
		1:#moving
			print("moving")
			#pick location and move
			var random_spot = randf()
			var spot_maths = abs(random_spot-current_spot)
			if random_spot < current_spot: %Bug.scale = Vector2(1,1)
			else: %Bug.scale = Vector2(-1,1)
			var tween:Tween = get_tree().create_tween()
			tween.tween_property(%PathFollow2D,"progress_ratio",random_spot,10*spot_maths)
			await tween.finished
			#once stopped
			%Bug.get_child(0).find_child("AnimationPlayer").current_animation = "idle"
			$"State Timer".start(5)
			pass
		2:#crouching
			print("crouching")
			%Bug.get_child(0).find_child("AnimationPlayer").current_animation = "idle"
			$"State Timer".start(5)
			pass

func _on_x_pressed() -> void:
	WindowManager.main_window._on_texture_button_toggled(false)
	pass # Replace with function body.

func _on_bug_pressed() -> void:
	GameManager.ReleaseBug(true)
	%ReleaseBug.disabled = true
	pass # Replace with function body.

func _on_light_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		%Lamp.texture = INSECTAPET_LAMP
		%Dark.visible = false
	else:
		%Lamp.texture = INSECTAPET_LAMP_DARK
		%Dark.visible = true
	GameManager.habitat_stats["isLampOn"] = toggled_on
	%LightButton.button_pressed = toggled_on
	GameSave.SaveGame()
	pass # Replace with function body.


func _on_state_timer_timeout() -> void:
	var temp_state = randi() % 3
	if temp_state != current_state:
		current_state = temp_state
		ChangeState()
	$"State Timer".start(5)
