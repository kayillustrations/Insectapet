extends Node2D

#PRELOADS
#var ground_obs1 = preload()
#var ground_obs2 = preload()
#var ground_obs3 = preload()
#var air_obs = preload()
var obstacles_ground: Array = []
var obstacles_generated: Array
var last_obs
var air_heights: Array

#VARS
const SPEED_START = 10
const SPEED_MAX = 25
const SPEED_MOD = 5000

var bug: CharacterBody2D
var bug_start_pos = Vector2i(150,280)
var HUD
var score_label: Label
var highscore_label: Label
var start_label: RichTextLabel

var score:int = 0
var highschore:int = 0
var speed:float

var has_been_config = false
var game_started:bool = false

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
		has_been_config = true
	visible = b
	new_game()
	

func new_game():
	#reset variables
	score = 0
	#highscore = GameManager
	
	#reset nodes
	bug.velocity = Vector2i.ZERO
	bug.position = bug_start_pos
	speed = SPEED_START
	
	game_started = false
	start_label.visible = true
	#Generate_Obj()

func _process(delta):
	if !visible:
		return
	if !game_started:
		$GroundParallax.autoscroll = Vector2.ZERO
		if up || Input.is_action_pressed("Up"):
			start_label.visible = false
			game_started = true

		return
	
	speed = SPEED_START + (score/SPEED_MOD)
	if speed > SPEED_MAX:
		speed = SPEED_MAX

	$GroundParallax.autoscroll.x = speed * -20
	
	score += 1
	UpdateScore()

func UpdateScore():
	score_label.text = str(score)
	if score > highschore:
		highscore_label.text = str(score)

func Generate_Obj():
	#ground obs
	if obstacles_generated.is_empty():
		var chosen = obstacles_ground[randi() % obstacles_ground.size()]
		var obs = chosen.instantiate()
		last_obs = obs
		obstacles_generated.append(obs)
	#air obs
	pass
