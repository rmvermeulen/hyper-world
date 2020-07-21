extends Button


func _input(event: InputEvent):
	if not (event is InputEventKey):
		return
	if event.scancode == KEY_ESCAPE:
		grab_focus()
		pressed = true
		emit_signal("pressed")
