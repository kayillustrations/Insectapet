extends Panel
class_name DragDropSlot

var TOOLTIP
var DRAG_PREVIEW
@export var accepts_type = 1

@onready var amount_label: Label = $Amount
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var color_rect: ColorRect = $ColorRect

@export var current_slot: SlotData

@export var canDrag: bool = true
@export var icons: Array[Texture2D]
var texture_folder = "res://art/chars/"

func _make_custom_tooltip(for_text: String) -> Object:
	if TOOLTIP == null:
		return
	var tooltip = TOOLTIP.instantiate()
	tooltip.amounts = [current_slot.skill_lvl,current_slot.reputation_lvl]
	return tooltip

func Config():
	if current_slot == null:
		texture_rect.texture = null
		amount_label.visible = false
		return
	elif current_slot.amount > 1:
		amount_label.text = str(current_slot.amount)
	else:
		amount_label.text = str("")
	
	texture_rect.texture = icons[current_slot.item.id]
	#color_rect.modulate = SceneLoader.exports.colors_char[current_slot.item.id]
	#if current_slot.item != null:
		#var temp_path = texture_folder + str(current_slot.item.data["NICKNAME"]) + "/icon.png"
		#texture_rect.texture = load(temp_path)
	#amount_label.visible = true
	

func _get_drag_data(at_position: Vector2) -> Variant:
	if !canDrag || current_slot == null:
		return
	var data = [current_slot,self]
	if DRAG_PREVIEW != null:
		var prev = DRAG_PREVIEW.instantiate()
		prev.size = get_child(0).size
		prev.find_child("TextureRect").texture = texture_rect.texture
		prev.find_child("Label").text = amount_label.text
		prev.find_child("Offset").position = Vector2(-prev.size/2)
		prev.connect("tree_exiting",_dropped_data)
		set_drag_preview(prev)
	texture_rect.texture = null
	amount_label.text = ""
	return data

func _dropped_data():
	Config()
	pass

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data[0].item.item_type == accepts_type: #verify if same type
		return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	#remove from inv?
	if data == null:
		Config()
		return
	data[1].current_data = null
	data[1].Config()
	
	current_slot = data[0]
	Config()
	pass
