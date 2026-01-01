extends RigidBody2D

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

func hit() -> void:
	
	GameManager.addPoints(1)
	
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	$CPUParticles2D.emitting = true
	
	var bricksLeft = get_tree().get_nodes_in_group('Brick')
	if bricksLeft.size() == 1:
		get_parent().get_node("Ball").is_active = false
		await get_tree().create_timer(1).timeout
		GameManager.level += 1
		get_tree().reload_current_scene()
	else:
		await get_tree().create_timer(1).timeout
		queue_free()
