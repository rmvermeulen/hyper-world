extends Spatial

const Data := preload("./Data.gd")


func _ready():
	var data = Data.new()
	prints(data)
	if data.is_valid():
		prints("Valid data!")
	else:
		printerr("ERROR! ERROR!")
	get_tree().quit()
