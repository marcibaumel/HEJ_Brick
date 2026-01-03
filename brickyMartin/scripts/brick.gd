extends RigidBody2D

var health = 1;
signal brickDestroyed
@export var enableDoubleHealth: bool = false:
	set(value):
		enableDoubleHealth = value

func _ready() -> void:
	if enableDoubleHealth:
		health = 2

func _process(delta: float) -> void:
	pass

func hit() -> void:
	health -= 1
	if health < 1:
		GameManager.addPoints(1)
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
		$CPUParticles2D.emitting = true
		
		var bricksLeft = get_tree().get_nodes_in_group('Brick')
		if bricksLeft.size() == 1:
			get_parent().get_node("ball").visible = false
			await get_tree().create_timer(1).timeout
			GameManager.level += 1
			get_tree().reload_current_scene()
		else:
			await get_tree().create_timer(0.5).timeout
			emit_signal("brickDestroyed")
			queue_free()
