extends CanvasLayer

@onready var debug_label = $DistanceLabel
@onready var score_label = $ScoreLabel



func update_distance(dist: float):
	debug_label.text = "Dist: " + str(dist) + " mm"

func update_score(score: int):
	score_label.text = "Score: " + str(score)
