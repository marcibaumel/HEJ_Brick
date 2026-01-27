extends Control

@onready var volume_slider: Slider = $MarginContainer/VBoxContainer/VolumeSlider
var sound = GameManager.audioLevel

func _ready() -> void:
	# Initialize slider position to current game volume
	volume_slider.value = sound
	if volume_slider:
		volume_slider.value = GameManager.audioLevel
		volume_slider.value_changed.connect(_on_volume_slider_value_changed)


func _on_resume_pressed() -> void:
	if owner and owner.has_method("pauseMenu"):
		owner.pauseMenu()


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_volume_slider_value_changed(value: float) -> void:
	GameManager.audioLevel = value
