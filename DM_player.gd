extends CharacterBody3D

@onready var mesh = $PlayerMesh
@onready var hit_area = $HitArea
@onready var debug_label = $"../UI/DistanceLabel"
@onready var game_over_ui = preload("res://UI/GameOverUI.tscn").instantiate()

@export var speed: float = 5.0
@export var max_health: int = 3
@export var debug_mode: bool = true

var health: int
var input_dir: float = 0.0
var target_x: float = 0.0
var is_dead: bool = false
var hit_flash_timer: Timer

func _ready():
	if mesh.material_override == null:
		mesh.material_override = StandardMaterial3D.new()
		mesh.material_override.albedo_color = Color.WHITE
	
	health = max_health
	ArduinoBridge.distance_changed.connect(_on_distance_changed)
	#hit_area.area_entered.connect(_on_hit_area_area_entered)
	#add_to_group("player")
	
	hit_flash_timer = Timer.new()
	hit_flash_timer.wait_time = 0.2
	hit_flash_timer.one_shot = true
	hit_flash_timer.timeout.connect(_flash_end)
	add_child(hit_flash_timer)
	
	update_debug_label()
	
	

func _input(event):
	if event.is_action_pressed("toggle_debug"):
		debug_mode = !debug_mode
		update_debug_label()
		print("Debug mode: ", "ON" if debug_mode else "OFF")

func update_debug_label():
	if debug_label:
		debug_label.text = "Debug: " + ("ON" if debug_mode else "OFF") + " | Health: " + str(health)

func _physics_process(_delta):
	velocity = Vector3.ZERO
	
	if debug_mode:
		input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		target_x = position.x + input_dir * speed
	else:
		# Сенсор обновляет target_x в _on_distance_changed
		pass
	
	velocity.x = (target_x - position.x) * speed
	move_and_slide()
	
	position.x = clamp(position.x, -8.0, 8.0)
	position.y = 0.0
	position.z = 0.0

func _on_distance_changed(dist: float):
	if debug_mode:
		return
	var normalized = clamp((dist - 5.0) / 55.0, 0.0, 1.0)
	target_x = lerp(-8.0, 8.0, normalized)
	velocity.x = (target_x - position.x) * speed

func _on_hit_area_area_entered(area: Area3D):
	print("HitArea: ", area.name)
	if area.is_in_group("comets"):
		health -= 1
		print("Health: ", health)
		
		if mesh.material_override:
			mesh.material_override.albedo_color = Color.RED
			hit_flash_timer.start()
		
		update_debug_label()
		
		if health <= 0:
			die()

func _flash_end():
	if mesh.material_override:
		mesh.material_override.albedo_color = Color.WHITE

func die():
	
	is_dead = true
	
	#set_physics_process(false)
	#velocity = Vector3.ZERO

	$HitArea/PlayerCollision.set_deferred("disabled", true)
	visible = false
	
	
	print("Game Over!")
	
	add_child(game_over_ui)
	game_over_ui.show_ui()
	
	await game_over_ui.continue_pressed
	
	game_over_ui.queue_free()  # Удаляем UI перед reload
	get_tree().reload_current_scene()


func show_game_over_ui():
	get_tree().root.add_child(game_over_ui)
#	game_over_ui.cont.pressed.connect(_on_continue)
#	game_over_ui.quit.pressed.connect(_on_quit)

#func _on_continue():
#	get_tree().reload_current_scene()

#func _on_quit():
#	get_tree().quit
