extends CharacterBody2D

const GRAVITY: int = 4000
const JUMP_SPEED: int = -1000
@onready var animation_player: AnimationPlayer = $BugModel.get_child(0).find_child("AnimationPlayer")

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if !get_parent().game_started:
		animation_player.current_animation = "idle"
		return
	if is_on_floor():
		$RunCollider.disabled = false
		if Input.is_action_just_pressed("Up"):
			Up()
		elif Input.is_action_just_pressed("Down"):
			Down()
		else:
			animation_player.current_animation = "move"

	move_and_slide()

func Up():
	velocity.y = JUMP_SPEED
	#play jump sound
	animation_player.current_animation = "jump"

func Down():
	animation_player.current_animation = "crouch"
	$RunCollider.disabled = true
	$CrouchCollider.disabled = false
	pass
