extends CharacterBody2D

var paddleVelocity := Vector2.ZERO
var lockedYAxis: float
var is_active := true

@onready var animatedSprite = $AnimatedSprite2D
@onready var bounceSound = $BounceSound

func _ready() -> void:
	lockedYAxis = global_position.y

func _physics_process(delta: float) -> void:
	var prev_pos = global_position

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		velocity.x = direction * GameManager.speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, GameManager.speed)
	
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

	if body.is_in_group("Ball"):
		bounceSound.pitch_scale = randf_range(1, 1.5)
		bounceSound.play()
	
	is_active = false
	animatedSprite.play("hit")


func _on_area_2d_body_exited(body: Node2D) -> void:
	is_active = false
	animatedSprite.play("idle")


func _on_exp_detaction_body_entered(body: Node2D) -> void:
	if body.is_in_group("Exp"):
        # Access the 'type' variable directly from the orb's script
		var item_type = body.get("type") 
        
		if item_type == "heal":
			print("Paddle collected a HEAL!")
			#TODO: Refactor this
			GameManager.heal(1)
		else:
			print("Paddle collected XP!")
			GameManager.addExp(10) # Your custom XP amount
		
		# Visual feedback
		# animatedSprite.play("hit")
		
		# Remove the orb so it doesn't stay on screen
		body.queue_free()
