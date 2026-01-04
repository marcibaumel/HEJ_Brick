extends RigidBody2D

@export var health = 1;
@export var enableDoubleHealth: bool = false
@export var enableAbilitiyDoubleBall: bool = false

var baseColour = "#ffffff"

func _ready() -> void:
	if enableDoubleHealth:
		$Sprite2D.modulate = "#cf6fe2"
		health = 2


func hit() -> void:
	health -= 1
	if health < 1:
		destroyBrick()
	else:
		$Sprite2D.modulate = baseColour

func destroyBrick() -> void:
	GameManager.addPoints(1)
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	$CPUParticles2D.emitting = true
		
	await get_tree().create_timer(0.5).timeout
	queue_free()
