extends Node2D

var click_pos: Array

func _input(event: InputEvent) -> void:
	if visible && not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	click_pos.append(get_local_mouse_position())
	queue_redraw()

func _draw() -> void:
	for point in click_pos:
		draw_circle(point/%Control.scale.x,100,Color.BLACK,true)
