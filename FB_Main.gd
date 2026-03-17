extends Node3D

@export var speed := 5.0
@export var debug_mode: bool = true


@onready var mesh = $Player/PlayerMesh
@onready var debug_label = $UI/DistanceLabel


#var health: int = 3
var is_dead: bool = false
var velocity: Vector3 = Vector3.ZERO




func _process(delta):
	position.x -= speed * delta

	#if position.x < -15:
		#queue_free()
	if $Player.position.y < -20:
		die()
	


func _on_hit(body: Area3D):
	if body.is_in_group("enemy"):
		#health -= 1
		#update_debug_label()
		die()
		#if mesh.material_override:
		#	mesh.material_override.albedo_color = Color.RED
			
		#if health <= 0:
			


func die():
	is_dead = true
	#velocity.y = -5.0  # Падение вниз
	set_physics_process(true)  # Продолжай физику для падения

	# Останавливаем спавн труб и движение
	get_tree().paused = true  # Пауза всей сцены

	# Показ UI
	var ui = preload("res://UI/GameOverUI.tscn").instantiate()

	get_tree().root.add_child(ui)
	ui.show_ui()

	await ui.continue_pressed
	ui.queue_free()
	get_tree().paused = false
	get_tree().reload_current_scene()

func update_debug_label():
	if debug_label:
		debug_label.text = "Debug: " + ("ON" if debug_mode else "OFF") + " | Health: " + str(is_dead)
