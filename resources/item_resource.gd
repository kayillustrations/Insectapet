extends Resource
class_name ItemData

@export var name: String = ""
@export var id: int
@export var texture: Texture
var data: Dictionary

func Config(item_info:Dictionary, item_id:int):
	id = item_id
	data = item_info
	
	if !data:
		return
	name = data["NAME"]
