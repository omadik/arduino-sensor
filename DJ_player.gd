extends CharacterBody3D

@export var speed := 10.0
@export var jump_velocity := 20.0
@export var gravity := 20.0

var ui = preload("res://UI/GameOverUI.tscn").instantiate()

var is_dead: bool = false
var last_on_floor := false

func _physics_process(delta: float):
	# Гравитация
	if not is_on_floor():
		velocity.y -= gravity * delta

	 #Прыжок
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	#	velocity.y = jump_velocity
		
	#Автопрыжок при касании сверху
	if is_on_floor():
		velocity.y = jump_velocity

	# Движение влево/вправо (пока клавиши)
	var input_dir = Input.get_axis("move_left", "move_right")
	velocity.x = input_dir * speed
	
	# Прохождение снизу (отключаем коллизию снизу)
	if velocity.y > 0:  # падает вниз
		set_collision_mask_value(1, false)  # отключаем слой платформ
	else:
		set_collision_mask_value(1, true)   # включаем при прыжке вверх

	move_and_slide()

	# Камера следует за игроком по Y
	var cam = get_viewport().get_camera_3d()
	if cam:
		cam.position.y = lerp(cam.position.y, position.y + 3, 0.1)

	# Проверка, когда приземлились
	if is_on_floor() and not last_on_floor:
		# Здесь можно добавить эффект приземления позже
		pass
	last_on_floor = is_on_floor()
	
	if position.y < -20 and not is_dead:
		die()
	
	


func die():
	is_dead = true
	print("Game Over!")
	
	$PlayerCollision.set_deferred("disabled", true)
	
	visible = false
	
	get_tree().paused = true
	
	#var ui = preload("res://GameOverUI.tscn").instantiate()
	get_tree().root.add_child(ui)
	ui.show_ui()
	
	
	
	await ui.continue_pressed
	
	ui.queue_free()
	get_tree().paused = false
	get_tree().reload_current_scene()
	

	
