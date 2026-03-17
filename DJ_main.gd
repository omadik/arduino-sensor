extends Node3D   # ← вот так

@export var platform_scene: PackedScene = preload("res://DJ_Platform.tscn")
@export var spawn_interval := 1.2
@export var spawn_ahead: float = 30.0  # Спавнить на 30 единиц выше игрока

@onready var player = get_tree().get_first_node_in_group("player")


var last_spawn_y: float = 0.0
var timer: Timer

func _ready():
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(spawn_platform)
	add_child(timer)
	spawn_platform()  # первая сразу
	
func _process(_delta):
	if player == null:
		return  # или print("Player not found!")
	position.y = lerp(position.y, player.position.y + 3, 0.1)
	if player.position.y > last_spawn_y + spawn_ahead:
		spawn_platform()
	last_spawn_y = player.position.y

func spawn_platform():
	var p = platform_scene.instantiate()
	p.position = Vector3(
		randf_range(-3, 8),
		last_spawn_y + randf_range(5, 8),  # Чуть выше предыдущей
		0
	)
	add_child(p)
	print("Spawned platform at :", last_spawn_y)
	print("Player Pos:", player.position.y)
