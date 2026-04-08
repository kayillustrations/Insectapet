extends Control

signal finished

@onready var jar_control: Control = $JarControl
@onready var bug_goes_here: Control = $JarControl/BugGoesHere

func StartAnim(bug_node:Node2D):
	bug_node.reparent(bug_goes_here,false)
	visible = true
	
	
	
	GameManager.isPaused = false
