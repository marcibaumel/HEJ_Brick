extends CanvasLayer

@onready var container = $HBoxContainer
@export var ability_button_scene: PackedScene = preload("res://scenes/ability_button.tscn")

var abilities_data = []

func _ready() -> void:
	visible = false
	load_abilities_json()

func load_abilities_json() -> void:
	var file_path = "res://abilities.json"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json_text = file.get_as_text()
		abilities_data = JSON.parse_string(json_text)

func show_update_scene() -> void:
	for child in container.get_children():
		child.queue_free()
	
	var available_options = abilities_data.duplicate()
	available_options.shuffle()
	
	var count = min(3, available_options.size())
	for i in range(count):
		create_button(available_options[i])

	visible = true
	get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				_select_button_by_index(0)
			KEY_2:
				_select_button_by_index(1)
			KEY_3:
				_select_button_by_index(2)

func _select_button_by_index(index: int) -> void:
	if container.get_child_count() > index:
		var button = container.get_child(index) as Button
		if button:
			button.pressed.emit()

func create_button(data: Dictionary) -> void:
	var btn = ability_button_scene.instantiate()
	btn.text = data["display_text"]
	container.add_child(btn)
	
	# Connect the signal dynamically using a lambda or bind, this is bullshit
	btn.pressed.connect(_on_ability_selected.bind(data["method"]))

func _on_ability_selected(method_name: String) -> void:
	var level = get_tree().current_scene
	
	#FIXME: Great hack
	if level.has_method(method_name):
		level.call(method_name)
	
	visible = false
	get_tree().paused = false