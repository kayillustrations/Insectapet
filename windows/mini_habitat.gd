extends WindowBase

var full_habitat_instance:WindowBase
@onready var timers: Array = $Node.get_children()

func _ready() -> void:
	WindowManager.main_window = self
	for i in timers.size():
		timers[i].start(GameManager.default_times[i])

func _on_hold():
	pass

func _on_texture_button_toggled(toggled_on: bool) -> void:
	if isDragging: 
		move_button.button_pressed = false 
		return
	if toggled_on:
		full_habitat_instance = add_window(WindowManager.FULL_HABITAT_PATH)
		full_habitat_instance.HabitatChecks()
	else: 
		#GameSave.
		full_habitat_instance.queue_free()
		move_button.button_pressed = false 
		full_habitat_instance = null
	pass # Replace with function body.

func EditStat(stat:String,amount:int):
	if GameManager.current_stats[stat] - amount <= 0:
		GameManager.current_stats[stat] = 0
		printerr(stat+" Empty")
	elif GameManager.current_stats[stat] - amount > 100:
		GameManager.current_stats[stat] = 100
		printerr(stat+" Full")
	else:
		GameManager.current_stats[stat] -= amount
	GameManager.UpdateStats.emit()
	GameSave.SaveGame()

func EditHabitat(stat:String, amount:int):
	if GameManager.habitat_stats[stat] - amount <= 0:
		GameManager.habitat_stats[stat] = 0
		printerr(stat+" Empty")
	elif GameManager.habitat_stats[stat] - amount > 100:
		GameManager.habitat_stats[stat] = 100
		printerr(stat+" Full")
	else:
		GameManager.habitat_stats[stat] -= amount
	GameManager.UpdateHabitat.emit()
	GameSave.SaveGame()
	pass

func _on_happiness_timeout() -> void:
	EditStat("Happiness",1)

func _on_hunger_timeout() -> void:
	EditStat("Hunger",1)

func _on_energy_timeout() -> void:
	if GameManager.habitat_stats["isLampOn"] == true:
		EditStat("Energy",1)
	else: EditStat("Energy",-5)
	pass # Replace with function body.

func _on_cleanliness_timeout() -> void:
	EditHabitat("Cleanliness", 5)
	pass # Replace with function body.

func _on_hydration_timeout() -> void:
	EditHabitat("Hydration", 5)
	pass # Replace with function body.

func _on_food_life_timeout() -> void:
	GameManager.food_given = null
	pass # Replace with function body.
