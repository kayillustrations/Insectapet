extends WindowBase


const INSECTAPET_LAMP = preload("res://art/habitat/insectapet_lamp.png")
const INSECTAPET_LAMP_DARK = preload("res://art/habitat/insectapet_lamp_dark.png")

const LEAF_SELFMODULATE = Color (.75,1,1,1)

@onready var all_screens: Array = %Screens.get_children()
@onready var bug_info: Control = %BugInfo

@export_enum("IDLE","MOVING","CROUCHING","JUMPING") var current_state:int = 0
@onready var current_spot:float = %PathFollow2D.progress_ratio

@onready var bug_animator: AnimationPlayer = %Bug.get_child(0).find_child("AnimationPlayer")
var isMoving = false
var target_location:float
var target_direction:int

func _ready() -> void:
	#screens set
	current_state = 0
	%SubViewportContainer.visible = false
	for i in all_screens.size():
		all_screens[i].visible = false
	GameManager.UpdateHabitat.connect(HabitatChecks)
	HabitatChecks()
	%PathFollow2D.progress_ratio = GameManager.current_path_location
	pass

func _physics_process(delta: float) -> void:
	if isMoving:
		if target_location == snappedf(%PathFollow2D.progress_ratio,.01):
			bug_animator.play("idle")
			$"State Timer".start(5)
			isMoving = false
			GameManager.current_path_location = target_location
			GameSave.SaveGame()
		else: %PathFollow2D.progress_ratio += .01*target_direction*delta

func HabitatChecks():
	if !GameManager.habitat_stats["isLampOn"]:
		_on_light_toggled(true)
	%ReleaseBug.disabled = GameManager.isBugReleased
	%FogControl.EditFog(GameManager.habitat_stats["Cleanliness"])
	%FoodIn.texture = GameManager.food_given
	var temp_hydration = GameManager.habitat_stats["Hydration"]-50
	if temp_hydration < 25: 
		%"Healthy Leaves".self_modulate.r = 1 - temp_hydration/100
		%"Healthy Leaves".visible = true
		%"DryLeaves".visible = false
	elif temp_hydration < 0: 
		%"Healthy Leaves".visible = false
		%"DryLeaves".visible = true
	else: 
		%"Healthy Leaves".self_modulate = LEAF_SELFMODULATE
		%"Healthy Leaves".visible = true
		%"DryLeaves".visible = false

func ChangeState(new_state):
	if current_state == 2: #uncrouch
		bug_animator.play("crouch",-1,-1,true)
		await bug_animator.animation_finished

	match new_state:
		0:#idle
			print("idle")
			bug_animator.play("idle")
			$"State Timer".start(5)
			pass
		1:#moving
			print("moving")
			bug_animator.play("move")
			#pick location and move
			target_location = snappedf(randf(),.01)
			var random_direction = randi_range(0,1)
			match random_direction:
				0:
					target_direction = -1
					%Bug.scale = Vector2(1,1)
				1:
					target_direction = 1
					%Bug.scale = Vector2(-1,1)
			isMoving = true
			
		2:#crouching
			print("crouching")
			bug_animator.play("crouch")
			$"State Timer".start(5)
			pass
	current_state = new_state

func _on_x_pressed() -> void:
	GameManager.current_path_location = %PathFollow2D.progress_ratio
	WindowManager.main_window._on_texture_button_toggled(false)
	pass # Replace with function body.

func _on_bug_pressed() -> void:
	Utils.Error(%Control,"Coming Soon")
	return
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
	%LightButton.button_pressed = toggled_on
	GameManager.habitat_stats["isLampOn"] = !toggled_on
	GameSave.SaveGame()
	pass # Replace with function body.


func _on_state_timer_timeout() -> void:
	var temp_state = randi() % 3
	if temp_state != current_state:
		ChangeState(temp_state)
	else:
		$"State Timer".start(5)
