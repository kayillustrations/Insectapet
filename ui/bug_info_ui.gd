extends Control

var current_bug:BugStats

func _ready():
    GameManager.UpdateStats.connect(UpdateStats)
    GameManager.UpdateAll.connect(ConfigInfo)

    ConfigInfo()

func ConfigInfo():    
    current_bug = GameManager.current_bug
    %Name.text = current_bug.name
    %Scientific.text = current_bug.scientific
    
    UpdateStage()
    UpdateStats()

func UpdateStage():
    #icon texture = current_bug.icons[current_bug.stats["Stage"]]
    match current_bug.stats["Stage"]:
        0: %Stage.text = "Egg"
        1: 
            if current_bug.category == 1: %Stage.text = "Larva"
            else: %Stage.text = "Young Nymph"
        2:
            if current_bug.category == 1: %Stage.text = "Pupa"
            else: %Stage.text = "Nymph"
        3:
            %Stage.text = "Adult"

func UpdateStats():
    #progress bars
    %XP.value = current_bug.stats["XP"]
    %Hunger.value = current_bug.stats["Hunger"]
    %Happiness.value = current_bug.stats["Happiness"]
    %Energy.value = current_bug.stats["Energy"]
    pass