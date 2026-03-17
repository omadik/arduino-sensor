extends StaticBody3D

@onready var player = get_tree().get_first_node_in_group("player")


func _process(delta):
	#position.y -= 3 * delta
	
	if player and position.y < player.position.y - 20:
		queue_free()
		print("Скюшал Члёпика")
	
	if player.position.y < -5:
		print("ааааааа падаю XavierSoBased")
	
	for child in get_children():
		if child is StaticBody3D and child.position.y < player.position.y - 30:
			print("ааааааа падаю")
			child.queue_free()
		
