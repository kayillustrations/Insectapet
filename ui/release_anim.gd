extends Control

signal finished

@onready var jar_control: Control = $JarControl
@onready var bug_goes_here: Control = $JarControl/BugGoesHere

func StartAnim(bug_node:Node2D,bug_color:Color):
	visible = true
	$JarControl/CPUParticles2D.emitting = true
	var tweenget = create_tween().set_trans(Tween.TRANS_SINE)
	tweenget.tween_property($JarControl/BugGoesHere,"scale",Vector2(.3,.3),.25)
	$JarControl/AudioStreamPlayer.play()
	tweenget.tween_property($JarControl/BugGoesHere,"scale",Vector2(.2,.2),.5)
	bug_node.reparent(bug_goes_here,false)
	bug_node.modulate = bug_color
	await get_tree().create_timer(2).timeout
	var tweenup = create_tween().set_trans(Tween.TRANS_QUART)
	tweenup.parallel().tween_property($JarControl,"position",Vector2(-20,-700),2)
	tweenup.parallel().tween_property($JarControl,"modulate",Color.TRANSPARENT,2)
	await tweenup.finished
	Reset()
	finished.emit()

func Reset():
	visible = false
	$JarControl/CPUParticles2D.emitting = false
	$JarControl/BugGoesHere.get_child(0).queue_free()
	$JarControl.position = Vector2(-20,-20)
	$JarControl.modulate = Color.WHITE
