extends CharacterBody2D

const SPEED = 1000.0
var paddleVelocity := Vector2.ZERO
var lockedYAxis: float

func _ready() -> void:
	lockedYAxis = global_position.y

func _physics_process(delta: float) -> void:
	var prev_pos = global_position

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	velocity.y = 0.0  # don't accumulate y velocity
	move_and_slide()

	# hard lock y position, this is a hack but it works 
	global_position.y = lockedYAxis

	paddleVelocity = (global_position - prev_pos) / delta
	paddleVelocity.y = 0
