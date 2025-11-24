extends CharacterBody2D

const GRAVITY: int = 4000
const JUMP_SPEED: int = -1000
@onready var animated_sprite : AnimatedSprite2D = self.find_child("AnimatedSprite2D")

func _physics_process(delta):
	if !get_parent().game_started:
		return
	velocity.y += GRAVITY * delta
	if is_on_floor():
		$RunCollider.disabled = false
		if Input.is_action_just_pressed("Up"):
			Up()
		elif Input.is_action_just_pressed("Down"):
			Down()
		else:
			animated_sprite.animation = "move"

	move_and_slide()

func Up():
	velocity.y = JUMP_SPEED
	#play jump sound
	animated_sprite.animation = "jump"

func Down():
	animated_sprite.animation = "crouch"
	$RunCollider.disabled = true
	$CrouchCollider.disabled = false
	pass
