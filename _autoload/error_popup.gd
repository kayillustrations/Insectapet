extends MarginContainer

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $MarginContainer/Label

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start(animation_player.current_animation_length/animation_player.speed_scale)
	await timer.timeout
	queue_free()
