extends WindowBase

var full_habitat_instance:WindowBase
@onready var timers: Array = $Node.get_children()

func _ready() -> void:
	WindowManager.main_window = self
	#GameManager.UpdateHabitat.connect(FoodLife)
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
	else: 
		#GameSave.
		full_habitat_instance.queue_free()
		move_button.button_pressed = false 
		full_habitat_instance = null
	pass # Replace with function body.

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
	
	pass # Replace with function body.
