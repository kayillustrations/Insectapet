extends Window
class_name WindowBase

@export var isFullScreen: bool = false
@export var anchor_position: String

@export var move_button:TextureButton
@export var move_buffer: float = .25
@export var isBug:bool = false

@onready var shape: Polygon2D = $Shape
@onready var color_rect: ColorRect = $Shape/ColorRect

@onready var shape_size:Vector2 = shape.polygon[2]
@onready var shape_offset:Vector2 = shape.position

var anchor_dict: Dictionary
var isConfigured:bool = false

var isHeld: bool = false
var isDragging:bool = false
var starting_mouse_position
var starting_window_position
var current_window_position
var move_panel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
	size = shape_size + shape_offset
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
	pass

func _physics_process(delta: float) -> void:
	if !isDragging: 
		if isBug && current_window_position.y < anchor_dict["BotL"].y-shape_offset.y:
			#var tween: Tween = create_tween()
			#var pos
			##tween.tween_method(WindowManager.setWindowPosition(self,fall_pos))
			##WindowManager.setWindowPosition(self,fall_pos)
		return
	
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
	if anchor_position == "":
		position = anchor_dict["TopL"]
	else: position = anchor_dict[anchor_position]
	
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
		move_panel = move_button.find_child("Panel")
		if move_panel != null:
			move_panel.visible = true
		isDragging = true
		starting_mouse_position = color_rect.get_global_mouse_position()
		starting_window_position = current_window_position

func _on_move_button_up() -> void:
	if isDragging:
		move_button.button_pressed =false
	if move_panel != null:
		move_panel.visible = false
	isDragging = false
	isHeld = false

func add_window(window):
	var window_instance = window.instantiate()
	add_child(window_instance)
	if window_instance.name == "FullHabitat":
		return window_instance
