extends Node

var score = 0
var level = 1


func addPoints(points: int) -> void:
	score += points

func _process(delta: float) -> void:
	if ProjectSettings.get_setting("application/dev_mode"):
		print("Running in dev mode")

	var current_scene = get_tree().current_scene
	var is_menu = current_scene != null and current_scene.name == "MainMenu"

	if is_menu:
		$CanvasLayer.visible = false
	else:
		$CanvasLayer.visible = true
		$CanvasLayer/Score.text = str(score)
		$CanvasLayer/Level.text = "Level: " + str(level)

func _input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
