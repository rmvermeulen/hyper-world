extends Control

# the list of maps to display in the menu
export (Array, PackedScene) var maps := []

onready var exit_button: Button = find_node("ButtonExit")
onready var button_container: Container = exit_button.get_parent()


func _ready():
	prints(maps)

	# create buttons for each map
	for i in maps.size():
		var map = maps[i]
		var button := exit_button.duplicate()
		# change text (use resource name/path)
		if map.resource_name.length() > 0:
			button.text = map.resource_name
		else:
			var tail: String = map.resource_path.substr(map.resource_path.find_last("/") + 1)
			button.text = tail.substr(0, tail.length() - 5)
		# change shortcut
		button.shortcut = _get_shortcut(i)
		# connect 'pressed'
		assert(OK == button.connect("pressed", self, "_on_button_pressed", [i]))
		button_container.add_child(button)

	# final order = [...maps, exit button]
	var last_index = button_container.get_child_count() - 1
	button_container.move_child(exit_button, last_index)
	assert(exit_button.get_index() != 0)

	# focus whatever is first
	button_container.get_child(0).grab_focus()


func _get_shortcut(index: int) -> ShortCut:
	var event = InputEventKey.new()
	event.pressed = true
	match index:
		0:
			event.scancode = KEY_1
		1:
			event.scancode = KEY_2
		2:
			event.scancode = KEY_3
		3:
			event.scancode = KEY_4
		4:
			event.scancode = KEY_5
		5:
			event.scancode = KEY_6
		6:
			event.scancode = KEY_7
		7:
			event.scancode = KEY_8
		8:
			event.scancode = KEY_9
		9:
			event.scancode = KEY_0
		_:
			return ShortCut.new()
	var shortcut = ShortCut.new()
	shortcut.shortcut = event
	return shortcut


func _on_button_pressed(index: int) -> void:
	var new_scene: PackedScene = maps[index]
	assert(OK == get_tree().change_scene_to(new_scene))


func _exit_game():
	get_tree().quit()
