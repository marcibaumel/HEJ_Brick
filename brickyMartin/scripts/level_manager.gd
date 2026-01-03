extends Node

func _ready() -> void:
	#TODO: Setup signal connection
	connect("brickDestroyed", levelManager)
	

func levelManager() -> void:
	var bricksLeft = get_tree().get_nodes_in_group('Brick')
	print(bricksLeft.str())
