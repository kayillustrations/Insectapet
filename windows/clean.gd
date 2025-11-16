extends Sprite2D

const PATH: String = "user://test.png"
const SIZE = Vector2(2000,1050)

var imageTexture : ImageTexture
var image : Image
var radius = 10.0
var erase = Color(0.0, 0.0, 0.0, 0.0)

var click_pos: Array
var dist_traveled

var prev_pos
var current_pos

func _input(event: InputEvent) -> void:
	if !visible || not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	var mouse_pos = get_local_mouse_position()
	if abs(mouse_pos.x) > SIZE.x/2:return
	if abs(mouse_pos.y) > SIZE.y/2 + get_parent().position.y:return #TODO RETURN HERE
	if prev_pos == null:
		prev_pos = mouse_pos
		dist_traveled = Vector2.ZERO
	current_pos = mouse_pos
	dist_traveled += abs(current_pos - prev_pos)
	prev_pos = current_pos
	EditFog()

func EditFog():
	var min_value = min(dist_traveled.x,dist_traveled.y)
	min_value *= .0002
	print(min_value)
	if min_value >= 1:
		visible = false
		print("CLEAN")
		return
	var tween:Tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,1-min_value),0)

#func _draw() -> void:
	#for point in click_pos:
		#draw_circle(point/%Control.scale.x,100,Color.BLACK,true)
