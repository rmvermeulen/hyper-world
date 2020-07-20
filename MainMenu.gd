extends Control

func _ready():
	# todo: remove
	_on_Button2D_pressed() # skip waiting

func _on_Button2D_pressed():
	get_tree().change_scene("res://cube3_map_2d/MainScene.tscn")


func _on_Button3D_pressed():
	get_tree().change_scene("res://cube3_map_3d/MainScene.tscn")


func _on_Button4D_pressed():
	get_tree().change_scene("res://cube4_map_3d/MainScene.tscn")


func _on_ButtonExit_pressed():
	get_tree().quit()
