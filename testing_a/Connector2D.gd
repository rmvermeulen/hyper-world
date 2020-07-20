tool
class_name Connector2D
extends Node

enum Connection { N, S, E, W }

export (NodePath) var path_a setget set_path_a
export (Connection) var connection_a := Connection.N

export (NodePath) var path_b setget set_path_b
export (Connection) var connection_b := Connection.N

export (Transform2D) var a_to_b

var a: Node = null
var b: Node = null

var _is_ready := false


func _ready():
	_is_ready = true
	set_path_a(path_a)
	set_path_b(path_b)


func set_path_a(value):
	path_a = value
	if _is_ready:
		a = get_node_or_null(value)


func set_path_b(value):
	path_b = value
	if _is_ready:
		b = get_node_or_null(value)


static func connection_name(c: int) -> String:
	match c:
		Connection.N:
			return "North"
		Connection.S:
			return "South"
		Connection.E:
			return "East"
		Connection.W:
			return "West"
	return ""
# end
