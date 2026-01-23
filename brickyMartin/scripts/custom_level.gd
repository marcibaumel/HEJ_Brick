extends Node2D

@onready var BrickScene: PackedScene = preload("res://scenes/bricks/brick.tscn")
@onready var BallScene: PackedScene = preload("res://scenes/ball.tscn")

@onready var ball_spawn := $BallSpawn
@onready var BrickSpawn: Node2D = get_node("BrickSpawn")

@export var margin: float = 1.0
@export var brick_width: float = 100.0
@export var brick_height: float = 100.0

@export var spawn_interval: float = 1.0
@export_range(0.0, 1.0, 0.01) var empty_chance: float = 0.15
@export var empty_means_skip_spawn: bool = true

@export var fall_speed: float = 20.0
@export var spawn_above_ceiling: float = 0.0
@export var kill_y: float = 2000.0

var ballIncrease = 1
var ballSpeedMultiplier: float = 1.0

const BRICK_GROUP := "falling_bricks"

var _rng := RandomNumberGenerator.new()
var _timer: Timer

var _grid_x := 0.0
var _grid_width := 0.0
var _spawn_y := 0.0
var _columns := 1

var _colors: Array[Color] = [
	Color(0, 1, 1, 1),
	Color(0.54, 0.17, 0.89, 1),
	Color(0.68, 1, 0.18, 1),
]


func _ready() -> void:
	pass
	_rng.randomize()
	set_physics_process(true)

	_compute_spawn_from_marker()
	_setup_timer()


func _physics_process(delta: float) -> void:
	for brick in get_tree().get_nodes_in_group(BRICK_GROUP):
		if not is_instance_valid(brick):
			continue
		if brick is Node2D:
			var b := brick as Node2D
			b.position.y += fall_speed * delta

			if kill_y > 0.0 and b.global_position.y > kill_y:
				b.queue_free()


func _setup_timer() -> void:
	_timer = Timer.new()
	_timer.one_shot = false
	_timer.wait_time = spawn_interval
	_timer.timeout.connect(_spawn_one_brick)
	add_child(_timer)
	_timer.start()


func _compute_spawn_from_marker() -> void:
	# Spawn Y is taken from your BrickSpawn marker (placed under the ceiling)
	_spawn_y = BrickSpawn.global_position.y - spawn_above_ceiling

	# Use viewport width for the spawnable horizontal region
	var viewport_w := get_viewport_rect().size.x
	_grid_x = margin
	_grid_width = viewport_w - (margin * 2.0)

	_columns = max(1, int(_grid_width / brick_width))


func _spawn_one_brick() -> void:
	var is_empty := _rng.randf() < empty_chance
	if is_empty and empty_means_skip_spawn:
		return

	var col := _rng.randi_range(0, _columns - 1)

	var brick := BrickScene.instantiate()
	add_child(brick)
	brick.add_to_group(BRICK_GROUP)

	# If your brick scene pivot is top-left, keep this.
	# If your brick pivot is centered, add +brick_width*0.5 / +brick_height*0.5.
	brick.position = Vector2(_grid_x + (brick_width * col), _spawn_y)

	if is_empty and not empty_means_skip_spawn:
		_make_brick_empty(brick)
	else:
		_colorize_brick(brick)


func _colorize_brick(brick: Node) -> void:
	var sprite := brick.get_node_or_null("Sprite2D")
	if sprite:
		sprite.modulate = _colors[_rng.randi_range(0, _colors.size() - 1)]


func _make_brick_empty(brick: Node) -> void:
	var sprite := brick.get_node_or_null("Sprite2D")
	if sprite:
		sprite.visible = false

	for c in brick.get_children():
		if c is CollisionShape2D:
			(c as CollisionShape2D).disabled = true


func _on_deadzone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		GameManager.reduceHealth(1)
		body.queue_free()
		add_ball()
		# if(GameManager.health != 0):
		# 	call_deferred("_check_balls_left")


func gameOver() -> void:
	GameManager.score = 0
	GameManager.level = 1
	get_tree().reload_current_scene()

func add_ball() -> void:
	var ball := BallScene.instantiate()
	_increase_single_ball_size(ball, ballIncrease)
	add_child(ball)
	ball.global_position = ball_spawn.global_position

	# Optional: slightly different direction
	var angle := randf_range(-0.5, 0.5)
	ball.velocity = Vector2(-1, 1).normalized().rotated(angle) * ball.speed


func increase_all_balls_speed(multiplier: float = 1.2) -> void:
	ballSpeedMultiplier *= multiplier
	for ball in get_tree().get_nodes_in_group("Ball"):
		if is_instance_valid(ball):

			if "speed" in ball:
				ball.speed *= multiplier
			
			if ball is CharacterBody2D:
				ball.velocity = ball.velocity.normalized() * ball.speed
	

func increase_max_health(amount: int = 2) -> void:
	GameManager.increaseMaxHealth(amount)

func increase_all_balls_size(multiplier: float = 1.1) -> void:
	ballIncrease *= multiplier
	for ball in get_tree().get_nodes_in_group("Ball"):
		if not is_instance_valid(ball):
			continue
		if ball is CharacterBody2D:
			_increase_single_ball_size(ball, multiplier)

func _increase_single_ball_size(ball: CharacterBody2D, multiplier: float) -> void:
	ball.scale *= multiplier

func grow_all_paddles_exp_detection(multiplier: float = 1.05) -> void:
	for paddle in get_tree().get_nodes_in_group("Paddle"):
		_grow_paddle_exp_detection(paddle, multiplier)

func _grow_paddle_exp_detection(paddle: Node, multiplier: float) -> void:
	var p := paddle as Node2D
	if not p:
		return

	var exp_detection := p.get_node_or_null("expDetaction") as Area2D
	if not exp_detection:
		return
	else:
		exp_detection.scale *= multiplier


func _check_balls_left() -> void:
	var count := 0
	# Remove invalid refs and count what's actually still alive
	for b in get_tree().get_nodes_in_group("Ball"):
		if is_instance_valid(b):
			count += 1
		
	if count == 1:
		gameOver()
