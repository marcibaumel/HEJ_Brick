extends CharacterBody2D

var speed = 500 + (20 * GameManager.level)
var dir = Vector2.DOWN
var isActive= true

func _ready() -> void:
	velocity = Vector2(speed * -1, speed)

func _physics_process(delta: float) -> void:
	if isActive:
		var collision = move_and_collide(velocity * delta)
		
		if collision:
			var collider = collision.get_collider()
			
			# Check if this is a brick
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit()
				# If brick was destroyed, just pass through without bouncing
				if collider.is_destroyed:
					return
			
			# Bounce off the collision
			velocity = velocity.bounce(collision.get_normal())
			
			if collider.is_in_group("paddles"):
				var paddle_rotation = collider.rotation_degrees
				velocity.x += paddle_rotation * 2
			
			# TODO: For maintain speed, I need to check somehow how this is working 
			velocity = velocity.normalized() * speed
			
		if (velocity.y > 0 and velocity.y < 100):
			velocity.y = -200
		
		if velocity.x == 0:
			velocity.x = -200