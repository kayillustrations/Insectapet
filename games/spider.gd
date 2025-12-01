extends StaticBody2D

var max_rotation_degrees = 15
var rotation_direction = -1

func _ready() -> void:
	randomize()
	rotation_degrees = randf_range(-max_rotation_degrees,max_rotation_degrees)
	rotation_direction = [-1,1].pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rotation_degrees += .2*rotation_direction
	if abs(rotation_degrees) >= max_rotation_degrees:
		rotation_direction *= -1
	pass
