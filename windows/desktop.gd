extends WindowBase

func _init() -> void:
	OverrideSettings()

func OverrideSettings():
	DisplayServer.window_set_size(size)
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
