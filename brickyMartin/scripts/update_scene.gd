extends CanvasLayer

func _ready() -> void:
	visible = false

func _on_button_pressed() -> void:
	var level := get_tree().current_scene
	if level.has_method("add_ball"):
		level.add_ball()

	visible = false
	get_tree().paused = false

func show_update_scene() -> void:
	visible = true
	get_tree().paused = true
