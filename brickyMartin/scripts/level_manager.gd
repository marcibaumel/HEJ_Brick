extends Node

func _process(_delta):
	if get_child_count() == 0:
		pass

func _input(event):
	if event.is_action_pressed("destroy_children"):
		GameManager.levelUp()
	
