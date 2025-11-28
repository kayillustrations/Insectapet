extends Node

@export var food_textures: Array[AtlasTexture]
@export var emote_textures: Array[AtlasTexture]

@export var colors_green: Array[Color]
@export var colors_orange: Array[Color]

@export var stickbug_textures: Array[Texture2D]

@onready var timers: Array = get_children()
@onready var emote_dictionary: Dictionary ={
	"Happy": emote_textures[0],
	"UnHappy": emote_textures[1],
	"Sleepy": emote_textures[2],
	"Love": emote_textures[3],
	"Oh?": emote_textures[4]
}
func _ready() -> void:
	for i in timers.size()-1:
		timers[i].start(GameManager.default_times[i])

func LifeSpanTimer():
	if GameManager.current_stats["Stage"] == 3: return
	$LifeSpan.start(GameManager.life_times[GameManager.current_stats["Stage"]])

func _on_happiness_timeout() -> void:
	GameManager.EditStat("Happiness",1)

func _on_hunger_timeout() -> void:
	if GameManager.food_given != null:
		GameManager.EditStat("Hunger",-5)
	else: GameManager.EditStat("Hunger",1)

func _on_energy_timeout() -> void:
	if GameManager.habitat_stats["isLampOn"] == true:
		GameManager.EditStat("Energy",1)
	else: GameManager.EditStat("Energy",-5)
	pass # Replace with function body.

func _on_cleanliness_timeout() -> void:
	GameManager.EditHabitat("Cleanliness", 1)
	pass # Replace with function body.

func _on_hydration_timeout() -> void:
	GameManager.EditHabitat("Hydration", 1)
	pass # Replace with function body.

func _on_life_span_timeout() -> void:
	if GameManager.current_stats["Stage"] == 3: return
	GameManager.EditStat("XP",-5)
	pass # Replace with function body.
