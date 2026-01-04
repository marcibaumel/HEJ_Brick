extends Node

var score = 0
var level = 1

func addPoints(points: int) -> void:
	score += points

func _process(delta: float) -> void:
	$CanvasLayer/Score.text = str(score)
	$CanvasLayer/Level.text = "Level: " + str(level)

func _input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
