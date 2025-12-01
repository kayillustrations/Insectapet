extends Control

const JAR = preload("res://ui/jar.tscn")

var jars: Array

var default_control_transform

func _ready() -> void:
	jars = $HBoxContainer.get_children()
	ConnectJars()

func ConnectJars():
	for i in jars.size():
		jars[i].disabled = false
		jars[i].connect("mouse_entered",_on_mouse_hovered.bind(i,true))
		jars[i].connect("mouse_exited",_on_mouse_hovered.bind(i,false))
		jars[i].connect("button_down",ChosenJar.bind(i))

func _on_mouse_hovered(jar_int,isHovered:bool):
	if jars[jar_int].disabled == true: return
	if isHovered: 
		jars[jar_int].get_child(0).scale = Vector2(1.25,1.25)
		$Hover.play()
	else: 
		jars[jar_int].get_child(0).scale = Vector2(1,1)

func ChosenJar(jar_int:int):
	var jar_control = jars[jar_int].get_child(0)
	default_control_transform = jar_control.position
	for i in jars.size():
		jars[i].disabled = true
	jar_control.reparent($Center,true)
	
	var tween_fade:Tween = get_tree().create_tween()
	var tween_move:Tween = get_tree().create_tween()
	tween_fade.tween_property($HBoxContainer,"modulate",Color.TRANSPARENT,1)
	tween_move.tween_property(jar_control,"position",Vector2(0,0),1)
	
	await tween_move.finished
	$AnimationPlayer.play("tilt")
	
	await $AnimationPlayer.animation_finished
	var tween_lid_position:Tween = get_tree().create_tween()
	var tween_lid_rotation:Tween = get_tree().create_tween()
	tween_lid_position.tween_property(jar_control.find_child("Lid"),"position",Vector2(-90,-225),1)
	tween_lid_rotation.tween_property(jar_control.find_child("Lid"),"rotation_degrees",-20,1)
	var tween_glow:Tween = get_tree().create_tween()
	tween_glow.tween_property($Glow,"modulate",Color.WHITE,1)
	$Reveal.play()
	await tween_glow.finished
	var tween_fade_all:Tween = get_tree().create_tween()
	tween_fade_all.tween_property($".","modulate",Color.TRANSPARENT,1)
	await tween_fade_all.finished
	GameManager.habitat_window.NewBugScreen(false)
	jar_control.queue_free()
	ResetGainBug()

func ResetGainBug():
	$Center.position = Vector2(212.0,105)
	$Center.rotation_degrees = 0
	$Center.scale = Vector2(1,1)
	$HBoxContainer.modulate = Color.WHITE
	for i in jars.size():
		if jars[i].get_child_count() == 0:
			jars[i].add_child(JAR.instantiate())
	jars = $HBoxContainer.get_children()
