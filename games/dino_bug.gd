extends CharacterBody2D

const GRAVITY: int = 2000
const JUMP_SPEED: int = -800
@onready var animated_sprite : AnimatedSprite2D = self.find_child("AnimatedSprite2D")

@onready var parent = get_parent()

var isCrouching:bool = false

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
		if is_on_floor() && animated_sprite.animation != "move":
			animated_sprite.play("move")
			$"../Label".text = "Move"
	
	if !is_on_floor() && animated_sprite.animation != "jump":
		$"../Label".text = "Jump"
		animated_sprite.play("jump")

	move_and_slide()

func Up():
	if is_on_floor():
		parent.up = false
		velocity.y = JUMP_SPEED
		$Jump.play()

func Down():
	velocity.y += 50
	animated_sprite.play("crouch")
	$"../Label".text = "Crouch"
	$RunCollider.disabled = true
	pass
