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
const BUG_START_POS = Vector2i(-200,0)
const CAM_START_POS = Vector2i.ZERO
const SPEED_START = 10
const SPEED_MAX = 25
const SPEED_MOD = 5000

var bug
var HUD
var score_label: Label
var highscore_label: Label
var start_label: RichTextLabel

var score:int = 0
var highschore:int = 0
var speed:float

var has_been_config = false
var game_started:bool = false

func _ready() -> void:
	$ParallaxBackground.visible = false

func Activated():
	if !has_been_config:
		bug = $Bug
		HUD = $"../HUD"
		score_label = HUD.find_child("Score")
		highscore_label = HUD.find_child("Highscore")
		start_label = HUD.find_child("Start")
		has_been_config = true
	visible = true
	$ParallaxBackground.visible = true
	new_game()

func new_game():
	#reset variables
	score = 0
	#highscore = GameManager
	
	#reset nodes
	bug.position = BUG_START_POS
	bug.velocity = Vector2i.ZERO
	speed = SPEED_START
	$Camera2D.position = CAM_START_POS
	
	game_started = false
	start_label.visible = true
	#Generate_Obj()

func _process(delta):
	if !visible:
		return
	if !game_started:
		if Input.is_anything_pressed():
			start_label.visible = false
		return
	speed = SPEED_START + (score/SPEED_MOD)
	if speed > SPEED_MAX:
		speed = SPEED_MAX

	bug.position.x += speed
	$Camera2D.position.x += speed

	score += 1
	UpdateScore()

func UpdateScore():
	score_label.text = "Distance: "
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
