extends Control

@export var textures: Array[Texture2D]
@onready var slots: Array = $GridContainer.get_children()

var food_dict:Dictionary = {
	"0": 
		{"Name": "Leaf",
		"Cost" : 1},
	"1": 
		{"Name": "Flower",
		"Cost" : 2},
	"2": 
		{"Name": "Veggie Slice",
		"Cost" : 3},
	"3": 
		{"Name": "Fruit Wedge",
		"Cost" : 4},
	"4": 
		{"Name": "Berries",
		"Cost" : 0},
	"5": 
		{"Name": "Aphid",
		"Cost" : 0},
	"6": 
		{"Name": "Dead Prey",
		"Cost" : 0},
	"7": 
		{"Name": "Live Prey",
		"Cost" : 0},
	}
var current_food_id: int

func _ready():
	ConfigFood()

func ConfigFood():
	for i in slots.size():
		if food_dict[str(i)]["Cost"] == 0:
			LockSlot(slots[i],true)
		else: 
			LockSlot(slots[i],false)
			slots[i].find_child("Label").text = food_dict[str(i)]["Name"]
			slots[i].find_child("Cost").text = str(food_dict[str(i)]["Cost"])
			slots[i].find_child("Button").connect("pressed",StartFeed.bind(i))

func LockSlot(slot,doLock:bool):
	slot.find_child("Locked").visible = doLock
	slot.find_child("Button").disabled = doLock

func StartFeed(food_id:int):
	current_food_id = food_id
	%MainButtons._on_eat_toggled(false)
	%MainButtons.ActivateAllButtons(false)
	print(food_dict[str(food_id)]["Name"])
	pass
