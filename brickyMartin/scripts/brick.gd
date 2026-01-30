extends StaticBody2D

@export var health = 1;
@export var enableDoubleHealth: bool = false
@export var enableAbilitiyDoubleBall: bool = false
@export var exp_scene: PackedScene = preload("res://scenes/exp.tscn")

@onready var destroySound = $DestroySound

@onready var animation = $AnimatedSprite2D

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
	animation.visible = false
	$CollisionShape2D.disabled = true
	$CPUParticles2D.emitting = true
	
	# Disable the rigid body so it doesn't push the ball back
	set_collision_layer(0)
	set_collision_mask(0)
	destroySound.pitch_scale = randf_range(0.5, 1)
	destroySound.play()
	await get_tree().create_timer(0.5).timeout
	queue_free()

func spawn_exp() -> void:
	if exp_scene == null: return

	var drop := exp_scene.instantiate()
	get_parent().add_child(drop)
	drop.global_position = global_position

	# CHANGED: randf() < 0.2 means a 20% chance for heal. 
	# If you leave it at 1.0, it will ALWAYS be a heal.
	if randf() < 0.5:
		drop.init_item("heal", Color.CHARTREUSE)
	else:
		drop.init_item("xp", Color.SKY_BLUE)


func _on_paddle_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Paddle"):
		destroySound.play()
		queue_free()
