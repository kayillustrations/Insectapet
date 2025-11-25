extends Node

const SCENE_SAVE_FOLDER:String = "res://saves/"

var game_config:ConfigFile = ConfigFile.new()
var settings_config:ConfigFile = ConfigFile.new()

@onready var sfx_index: int = AudioServer.get_bus_index("SFX")
@onready var music_index: int = AudioServer.get_bus_index("Music")
var volume_music:float = .5
var volume_sfx:float = 1

var isOptionsComplex: bool = false

#------Settings------
var newGame: bool = false
var debug_mode:bool = true

#--------Stats-------
var habitat_locations: Dictionary = {
	"MiniHabitat": Vector2i.ZERO,
	"FullHabitat": Vector2i.ZERO,
	"Bug": Vector2i.ZERO
}

var bug_color

var highscores: Dictionary = {
	"Dino" : 0,
	"Snake" : 0
}
var DefaultBugStats: Dictionary = {
	"Energy" : 100,
	"Hunger" : 75,
	"Happiness" : 50,
	"isHealthy" : true,
	"Stage" : 0,
	"XP" : 0
	}
var DefaultHabitatStats: Dictionary = {
	"isLampOn": true,
	"isBugReleased": false,
	"Cleanliness" : 50,
	"Hydration" : 100,
}

func _ready() -> void:
	if !CheckSaveFolder("settings"): #if no settings, make file
		SaveSettings()
	if !CheckSaveFolder("save"): #if no game save(s), disable load
		bug_color =[Exports.colors_green,Exports.colors_orange].pick_random()
		bug_color = bug_color.pick_random()
		SaveGame()
	else: LoadGame()
	LoadSettings()

func SaveGame(): #may be able to add multiple loads/saves in the future
	##SAVE: game_config.set_value("category",variable", variable)
	game_config.set_value("0","habitat_locations",habitat_locations)
	game_config.set_value("0","current_stats",GameManager.current_stats)
	game_config.set_value("0","habitat_stats",GameManager.habitat_stats)
	game_config.set_value("0","food_given",GameManager.food_given)
	game_config.set_value("0","bug_color",GameSave.bug_color)
	game_config.set_value("0","highscores",GameSave.highscores)
	game_config.set_value("0","current_path_location",GameManager.current_path_location)
	
	game_config.save(SCENE_SAVE_FOLDER+"save.cfg")
	#print(GameManager.habitat_stats)
	pass

func LoadGame():
	var err = game_config.load(SCENE_SAVE_FOLDER+"save.cfg")
	if err == OK:
		##LOAD: variable = config.get_value("category","variable")
		habitat_locations = game_config.get_value("0","habitat_locations")
		GameManager.current_stats = game_config.get_value("0","current_stats")
		GameManager.habitat_stats = game_config.get_value("0","habitat_stats")
		GameManager.food_given = game_config.get_value("0","food_given")
		GameSave.bug_color = game_config.get_value("0","bug_color")
		GameSave.highscores = game_config.get_value("0","highscores")
		GameManager.current_path_location = game_config.get_value("0","current_path_location")
		pass
	print("Load")
	#ConfigInventory()
	#configure game

func SaveSettings():
	##SAVE: settings_config.set_value("category","variable", variable)
	settings_config.set_value("0","debug_mode",debug_mode)
	
	settings_config.set_value("0","volume_music",volume_music)
	settings_config.set_value("0","volume_sfx",volume_sfx)
	
	if !isOptionsComplex:
		#set other complex values
		pass
	
	settings_config.save(SCENE_SAVE_FOLDER+"settings.cfg")
	pass

func LoadSettings():
	var err = settings_config.load(SCENE_SAVE_FOLDER+"settings.cfg")
	if err == OK:
		## variable = settings_config.get_value("category", "variable")
		debug_mode = settings_config.get_value("0","debug_mode")
		
		volume_music = settings_config.get_value("0","volume_music")
		volume_sfx = settings_config.get_value("0","volume_sfx")
		
		if !isOptionsComplex:
			#load other complex values
			pass
		
		pass
	#ConfigAudio()

func ConfigAudio():
	AudioServer.set_bus_volume_db(sfx_index,linear_to_db(volume_sfx))
	AudioServer.set_bus_volume_db(music_index,linear_to_db(volume_music))

func CheckSaveFolder(file_name:String):
	if FileAccess.file_exists(SCENE_SAVE_FOLDER+file_name+".cfg"):
		return true
	else: return false
