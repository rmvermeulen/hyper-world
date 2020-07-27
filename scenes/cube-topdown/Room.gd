extends Node2D


func _ready():
	$Label.rect_position = $Label.rect_size * -0.5
