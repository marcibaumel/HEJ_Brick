extends Node

func _process(_delta):
	if get_child_count() == 0:
		print("lofasz")

func _input(event):
	if event.is_action_pressed("destroy_children"):
		for child in get_children():
			child.queue_free()
