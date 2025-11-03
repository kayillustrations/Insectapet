extends WindowBase

var full_habitat_instance:WindowBase

func _init() -> void:
	WindowManager.main_window = self

func _on_hold():
	pass

func _on_texture_button_toggled(toggled_on: bool) -> void:
	if isDragging: 
		move_button.button_pressed = false 
		return
	if toggled_on:
		full_habitat_instance = add_window(WindowManager.FULL_HABITAT)
	else: 
		full_habitat_instance.queue_free()
		full_habitat_instance = null
	pass # Replace with function body.
