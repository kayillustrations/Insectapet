extends CharacterBody2D

const GRAVITY: int = 4000
const JUMP_SPEED: int = -1100
@onready var animated_sprite : AnimatedSprite2D = self.find_child("AnimatedSprite2D")

@onready var parent = get_parent()

var isJumping:bool = false

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	$RunCollider.disabled = false
	if !parent.game_started:
		return
	if parent.up || Input.is_action_pressed("Up"):
		Up()
	elif parent.down || Input.is_action_pressed("Down"):
		Down()
	else:
		animated_sprite.animation = "move"
		$"../Label".text = "Move"
	
	move_and_slide()

func Up():
	if is_on_floor():
		parent.up = false
		velocity.y = JUMP_SPEED
		#play jump sound
		animated_sprite.animation = "jump"
		$"../Label".text = "Jump"
	else: 
		animated_sprite.animation = "move"

func Down():
	velocity.y += 50
	animated_sprite.animation = "crouch"
	$"../Label".text = "Crouch"
	$RunCollider.disabled = true
	pass
