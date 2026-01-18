extends StaticBody2D

@export var health = 1;
@export var enableDoubleHealth: bool = false
@export var enableAbilitiyDoubleBall: bool = false
@export var exp_scene: PackedScene = preload("res://scenes/exp.tscn")

var baseColour = "#ffffff"
var is_destroyed = false

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
	is_destroyed = true
	spawn_exp()

	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	$CPUParticles2D.emitting = true
	
	# Disable the rigid body so it doesn't push the ball back
	set_collision_layer(0)
	set_collision_mask(0)
		
	await get_tree().create_timer(0.5).timeout
	queue_free()

func spawn_exp() -> void:
	if exp_scene == null:
		return

	var exp := exp_scene.instantiate()
	get_parent().add_child(exp)

	# Place it where the brick was
	exp.global_position = global_position


func _on_paddle_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Paddle"):
		queue_free()
