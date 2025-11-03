extends WindowBase

func _enter_tree() -> void:
	$Shape/ColorRect/Bug.disabled = GameManager.isBugReleased
	pass

func _on_x_pressed() -> void:
	queue_free()
	pass # Replace with function body.

func _on_bug_pressed() -> void:
	GameManager.ReleaseBug(true)
	$Shape/ColorRect/Bug.disabled = true
	pass # Replace with function body.
