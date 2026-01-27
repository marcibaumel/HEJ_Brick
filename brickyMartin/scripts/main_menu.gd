extends Control

@onready var volume_slider = $VolumeSlider

func _ready() -> void:
	# Initialize slider position to current game volume
	if volume_slider:
		volume_slider.value = GameManager.audioLevel
		volume_slider.value_changed.connect(_on_volume_slider_value_changed)

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/customLevel.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_volume_slider_value_changed(value: float) -> void:
	GameManager.audioLevel = value