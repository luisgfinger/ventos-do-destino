extends Node2D

func _ready() -> void:
	$DialogBG.visible = false
	$Player/Sail.play("sailUpLeft")
	$PlayerAnimation.play("playerMove")
	
	await $PlayerAnimation.animation_finished
	
	$DialogBG/Dialogs/DialogsAnimation.play("Dialog_Animation1")
	$DialogBG.visible = true
	$DialogBG/Dialogs/Dialog1.start_typing()
	
	await get_tree().create_timer(9.0).timeout
	
	$DialogBG/Dialogs/Dialog1.visible = false
	$DialogBG.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	$DialogBG/Dialogs/DialogsAnimation.play("Dialog_Animation2")
	$DialogBG.visible = true
	$DialogBG/Dialogs/Dialog2.start_typing()
	
	await get_tree().create_timer(9.0).timeout
	
	$DialogBG.visible = false
	$DialogBG/Dialogs/Dialog2.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	$DialogBG/Dialogs/DialogsAnimation.play("DialogAnimation1")
	$DialogBG.visible = true
	$DialogBG/Dialogs/Dialog3.start_typing()
	
	await get_tree().create_timer(9.0).timeout
	
	$DialogBG.visible = false
	$DialogBG/Dialogs/Dialog3.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	$DialogBG/Dialogs/DialogsAnimation.play("Dialog_Animation2")
	$DialogBG.visible = true
	$DialogBG/Dialogs/Dialog4.start_typing()
	
	await get_tree().create_timer(9.0).timeout
	
	$DialogBG.visible = false
	$DialogBG/Dialogs/Dialog4.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	$DialogBG/Dialogs/DialogsAnimation.play("DialogAnimation1")
	$DialogBG.visible = true
	$DialogBG/Dialogs/Dialog5.start_typing()
	
	await get_tree().create_timer(9.0).timeout
	
	$DialogBG.visible = false
	$DialogBG/Dialogs/Dialog5.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	$DialogBG/Dialogs/DialogsAnimation.play("Dialog_Animation2")
	$DialogBG.visible = true
	$DialogBG/Dialogs/Dialog6.start_typing()
	
	var loading := preload("res://Scenes/loading.tscn").instantiate()
	loading.next_scene_path = "res://Scenes/scene3.tscn"
	get_tree().root.add_child(loading)
	get_tree().current_scene.queue_free()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skip"):
		var loading := preload("res://Scenes/loading.tscn").instantiate()
		loading.next_scene_path = "res://Scenes/scene3.tscn"
		get_tree().root.add_child(loading)
		get_tree().current_scene.queue_free()
	
