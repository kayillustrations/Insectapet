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
var BugStats: Dictionary = {
	"Energy" : 100,
	"Hunger" : 100,
	"Happiness" : 100,
	"isHealthy" : true,
	"Stage" : 0,
	"XP" : 0
}
var HabitatStats: Dictionary = {
	"isClean" : true,
	"Hydration" : 100
}

func _ready() -> void:
	if !CheckSaveFolder("settings"): #if no settings, make file
		SaveSettings()
	if !CheckSaveFolder("save"): #if no game save(s), disable load
		newGame = true
	LoadGame()
	LoadSettings()

func SaveGame(): #may be able to add multiple loads/saves in the future
	##SAVE: game_config.set_value("category",variable", variable)
	game_config.set_value("0","current_position",WindowManager.main_window.current_window_position)
	
	game_config.save(SCENE_SAVE_FOLDER+"save.cfg")
	pass

func LoadGame():
	var err = game_config.load(SCENE_SAVE_FOLDER+"save.cfg")
	if err == OK:
		##LOAD: variable = config.get_value("category","variable")
		GameManager.toolbar_parent.current_position = game_config.get_value("0","current_position")
		pass
	
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
