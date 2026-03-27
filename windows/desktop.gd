extends WindowBase

func _ready() -> void:
	WindowManager.main_window = self
	OverrideSettings()
	
	pass

func OverrideSettings():
	get_window().gui_embed_subwindows = false
	get_window().mode = Window.MODE_WINDOWED
	get_window().position = position
	get_window().borderless = true
	get_window().unresizable = true
	get_window().always_on_top = true
	get_window().unfocusable = true
	get_window().sharp_corners = true
	get_window().mouse_passthrough = true
	#[display]
	#window/size/width=750
	#window/size/height=900
	#mode=1
	#resizable=false
	#borderless=true
	#top=true
	#no_focus=true
	#sharp_corner=true
	#embed=false
	pass
