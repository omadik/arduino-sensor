class_name BaseGame
extends Node3D

signal game_over

var is_game_over := false

#@export var game_over_ui_scene: PackedScene = preload("res://UI/GameOverUI.tscn")
var ui = preload("res://UI/GameOverUI.tscn").instantiate()


func trigger_game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	
	set_physics_process(false)
	set_process_input(false)  # если нужно
	
	game_over.emit()
	
	#var ui = game_over_ui_scene.instantiate() as GameOverUI
	add_child(ui)                     # ← добавляем как ребёнка сцены
	ui.popup_centered()               # или просто ui.visible = true
	
	var choice = await ui.choice_made  # предполагаем сигнал choice_made(bool continue)
	ui.queue_free()
	
	if choice == true:  # continue
		reset_game()
	else:
		get_tree().change_scene_to_file("res://MainMenu.tscn")  # или quit


func reset_game() -> void:
	get_tree().reload_current_scene()   # самый простой вариант
	# или более мягкий: 
	# is_game_over = false
	# set_physics_process(true)
	# переставить игрока, очистить спавнеры и т.д.
