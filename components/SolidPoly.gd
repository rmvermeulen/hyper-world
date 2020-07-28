tool
class_name SolidPoly
extends Polygon2D


func _ready():
	if not get_node_or_null("StaticBody2D"):
		var body = StaticBody2D.new()
		body.name = "StaticBody2D"
		var shape = CollisionPolygon2D.new()
		shape.name = "CollisionPolygon2D"
		body.add_child(shape)
		add_child(body)
		if polygon.size() == 0:
			polygon = [Vector2.UP * 32, Vector2.RIGHT * 32, Vector2.DOWN * 32, Vector2.LEFT * 32]
	$StaticBody2D/CollisionPolygon2D.polygon = polygon


func _notification(_what):
	if not Engine.editor_hint || not get_child_count():
		return
	$StaticBody2D/CollisionPolygon2D.polygon = polygon
