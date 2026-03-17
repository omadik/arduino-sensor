extends Camera3D

@onready var player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	#print("Camera follows player y:", player.position.y)
	if player:
		position.y = lerp(position.y, player.position.y + 3, 0.15)
		position.x = lerp(position.x, player.position.x, 0.1)
