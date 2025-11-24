extends Window
class_name WindowBase

@export var isFullScreen: bool = false
@export var anchor_position: String = "TopL"

@export var move_button:TextureButton
@export var move_buffer: float = .25
@export var isBug:bool = false

var shape: Polygon2D
var color_rect: ColorRect

var shape_size:Vector2
var shape_offset:Vector2

var anchor_dict: Dictionary

var isConfigured:bool = false
var isHeld: bool = false
var isDragging:bool = false
var isFalling:bool = false

var starting_mouse_position
var starting_window_position
var current_window_position
var move_panel
var fall_pos

func _enter_tree() -> void:
	shape = find_child("Shape")
	color_rect = shape.find_child("ColorRect")
	move_panel = move_button.find_parent("Panel")
	shape_size = shape.polygon[2]*shape.scale
	shape_offset = shape.position
	WindowSize()
	_on_move_button_up()

func WindowSize():
	if isFullScreen:
		shape.polygon[0] = Vector2.ZERO - shape_offset
		shape.polygon[1] = Vector2(0,WindowManager.screen_size.y)
		shape.polygon[2] = Vector2(WindowManager.screen_size)
		shape.polygon[3] = Vector2(WindowManager.screen_size.x,0)- shape_offset
		for i in 4:
			shape.polygon[i].y -= WindowManager.title_size
		shape_size = shape.polygon[2]
		shape_offset = Vector2(shape_offset.x,WindowManager.title_size+shape_offset.y)
		$Shape/ColorRect.size = shape_size
	#print("shape:",shape_size)
	#print("window:",shape_size)
	size = (shape_size * shape.scale) + shape_offset
	anchor_dict = WindowManager.getScreenAnchors(
		WindowManager.screen_size,shape_size,shape_offset)
	Config()
	color_rect.size -= shape_offset
	if move_button != null:
		move_button.button_down.connect(_on_move_button_down)
		move_button.button_up.connect(_on_move_button_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_window().mouse_passthrough_polygon = shape.polygon
	
	if isFalling:
		WindowManager.setWindowPosition(self,fall_pos)
	if !isDragging: return
	
	var mouse = color_rect.get_global_mouse_position()
	var difference = mouse - starting_mouse_position
	var new_pos: Vector2
	
	#if abs(mouse.x) > WindowManager.anchor_dict["TopR"].x/2:
		#isRight = !isRight
	#if isRight:
		#new_pos.x = WindowManager.anchor_dict["TopR"].x
	#else: new_pos.x = WindowManager.anchor_dict["TopL"].x
	
	new_pos = Vector2(difference) + Vector2(starting_window_position)
	
	if new_pos.x <= anchor_dict["TopL"].x:
		new_pos.x = anchor_dict["TopL"].x
	if new_pos.x >= anchor_dict["BotR"].x:
		new_pos.x = anchor_dict["BotR"].x
	
	if new_pos.y <= anchor_dict["TopL"].y-shape_offset.y:
		new_pos.y = anchor_dict["TopL"].y-shape_offset.y
	elif new_pos.y >= anchor_dict["BotL"].y-shape_offset.y:
		new_pos.y = anchor_dict["BotL"].y-shape_offset.y
	
	WindowManager.setWindowPosition(self,new_pos)
	starting_window_position = current_window_position

func Config():
	if GameSave.habitat_locations[self.name] != Vector2i.ZERO:
		position = GameSave.habitat_locations[self.name]
	else: 
		position = anchor_dict[anchor_position]
		if anchor_position == "Center":
			position -= size/2
	
	isConfigured = true
	current_window_position = get_window().position

func SetPosition(a):
	get_window().position = a
	current_window_position = get_window().position

func _on_move_button_down() -> void:
	var temp = get_tree().create_timer(move_buffer)
	isHeld = true
	await temp.timeout
	if isHeld:
		if move_panel != null:
			move_panel.self_modulate = Color.WHITE
		isDragging = true
		starting_mouse_position = color_rect.get_global_mouse_position()
		starting_window_position = current_window_position

func _on_move_button_up() -> void:
	if isDragging:
		move_button.button_pressed =false
		GameSave.habitat_locations[self.name] = current_window_position
		GameSave.SaveGame()
	if move_panel != null:
		move_panel.self_modulate = Color.TRANSPARENT
	isDragging = false
	isHeld = false
	if isBug && current_window_position.y < anchor_dict["BotL"].y-shape_offset.y:
		fall_pos = current_window_position
		var time = snappedf(1 - (current_window_position.y/anchor_dict["BotR"].y),.1)
		if time < .5: time = .5
		var tween:Tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_property(self,"fall_pos", Vector2i(current_window_position.x,anchor_dict["BotR"].y+10),time)
		isFalling = true
		await tween.finished
		var buffer_timer = get_tree().create_timer(.05)
		await buffer_timer.timeout
		isFalling = false

func add_window(window):
	var window_instance = load(window).instantiate()
	add_child(window_instance)
	if window_instance.name == "FullHabitat":
		return window_instance
	else: WindowManager.bug = window_instance
	WindowManager.bug = window_instance
