tool
extends Spatial

onready var screen := $ConsoleShape/Screen


func _ready():
	screen.set_indexed(":mesh:material:albedo_texture", $Viewport.get_texture())
