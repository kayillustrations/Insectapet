extends Node2D

const INSECTAPET_LAMP = preload("res://art/habitat/insectapet_lamp.png")
const INSECTAPET_LAMP_DARK = preload("res://art/habitat/insectapet_lamp_dark.png")

const LEAF_SELFMODULATE = Color (.75,1,1,1)

@onready var all_screens: Array = %Screens.get_children()
@onready var bug_info: Control = %BugInfo

@export_enum("IDLE","MOVING","CROUCHING","JUMPING") var current_state:int = 0
@onready var current_spot:float = %PathFollow2D.progress_ratio

var bug_animator: AnimationPlayer
var isMoving = false
var target_location:float
var target_direction:int

func _ready() -> void:
	GameManager.habitat_window = self
	$ColorRect2.visible = GameManager.isEmbed
	$Shape/Control/ColorRect.visible = !GameManager.isEmbed
	#screens set
	%SubViewportContainer.visible = false
	for i in all_screens.size():
		all_screens[i].visible = false
	
	GameManager.UpdateHabitat.connect(HabitatChecks)
	GameManager.StatWarning.connect(StatWarning)
	%ActivateBug.disabled = GameManager.isBugWindow
	
	ConfigBug()
	%Game.DecideGame()
	HabitatChecks()
	TextureButtonConfig()
	pass

func _physics_process(delta: float) -> void:
	if isMoving:
		if target_location == snappedf(%PathFollow2D.progress_ratio,.01):
			ChangeState(0)
			isMoving = false
			GameManager.current_path_location = target_location
			GameSave.SaveGame()
		else: %PathFollow2D.progress_ratio += .01*target_direction*delta

func NewBugScreen(activate:bool):
	GameManager.isNewBug = activate
	%Bug.visible = !activate
	%GainBug.visible = activate
	%MainButtons.ActivateAllButtons(!activate)
	pass

func ConfigBug():
	%Bug.add_child(GameManager.current_bug.stages[GameManager.current_stats["Stage"]].instantiate())
	bug_animator = %Bug.get_child(0).find_child("AnimationPlayer")
	if GameSave.bug_info["bug_color"] == Color.WHITE:
		var rand_color =[Exports.colors_green,Exports.colors_orange].pick_random()
		GameSave.bug_info["bug_color"] = rand_color.pick_random()
		NewBugScreen(true)
	else: 
		NewBugScreen(false)
	ChangeState(1)
	#if GameManager.current_stats["Stage"] < 3:
		#%Cleaning.find_child("Jar").disabled = true
	#else:
		#%Cleaning.find_child("Jar").disabled = false
	if GameManager.current_stats["XP"] == 100 && GameManager.current_stats["Stage"] < 3:
		StatWarning("XP",true)
	%Bug.modulate = GameSave.bug_info["bug_color"]
	Exports.LifeSpanTimer()
	GameSave.SaveGame()
	%BugInfo.ConfigInfo()
	pass

func HabitatChecks():
	if !GameManager.habitat_stats["isLampOn"]:
		_on_light_toggled(true)
	%FogControl.EditFog(GameManager.habitat_stats["Cleanliness"])
	%Feeding.UpdateFood()
	var temp_hydration = GameManager.habitat_stats["Hydration"]-50
	if temp_hydration < 25: 
		%"Healthy Leaves".self_modulate.r = float(1- (temp_hydration*.01))
		%"Healthy Leaves".visible = true
		%"DryLeaves".visible = false
	elif temp_hydration < 0: 
		%"Healthy Leaves".visible = false
		%"DryLeaves".visible = true
	else: 
		%"Healthy Leaves".self_modulate = LEAF_SELFMODULATE
		%"Healthy Leaves".visible = true
		%"DryLeaves".visible = false
	$Shape/Control/UI/MainButtons/Clean/Warning.visible = GameManager.habitat_warning

func StatWarning(stat:String,activate:bool):
	match stat:
		"Happiness": 
			%MainButtons/Happiness/Warning.visible = activate
		"Hunger":
			%MainButtons/Hunger/Warning.visible = activate
		"Energy":
			%LightButton/Warning.visible = activate
		"XP":
			%MainButtons/Info/Evolve.visible = activate
			if activate:
				$Evolve.play()
	pass

func ChangeState(new_state):
	if GameManager.current_stats["Stage"] == 0:
		%PathFollow2D.progress_ratio = 0
		$"State Timer".stop()
		bug_animator.play("idle")
		return
	if current_state == 2: #uncrouch
		bug_animator.play("crouch",-1,-1,true)
		await bug_animator.animation_finished

	match new_state:
		0:#idle
			GameManager.current_path_location = %PathFollow2D.progress_ratio
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

func _on_bug_window_pressed() -> void:
	Utils.Error(%Control,"Coming Soon")
	return
	GameManager.SpawnBugWindow(true)
	%ActivateBug.disabled = true
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

func TextureButtonConfig():
	var buttons = find_children("","TextureButton",true)
	if buttons[0].button_down.is_connected(PlayTextureButtonAudio):
		return
	for i in buttons.size():
		buttons[i].connect("toggled",PlayTextureButtonAudio)

func PlayTextureButtonAudio(pressed:bool):
	if pressed:$TextureButtonClick.play()
	else:$TextureButtonUnClick.play()

func _on_oh_pressed() -> void:
	#evolve bug animation
	GameSave.SaveGame()
	%MainButtons/Info/Evolve.visible = false
	GameManager.current_stats["Stage"] += 1
	if GameManager.current_stats["Stage"] < 3:
		GameManager.current_stats["XP"] = 0
		$Reveal.play()
	print(GameManager.current_stats["Stage"])
	%Bug.get_child(0).queue_free()
	ConfigBug()
	pass # Replace with function body.
