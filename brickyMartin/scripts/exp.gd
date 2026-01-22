extends RigidBody2D

var type = "xp" # Default to XP

func _ready():
	# Cleanly connect the screen notifier
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)
	
	# Make sure "Contact Monitor" is ON and "Max Contacts Reported" is at least 1 
	# in the Inspector for the body_entered signal to work!
	body_entered.connect(_on_body_entered)

# This is called by the Brick script right after spawning
func init_item(new_type: String, new_color: Color):
	type = new_type
	$Sprite2D.modulate = new_color

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Paddle"):
		if type == "heal":
			GameManager.heal(2)
		else:
			# We just send '1'. Your GameManager already 
			# handles the Level scaling math inside addExp()
			GameManager.addExp(1)
		
		queue_free()

func _on_screen_exited() -> void:
	queue_free()