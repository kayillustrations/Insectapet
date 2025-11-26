extends WindowBase

var full_habitat_instance:WindowBase

func _ready() -> void:
	WindowManager.main_window = self

func _on_texture_button_toggled(toggled_on: bool) -> void:
	if isDragging: 
		move_button.button_pressed = false 
		return
	if toggled_on:
		full_habitat_instance = add_window(WindowManager.FULL_HABITAT_PATH)
	else: 
		#GameSave.
		full_habitat_instance.queue_free()
		move_button.button_pressed = false 
		full_habitat_instance = null
	pass # Replace with function body.
