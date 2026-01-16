extends Node

var score = 0
var level = 1
var exp_points = 0


func addPoints(points: int) -> void:
	score += points

func _process(delta: float) -> void:
	var current_scene = get_tree().current_scene
	var is_menu = current_scene != null and current_scene.name == "MainMenu"

	if is_menu:
		$CanvasLayer.visible = false
	else:
		$CanvasLayer.visible = true
		$CanvasLayer/Score.text = str(score)
		$CanvasLayer/Level.text = "Level: " + str(level)
	
	if DevMode.is_dev_mode:
		$CanvasLayer/Mode.text = "DEV MODE"
	else:
		$CanvasLayer/Mode.text = "NORMAL MODE"

func addExp(points: int) -> void:
	exp_points += points
	if exp_points >= level * 10:
		exp_points = 0
		level += 1
		print("Level up! New level:", level)

func _input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
