extends Area3D

@export var forward_speed: float = 15.0
@export var x_drift_speed: float = 5.0

@onready var explosion: GPUParticles3D = $Explosion
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

var velocity: Vector3

func _ready() -> void:
	velocity = Vector3(
		randf_range(-x_drift_speed, x_drift_speed),
		0,
		-forward_speed
	)
	explosion.emitting = false

func _process(delta: float) -> void:
	global_position += velocity * delta
	
	# Лёгкое преследование игрока по X
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var target_x = (player.position.x - position.x) * 2.0
		velocity.x = lerp(velocity.x, target_x, 0.05)
	
	# Удаляем, если улетела
	if position.z < -20:
		queue_free()

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		print("Комета попала в игрока!")
		explode()

func explode() -> void:
	# Отключаем коллизию и скрываем меш (отложенно)
	collision_shape.call_deferred("set_disabled", true)
	mesh.call_deferred("set_visible", false)
	
	if explosion:
		explosion.global_position = global_position
		explosion.global_rotation = Vector3.ZERO
		explosion.restart()
		explosion.emitting = true
	
	# Самоуничтожение после взрыва
	await get_tree().create_timer(1.2).timeout
	queue_free()
