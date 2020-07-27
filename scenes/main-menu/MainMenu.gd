extends Control

export (PackedScene) var map_2d
export (PackedScene) var map_3d
export (PackedScene) var map_4d

onready var button_2d := find_node("Button2D")
onready var button_3d := find_node("Button3D")
onready var button_4d := find_node("Button4D")


func _ready():
	button_2d.disabled = ! map_2d
	button_3d.disabled = ! map_3d
	button_4d.disabled = ! map_4d

	prints("map 2d", map_2d)
	prints("map 3d", map_3d)
	prints("map 4d", map_4d)

	button_2d.grab_focus()


func _on_Button2D_pressed():
	get_tree().change_scene_to(map_2d)


func _on_Button3D_pressed():
	get_tree().change_scene_to(map_3d)


func _on_Button4D_pressed():
	get_tree().change_scene_to(map_4d)


func _on_ButtonExit_pressed():
	get_tree().quit()
