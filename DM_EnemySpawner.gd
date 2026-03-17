extends Node3D

@export var spawn_interval: float = 1.2  # секунды между спавном
@export var comet_speed: float = 20.0     # скорость полёта комет

var spawn_timer: Timer
var score: int = 0

func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(spawn_comet)
	add_child(spawn_timer)
	spawn_timer.start()
	
	# Таймер для счёта
	var score_timer = Timer.new()
	score_timer.wait_time = 1.0
	score_timer.timeout.connect(_increase_score)
	add_child(score_timer)
	score_timer.start()

func spawn_comet() -> void:
	var comet = preload("res://Comet.tscn").instantiate()
	
	# Спавн в зоне видимости (Z = 15–25, чтобы сразу видно)
	comet.position = Vector3(
		randf_range(0, 0),
		randf_range(0, 0),
		randf_range(15, 25)
	)
	
	# Случайный размер
	comet.scale = Vector3.ONE * randf_range(0.7, 1.3)
	
	
	get_tree().root.get_node("Node3D").add_child(comet)
	
	
	

func _increase_score() -> void:
	score += 1
	get_tree().root.get_node("Node3D/UI/ScoreLabel").text = "Score: " + str(score)
