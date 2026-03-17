extends Node3D

@export var pipe_scene: PackedScene = preload("res://FB_Pipes.tscn")
@export var spawn_interval := 2.0
@export var spawn_x := 15.0



func _ready():
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_pipes)
	add_child(timer)
	timer.start()

	spawn_pipes()

func spawn_pipes():
	var gap = randf_range(10.0, 13.0)  # размер проёма
	var center = randf_range(-3.0, 3.0)  # центр зазора

	var upper = pipe_scene.instantiate()
	upper.position.y = center + gap / 2 + 2.0  # верхняя труба выше центра

	var lower = pipe_scene.instantiate()
	lower.position.y = center - gap / 2 - 2.0  # нижняя ниже центра

	upper.position.x = spawn_x
	lower.position.x = spawn_x

	add_child(upper)
	add_child(lower)
