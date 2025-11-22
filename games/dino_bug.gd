extends CharacterBody2D

const GRAVITY: int = 4000
const JUMP_SPEED: int = -1000

func _physics_process(delta):
    velocity.y += GRAVITY * delta
    if !get_parent().game_running:
        $AnimationControllor.current_animation = "idle"
        return
    if is_on_floor():
        $RunCollider.disabled = false
        if Input.is_action_just_pressed("ArrowUp"):
            velocity.y = JUMP_SPEED
            #play jump sound
            $AnimationControllor.current_animation = "jump"
        elif Input,is_action_just_pressed("ArrowDown"):
            $AnimationControllor.current_animation = "crouch"
            $RunCollider.disabled = true
            $CrouchCollider.disabled = false
        else:
            $AnimationControllor.current_animation = "run"
    
    move_and_slide()