extends Node

const BUG_START_POS
const CAM_START_POS
const SPEED_START = 10
const SPEED_MAX = 25

@onready var bug = $Bug
@onready var score_label = $HUD.find_child("Score")
@onready var highscore_label = $HUD.find_child("Highscore")

var score:int
var speed:float

var screen_size: Vector2i
var game_running = false

func _ready():
    pass

func new_game():
    #reset variables
    score = 0

    #reset nodes
    bug.position = BUG_START_POS
    bug.velocity = Vector2i.ZERO
    $Camera2D.position = CAM_START_POS
    $Ground.position = Vector2i.ZERO
    
    game_running = false
    #HUD.find_node("Start").visible = true

func _process(delta):
    if !game_running:
        #if any button pressed
            #HUD.find_node("Start").visible = false
        return
    speed = SPEED_START

    bug.position.x += speed
    $Camera2D.position.x += speed

    score += 1
    update_score()

func update_score():
    score.text = "Distance: ",str(score)
    if score > highscore:
        highscore_label.text = str(score)