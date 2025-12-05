extends Control

@onready var slots: Array = $GridContainer.get_children()
@onready var place_food_audio: AudioStreamPlayer = %Audio/PlaceFood

var eaten_textures: Array = [
	
]
var food_time = 5
var current_food_id: int

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

func _ready():
	if GameManager.isEmbed: food_time *= .5
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
	if GameManager.habitat_stats["hasFood"]:
		Utils.Error(self,"Food Already Given")
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
	%FoodIn.get_child(0).texture = GameManager.food_given

	%Food.texture = null
	pass

func Feeding(b:bool):
	%MainButtons.ActivateAllButtons(!b)
	%MainButtons._on_eat_toggled(!b)
	%ActivateBug.disabled = b
	%Feed.visible = b
	if b:
		%Feed.find_child("AnimationPlayer").play("feed")
		%Feed.find_child("Food").texture = Exports.food_textures[current_food_id]
		GameManager.food_given = Exports.food_textures[current_food_id]
		GameManager.habitat_stats["hasFood"] = true
		GameManager.food_life = 100
		GameSave.SaveGame()

func UpdateFood():
	if !GameManager.habitat_stats["hasFood"]: return
	$FoodLife.start(food_time)
	MatchFoodLife()
	%FoodIn.get_child(0).texture = GameManager.food_given
	#%FoodIn.texture = eaten_textures[0]

func _on_food_life_timeout() -> void:
	#print(GameManager.food_life)
	GameManager.food_life = GameManager.food_life - 3.0
	if GameManager.food_life <= 20:
		GameManager.habitat_stats["hasFood"] = false
		GameManager.food_given = Texture2D.new()
		%FoodIn.get_child(0).texture = GameManager.food_given
		%FoodIn.scale.y = 1
	GameManager.UpdateHabitat.emit()
	GameSave.SaveGame()
	pass # Replace with function body.

func MatchFoodLife():
	%FoodIn.scale.y = GameManager.food_life / 100

func PlayAudio():
	place_food_audio.playing = true
	print("play")
	pass
