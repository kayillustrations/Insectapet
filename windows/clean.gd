extends Node2D

@onready var fog: Sprite2D = $Fog

const SIZE = Vector2(2000,1050)

var imageTexture : ImageTexture
var image : Image
var radius = 10.0
var erase = Color(0.0, 0.0, 0.0, 0.0)

var click_pos: Array

func _input(event: InputEvent) -> void:
	if visible && not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	var mouse_pos = get_local_mouse_position()
	if abs(mouse_pos.x) > SIZE.x/2:return
	if abs(mouse_pos.y) > SIZE.y/2 + get_parent().position.y:return #TODO RETURN HERE
	click_pos.append(mouse_pos)
	queue_redraw()

func _draw() -> void:
	for point in click_pos:
		draw_circle(point/%Control.scale.x,100,Color.BLACK,true)
