extends Node

var speed = 1000
var score = 0
var level = 1
var _exp_points = 0
var maxHealth = 5
var health = 5
var audioLevel: float = 0.5:
	set(value):
		audioLevel = clamp(value, 0.0, 1.0)
		_update_audio_bus()

var save_data = {
	"high_score": 0
}

const SAVE_PATH = "user://bricky/save_game.dat"

func _ready():
	print(ProjectSettings.globalize_path("user://"))
	load_game()
	_update_audio_bus()

func _update_audio_bus() -> void:
	# 0 is usually the "Master" bus index
	var bus_index = AudioServer.get_bus_index("Master")
	# Convert 0.0 -> 1.0 range to Decibels
	# linear_to_db(0) is -80 (silent), linear_to_db(1) is 0 (full)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(audioLevel))
	
	# Optional: Mute if volume is 0
	AudioServer.set_bus_mute(bus_index, audioLevel <= 0.05)

func save_game():
	var dir_path = "user://bricky"
	DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path(dir_path)
	)

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()
		print("Saved to:", ProjectSettings.globalize_path(SAVE_PATH))
	else:
		print("Failed to save game")


func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var loaded_data = file.get_var()
			file.close()

			if loaded_data is Dictionary:
				save_data.merge(loaded_data, true) 
				print("Game Loaded:", save_data)				
	

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
		
		if score > save_data["high_score"]:
			save_data["high_score"] = score
			print("New High Score!")	
		save_game()
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

func increaseSpeed(amount: int) -> void:
	speed += amount
	print("Increased speed to:", speed)
