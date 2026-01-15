extends Node

var is_dev_mode: bool = false

func _ready() -> void:
	is_dev_mode = ProjectSettings.get_setting("application/dev_mode") or OS.get_environment("DEV_MODE") == "true"
	if is_dev_mode:
		print("Dev mode enabled")
