extends Node2D

func _ready() -> void:
	$Dialogs.visible = false
	$DialogBG.visible = false
	
	$Jack.play("walk")
	$Jack/JackAnimations.play("jackWalk")
	
	await $Jack/JackAnimations.animation_finished
	
	$Jack.play("idle")
	
	$Dialogs/DialogsAnimation.play("Dialog1")
	$Dialogs/Dialog1.start_typing()
	
	await get_tree().create_timer(9.0).timeout
	
	$Dialogs/DialogsAnimation.play("Dialog2")
	$Dialogs/Dialog1.visible = false
	$Dialogs/Dialog2.start_typing()
	
	await get_tree().create_timer(9.0).timeout
	
	$Dialogs/DialogsAnimation.play("Dialog1")
	$Dialogs/Dialog2.visible = false
	$Dialogs/Dialog3.start_typing()

	await get_tree().create_timer(9.0).timeout
	
	$Dialogs/DialogsAnimation.play("Dialog2")
	$Dialogs/Dialog3.visible = false
	$Dialogs/Dialog4.start_typing()	
	
	await get_tree().create_timer(9.0).timeout
	
	$Dialogs/DialogsAnimation.play("Dialog1")
	$Dialogs/Dialog4.visible = false
	$Dialogs/Dialog5.start_typing()
	
	await get_tree().create_timer(9.0).timeout

	$Dialogs/DialogsAnimation.play("Dialog2")
	$Dialogs/Dialog5.visible = false
	$Dialogs/Dialog6.start_typing()
	
	await get_tree().create_timer(9.0).timeout
	
	$Jack.play("walk")
	$Jack/JackAnimations.play("jackLive")
	
	await $Jack/JackAnimations.animation_finished
	
	var loading := preload("res://Scenes/loading.tscn").instantiate()
	loading.next_scene_path = "res://Scenes/intro.tscn"
	get_tree().root.add_child(loading)
	get_tree().current_scene.queue_free()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skip"):
		var loading := preload("res://Scenes/loading.tscn").instantiate()
		loading.next_scene_path = "res://Scenes/intro.tscn"
		get_tree().root.add_child(loading)
		get_tree().current_scene.queue_free()
