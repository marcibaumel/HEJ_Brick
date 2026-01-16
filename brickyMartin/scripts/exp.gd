extends RigidBody2D

func _ready():
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _exit_tree() -> void:
	print("Exp exited the scene tree")

func _on_screen_exited() -> void:
	queue_free()