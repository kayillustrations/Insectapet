extends Node2D

const BUG_START_POS = Vector2i(90,300)
const CAM_START_POS = Vector2i.ZERO
const SPEED_START = 10
const SPEED_MAX = 25

@onready var bug = $Bug
@onready var HUD = $"../HUD"
@onready var score_label = HUD.find_child("Score")
@onready var highscore_label = HUD.find_child("Highscore")
@onready var start_label = HUD.find_child("Start")

var score:int = 0
var highschore:int = 0
var speed:float

var game_started:bool = false

func _ready():
	
	new_game()
	pass

func new_game():
	#reset variables
	score = 0
	#highscore = GameManage
	#reset nodes
	bug.position = BUG_START_POS
	bug.velocity = Vector2i.ZERO
	$Camera2D.position = CAM_START_POS
	
	game_started = false
	start_label.visible = true

func _process(delta):
	if !game_started:
		if Input.is_anything_pressed():
			start_label.visible = false
		return
	speed = SPEED_START

	bug.position.x += speed
	$Camera2D.position.x += speed

	score += 1
	UpdateScore()

func UpdateScore():
	score_label.text = "Distance: "
	if score > highschore:
		highscore_label.text = str(score)
