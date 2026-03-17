extends CharacterBody3D

@export var gravity := 20.0
@export var flap_force := 1.0
@export var debug_mode: bool = true

@onready var mesh = $PlayerMesh
#@onready var debug_label = $"../UI/DistanceLabel"



#var health: int = 3
var is_dead: bool = false


func _physics_process(delta):

	velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump"):
		velocity.y = flap_force * randf_range(2.0, 6.0)
	
	move_and_slide()
	




#func die():
#	print("Player died!")
#	queue_free()  # Удаляет игрока
	#get_tree().reload_current_scene()
	

#func update_debug_label():
#	if debug_label:
#		debug_label.text = "Debug: " + ("ON" if debug_mode else "OFF") + " | Health: " + str(health)
