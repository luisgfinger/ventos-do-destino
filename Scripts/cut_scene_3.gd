extends Node2D

func _ready() -> void:
	$DialogBG.visible = false
	$PlayerAnimation.play("playerMove")
	
	await $PlayerAnimation.animation_finished
	
	$DialogBG/Dialogs/DialogsAnimation.play("Dialog_Animation")
	$DialogBG.visible = true
	$DialogBG/Dialogs/Dialog1.start_typing()
	
	await get_tree().create_timer(5.0).timeout
	
	$DialogBG/Dialogs/Dialog1.visible = false
	$DialogBG.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	$DialogBG/Dialogs/DialogsAnimation.play("DialogAnimation2")
	$DialogBG.visible = true
	$DialogBG/Dialogs/Dialog2.start_typing()
	
	await get_tree().create_timer(7.0).timeout
	
	$DialogBG.visible = false
	$DialogBG/Dialogs/Dialog2.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	$DialogBG/Dialogs/DialogsAnimation.play("Dialog_Animation")
	$DialogBG.visible = true
	$DialogBG/Dialogs/Dialog3.start_typing()
	
	await get_tree().create_timer(8.0).timeout
	
	var loading := preload("res://Scenes/loading.tscn").instantiate()
	loading.next_scene_path = "res://Scenes/scene2.tscn"
	get_tree().root.add_child(loading)
	get_tree().current_scene.queue_free()
	
