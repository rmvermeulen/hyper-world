extends Control


func _ready():
	find_node("ButtonStart").grab_focus()


func _on_ButtonStart_pressed():
	assert(OK == get_tree().change_scene("res://scenes/tesseract-fps/HyperWorld.tscn"))


func _on_ButtonExit_pressed():
	get_tree().quit()


func _on_ButtonLoad_pressed():
	pass  # Replace with function body.


func _on_ButtonSave_pressed():
	pass  # Replace with function body.
