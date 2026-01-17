extends Node2D

func _on_deadzone_body_entered(body:Node2D) -> void:
	gameOver()

func gameOver() -> void:
	GameManager.score = 0
	GameManager.level = 1
	get_tree().reload_current_scene()
