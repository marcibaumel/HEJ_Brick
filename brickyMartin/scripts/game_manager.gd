extends Node

var score = 0
var level = 1
var _exp_points = 0
var maxHealth = 5
var health = 5

func _process(delta: float) -> void:
	var current_scene = get_tree().current_scene
	var is_menu = current_scene != null and current_scene.name == "MainMenu"

	if is_menu:
		$CanvasLayer.visible = false
	else:
		$CanvasLayer.visible = true
		$CanvasLayer/Score.text = str(score)
		$CanvasLayer/Level.text = "Health: " + str(health)
	
	if DevMode.is_dev_mode:
		$CanvasLayer/Mode.text = "DEV MODE"
	else:
		$CanvasLayer/Mode.text = "NORMAL MODE"


func addExp(points: int) -> void:
	# Scale points based on level (increase by 10% per level)
	var scaled_points = points
	if level > 1:
		scaled_points = int(points * (1.0 + (level - 1) * 0.1))
	
	_exp_points += scaled_points
	score += scaled_points
	if _exp_points >= level * 10:
		_exp_points = 0
		levelUp()

func _input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()

func levelUp() -> void:
	level += 1
	print("Level up! New level:", level)
	$UpdateScene.show_update_scene()

func increaseMaxHealth(amount: int) -> void:
	maxHealth += amount

func reduceHealth(amount: int) -> void:
	var currentHealth = health - amount
	if(currentHealth <= 0):
		#TODO: Add proper game over window
		score = 0
		level = 1
		health = maxHealth
		get_tree().reload_current_scene()
	else:
		health = currentHealth

func heal(amount: int) -> void:
	var currentHealth = health + amount
	if(currentHealth > maxHealth):
		health = maxHealth
	else:
		health = currentHealth