extends Window
class_name WindowBase

@export var isFullScreen: bool = false
@export var anchor_position: String

@onready var shape: Polygon2D = $Shape
@onready var shape_size:Vector2 = shape.polygon[2]
@onready var shape_offset:Vector2 = shape.position

var anchor_dict: Dictionary

var isConfigured:bool = false

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
	
	anchor_dict = WindowManager.getScreenAnchors(
		WindowManager.screen_size,shape_size,shape_offset)
		
	size = shape_size + shape_offset
	size.y += 5
	Config()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_window().mouse_passthrough = false
	get_window().mouse_passthrough_polygon = $Shape.polygon

func Config():
	if anchor_position == "":
		position = anchor_dict["TopL"]
	else: position = anchor_dict[anchor_position]

	isConfigured = true
