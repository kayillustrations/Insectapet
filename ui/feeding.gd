extends Control

@onready var slots: Array = $GridContainer.get_children()
var eaten_textures: Array = [
	
]
var food_time = 60

var food_dict:Dictionary = {
	0: 
		{"Name": "Leaf",
		"Cost" : 1
		},
	1: 
		{"Name": "Flower",
		"Cost" : 2
		},
	2: 
		{"Name": "Fruit Wedge",
		"Cost" : 3
		},
	3: 
		{"Name": "Veggie Slice",
		"Cost" : 4
		},
	4: 
		{"Name": "Berries",
		"Cost" : 0},
	5: 
		{"Name": "Aphid",
		"Cost" : 0},
	6: 
		{"Name": "Dead Prey",
		"Cost" : 0},
	7: 
		{"Name": "Live Prey",
		"Cost" : 0},
	}
var current_food_id: int

func _ready():
	%Feed.visible = false
	ConfigFood()

func ConfigFood():
	for i in slots.size():
		if food_dict[i]["Cost"] == 0:
			LockSlot(slots[i],true)
		else: 
			LockSlot(slots[i],false)
			slots[i].find_child("Label").text = food_dict[i]["Name"]
			slots[i].find_child("Cost").text = str(food_dict[i]["Cost"])
			slots[i].find_child("TextureRect").texture =  Exports.food_textures[i]
			slots[i].find_child("Button").connect("pressed",StartFeed.bind(i))

func LockSlot(slot,doLock:bool):
	slot.find_child("Locked").visible = doLock
	slot.find_child("Button").disabled = doLock

func StartFeed(food_id:int):
	if GameManager.food_given:
		Utils.Error(self,"FoodAlreadyGiven")
		return
	current_food_id = food_id
	Feeding(true)
	await %Feed.find_child("AnimationPlayer").animation_finished
	Feeding(false)
	%MainButtons.eat.button_pressed = false
	pass

func GetFed():
	#%FoodIn.texture = eaten_textures[0]
	$FoodLife.start()
	%FoodIn.get_child(0).texture = %Food.texture
	%Food.texture = null
	GameManager.food_given = %FoodIn.texture
	GameManager.UpdateHabitat.emit()
	GameSave.SaveGame()
	pass

func Feeding(b:bool):
	%MainButtons.ActivateAllButtons(!b)
	%MainButtons._on_eat_toggled(!b)
	%ReleaseBug.disabled = b
	%Feed.find_child("Food").texture = Exports.food_textures[current_food_id]
	%Feed.find_child("AnimationPlayer").current_animation = "feed"
	%Feed.visible = b

func UpdateFood():
	if GameManager.food_given == null:
		return
	$FoodLife.start(food_time)
	%FoodIn.get_child(0).texture = %Food.texture
	#%FoodIn.texture = eaten_textures[0]

func _on_food_life_timeout() -> void:
	GameManager.food_life -= 10
	if GameManager.food_life <= 0:
		GameManager.food_given = null
	GameManager.UpdateHabitat.emit()
	pass # Replace with function body.
