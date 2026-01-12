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
			velocity = velocity.bounce(collision.get_normal())
			
			if collider.is_in_group("paddles"):
				var paddle_rotation = collider.rotation_degrees
				velocity.x += paddle_rotation * 2
			
			if collision.get_collider().has_method("hit"):
			#I don't like this :(
				collision.get_collider().hit()
			
			# TODO: For maintain speed, I need to check somehow how this is working 
			velocity = velocity.normalized() * speed
			
		if (velocity.y > 0 and velocity.y < 100):
			velocity.y = -200
		
		if velocity.x == 0:
			velocity.x = -200
		

func gameOver() -> void:
	GameManager.score = 0
	GameManager.level = 1
	get_tree().reload_current_scene()

# TODO: make sure if we copy the level the signal stay as it is
func _on_deadzone_body_entered(body: Node2D) -> void:
	gameOver()
