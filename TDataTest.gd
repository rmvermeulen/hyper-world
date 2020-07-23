extends Spatial

const TData := preload("res://cube4_map_3d/TData.gd")


func _ready():
	var data = TData.new()
	prints(data)
	if data.is_valid():
		prints("Valid data!")
	else:
		printerr("ERROR! ERROR!")
	get_tree().quit()
