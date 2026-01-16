extends CharacterBody2D

const SPEED = 1000.0
var paddleVelocity := Vector2.ZERO
var lockedYAxis: float
var is_active := true

@onready var animatedSprite = $AnimatedSprite2D

func _ready() -> void:
	lockedYAxis = global_position.y

func _physics_process(delta: float) -> void:
	var prev_pos = global_position

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
	
	# TODO: unify the movement logic
	
	if velocity.x > 0:
		rotation_degrees = 10
		
	if velocity.x < 0:
		rotation_degrees = - 10
		
	if velocity.x == 0:
		rotation_degrees = 0

	velocity.y = 0.0  # don't accumulate y velocity
	move_and_slide()

	# hard lock y position, this is a hack but it works 
	global_position.y = lockedYAxis

	paddleVelocity = (global_position - prev_pos) / delta
	paddleVelocity.y = 0

func interact_with_ball() -> void:
	animatedSprite.play("hit")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Exp"):
		print("exp detected!")
	
	is_active = false
	animatedSprite.play("hit")


func _on_area_2d_body_exited(body: Node2D) -> void:
	is_active = false
	animatedSprite.play("idle")


func _on_exp_detaction_body_entered(body:Node2D) -> void:
	print("Paddle touched:", body.name, " groups:", body.get_groups())
	if body.is_in_group("Exp"):
		print("Paddle collected exp!")
		GameManager.addExp(10)
	body.queue_free()

