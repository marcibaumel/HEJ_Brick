extends Control

@onready var level = $"root/CustomLevel"



func _on_resume_pressed() -> void:
	if owner and owner.has_method("pauseMenu"):
		owner.pauseMenu()


func _on_quit_pressed() -> void:
	get_tree().quit()
