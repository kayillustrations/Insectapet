extends Node2D

#PRELOADS
var obstacles_ground: Array = [
	preload("res://games/stick_sm.tscn"),
	preload("res://games/stick_m.tscn"),
	preload("res://games/stick_m_2.tscn"),
	preload("res://games/stick_l.tscn")
]
var obstacles_air: Array = [
	preload("res://games/leaf.tscn"),
	preload("res://games/leaf_2.tscn"),
	preload("res://games/leaf_3.tscn"),
	preload("res://games/web.tscn"),
]
var obstacle_spider = preload("res://games/spider.tscn")
var obstacles_generated: Array
var last_obs
var air_heights: Array

#VARS
const SPEED_START = 10
const SPEED_MAX = 25
const SPEED_MOD = 500

var bug: CharacterBody2D
var bug_start_pos = Vector2i(150,280)
var HUD
var score_label: Label
var highscore_label: Label
var start_label: RichTextLabel

var ground_spawn:Marker2D
var air_spawn:Marker2D
var delete_spawned:Marker2D

var score:int = 0
var difficulty:int
var highscore:int = 0
var speed:float

var has_been_config = false
var game_started:bool = false
var isPaused: bool = false

var up:bool = false
var down:bool = false
var left:bool = false
var right:bool = false

func Activated(b: bool):
	if !has_been_config:
		bug = $Bug
		HUD = $"../HUD"
		bug_start_pos = bug.position
		score_label = HUD.find_child("Score")
		highscore_label = HUD.find_child("Highscore")
		start_label = HUD.find_child("Start")
		air_spawn = $Air
		ground_spawn = $Stick
		delete_spawned = $Delete
		has_been_config = true
		highscore = GameSave.highscores["Dino"]
	visible = b
	new_game()
	

func new_game():
	#reset variables
	score = 0
	difficulty = 0
	
	#reset nodes
	bug.velocity = Vector2i.ZERO
	bug.position = bug_start_pos
	bug.animated_sprite.play("idle")
	speed = SPEED_START
	for i in obstacles_generated.size():
		obstacles_generated[i].queue_free()
	obstacles_generated.clear()
	isPaused = false
	game_started = false
	start_label.visible = true
	UpdateScore()

func _process(delta):
	if !visible:
		return
	if !game_started:
		$GroundParallax.autoscroll = Vector2.ZERO
		if up || Input.is_action_pressed("Up"):
			start_label.visible = false
			game_started = true
			Generate_Obj()
		return
	if isPaused: 
		$GroundParallax.autoscroll = Vector2.ZERO
		$Bug.animated_sprite.play("idle")
		return
	
	difficulty = score/SPEED_MOD
	if difficulty > SPEED_MAX-SPEED_START:
		difficulty = SPEED_MAX-SPEED_START
	
	speed = SPEED_START + difficulty

	$GroundParallax.autoscroll.x = speed * -20
	Generate_Obj()
	score += 1
	
	for i in obstacles_generated.size():
		if i == obstacles_generated.size():break
		obstacles_generated[i].position.x += $GroundParallax.autoscroll.x * delta
		if obstacles_generated[i].global_position.x < delete_spawned.global_position.x:
			obstacles_generated[i].queue_free()
			obstacles_generated.remove_at(i)
	
	if bug.position.x-50 <= delete_spawned.position.x:
		game_started = false
		get_parent().GameOver(score,highscore)
	
	UpdateScore()

func UpdateScore():
	score_label.text = str(score)
	if score > highscore:
		highscore_label.text = str(score)

func Generate_Obj():
	#ground obs
	if obstacles_generated.is_empty() || last_obs.global_position.x - randi()%400 < bug.global_position.x:
		var chosen_and_type = ChooseObs()
		last_obs = chosen_and_type[0].instantiate()
		if chosen_and_type[1]==obstacles_ground:
			ground_spawn.add_child(last_obs)
			last_obs.rotation = -randf_range(0,.5)
			last_obs.scale.x = randf_range(.5,.75)
			last_obs.scale.y = last_obs.scale.x
		else:
			air_spawn.add_child(last_obs)
			last_obs.rotation = randf_range(0,.5)
			last_obs.scale.x = randf_range(.5,.6)
			last_obs.scale.y = randf_range(.5,.6)
			last_obs.modulate = Exports.colors_green.pick_random()
		
		obstacles_generated.append(last_obs)
	#air obs
	pass

func ChooseObs():
	var type
	var chosen
	if difficulty < 3:
		type = [obstacles_ground,obstacles_air].pick_random()
		chosen = type[randi() % 3]
	elif difficulty < 6:
		type = [obstacles_ground,obstacles_air].pick_random()
		chosen = type.pick_random()
	else: 
		type = [obstacles_ground,obstacles_air,obstacle_spider].pick_random()
		if type == obstacle_spider:
			chosen = obstacle_spider
		else:
			chosen = type.pick_random()
	return [chosen,type]
