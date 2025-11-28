#extends Resource
class_name BugInfo

@export var name: String
@export var resource_name: String
@export var scientific: String
@export_enum("Nymph","Pupa","ImPODster") var category: int
@export var icons: Array[Texture2D]
@export var stages: Array[PackedScene]
