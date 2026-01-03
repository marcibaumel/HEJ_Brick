extends Node2D

@onready var brickObject = preload("res://scenes/bricks/brick.tscn")

var columns = 32
var rows = 7
var margin = 50

func _ready() -> void:
	setupLevel()

func setupLevel() -> void:
	rows = 2 + GameManager.level
	
	if rows > 9:
		rows = 9
	
	var colors = getColors() as Array
	colors.shuffle()
	
	for row in rows:
		for column in columns:
			var randomNumber = randi_range(0,2)
			if(randomNumber > 0):
				var newBrick = brickObject.instantiate()
				# newBrick.enableDoubleHealth = true
				add_child(newBrick)
				newBrick.position = Vector2(margin + (34 * column), margin + (34 * row))
				
				var sprite = newBrick.get_node('Sprite2D')
				if row <= 9:
					sprite.modulate = colors[0]
				if row < 6:
					sprite.modulate = colors[1]
				if row < 3:
					sprite.modulate = colors[2]

func getColors() -> PackedColorArray:
	var colors = [Color(0, 1, 1, 1), Color(0.54, 0.17, 0.89, 1), Color(0.68, 1, 0.18, 1)]
	return colors
