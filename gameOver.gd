extends Control
@onready var cont = $cont
@onready var quit = $quit


signal continue_pressed
signal quit_pressed

func _ready():
	cont.pressed.connect(continue_pressed.emit)
	quit.pressed.connect(quit_pressed.emit)
	visible = false
	

func show_ui():
	visible = true


#func _on_continue():
	#get_tree().reload_current_scene()

func _on_quit():
	get_tree().quit()
