extends AnimatedSprite2D

@export var radius := 55.0
@export var thickness := 4.0

func _draw():
	# --- 1. XP CALCULATION (The Outer Ring) ---
	var max_xp = GameManager.level * 10
	var xp_ratio = float(GameManager._exp_points) / float(max_xp)
	xp_ratio = clamp(xp_ratio, 0.0, 1.0)
	
	# Draw a faint "background" track for the XP so it's not invisible when empty
	draw_arc(Vector2.ZERO, radius, 0, TAU, 64, Color(Color.SKY_BLUE, 0.1), thickness, true)
	
	# Draw the actual XP progress
	draw_arc(
		Vector2.ZERO,
		radius,
		-PI / 2, # Start at the top
		(-PI / 2) + (TAU * xp_ratio), 
		64,
		Color.SKY_BLUE,
		thickness,
		true
	)

	# --- 2. HEALTH CALCULATION (The Inner Fill) ---
	var health_ratio = float(GameManager.health) / float(GameManager.maxHealth)
	health_ratio = clamp(health_ratio, 0.0, 1.0)
	
	var fill_color = Color(Color.SKY_BLUE, 0.3) # More transparent fill
	
	draw_arc(
		Vector2.ZERO, 
		(radius - thickness) / 2, 
		-PI / 2, 
		(-PI / 2) + (TAU * health_ratio), 
		64, 
		fill_color, 
		radius - thickness, # Fills the inside
		true
	)

func _process(_delta: float) -> void:
	queue_redraw()