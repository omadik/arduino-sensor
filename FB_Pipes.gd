extends Node3D

@export var speed := 5.0
@export var gap := 3.5
@export var min_y := -2.5
@export var max_y := 2.5

#func _ready():
	#var center = randf_range(min_y, max_y)

	#$TopPipe.position.y = center + gap
	#$BottomPipe.position.y = center - gap

var passed = false
var score: int = 0


func _process(delta):
	position.x -= speed * delta

	if not passed and position.x < 0:
		passed = true
		print("Score +1")

	if position.x < -15:
		queue_free()
		


func _increase_score() -> void:
	score += 1
	get_tree().root.get_node("Node3D/UI/ScoreLabel").text = "Score: " + str(score)
