extends Control


func _ready():
	GameManager.UpdateStats.connect(UpdateStats)
	GameManager.UpdateAll.connect(ConfigInfo)

func ConfigInfo():    
	%Name.text = GameManager.current_bug.name
	%Scientific.text = GameManager.current_bug.scientific
	
	UpdateStage()
	UpdateStats()

func UpdateStage():
	#icon texture = GameManager.current_bug.icons[GameManager.current_stats["Stage"]]
	match GameManager.current_stats["Stage"]:
		0: %Stage.text = "Egg"
		1: 
			if GameManager.current_bug.category == 1: %Stage.text = "Larva"
			else: %Stage.text = "Young Nymph"
		2:
			if GameManager.current_bug.category == 1: %Stage.text = "Pupa"
			else: %Stage.text = "Nymph"
		3:
			%Stage.text = "Adult"
	%CurrentSprite.texture = GameManager.current_bug.icons[GameManager.current_stats["Stage"]]
	%CurrentSprite.self_modulate = GameSave.bug_info["bug_color"]

func UpdateStats():
	#progress bars
	%XP.value = GameManager.current_stats["XP"]
	%Hunger.value = GameManager.current_stats["Hunger"]
	%Happiness.value = GameManager.current_stats["Happiness"]
	%Energy.value = GameManager.current_stats["Energy"]
	Arrow(%Energy.get_child(0),!GameManager.habitat_stats["isLampOn"])
	Arrow(%Hunger.get_child(0),GameManager.habitat_stats["hasFood"])
	Arrow(%Happiness.get_child(0),false)

func Arrow(arrow:TextureRect, isPositive:bool):
	if isPositive:
		arrow.flip_h = true
		arrow.modulate = Color.GREEN_YELLOW
	else:
		arrow.flip_h = false
		arrow.modulate = Color.INDIAN_RED
	pass
