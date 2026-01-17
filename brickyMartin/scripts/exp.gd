extends RigidBody2D

func _ready():
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)
	_apply_level_based_color()

func _apply_level_based_color() -> void:
	# Find the GameManager node
	var game_manager = get_tree().root.get_child(0).get_node_or_null("GameManager")
	if game_manager == null:
		return
	
	var current_level = game_manager.level
	var colors = []
	
	# Base color (level 1-4)
	colors.append(Color(0.236926, 0.658457, 0.827326, 1))  # Blue
	
	# Level 5-9
	if current_level >= 5:
		colors.append(Color(0.8, 0.3, 0.9, 1))  # Purple
	
	# Level 10-14
	if current_level >= 10:
		colors.append(Color(1.0, 0.84, 0.0, 1))  # Gold
	
	# Level 15+
	if current_level >= 15:
		colors.append(Color(1.0, 0.2, 0.2, 1))  # Red
	
	if colors.size() > 0:
		var random_color = colors[randi() % colors.size()]
		$Sprite2D.modulate = random_color

func _exit_tree() -> void:
	print("Exp exited the scene tree")
	# Award experience points when orb is collected/removed
	var game_manager = get_tree().root.get_child(0).get_node_or_null("GameManager")
	if game_manager != null:
		var base_points = 1
		# Scale points based on current level (10% increase per level)
		var scaled_points = base_points
		if game_manager.level > 1:
			scaled_points = int(base_points * (1.0 + (game_manager.level - 1) * 0.1))
		game_manager.addExp(scaled_points)

func _on_screen_exited() -> void:
	queue_free()