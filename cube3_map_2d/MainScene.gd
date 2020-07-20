extends Node2D

# const FLOOR_TEXTURE := preload("res://assets/proto-textures/Dark/texture_05.png")
const ROOM_SIZE := 512

var cube_data = preload("./CubeData.gd").create()
var current_room_id := "front"


func _ready():
	assert(cube_data)
	_change_room_to(current_room_id, "north")
	for wall in $RoomArea/Walls.get_children():
		assert(
			(
				OK
				== (wall as Area2D).connect(
					"body_entered", self, "_on_wall_body", [wall.name.to_lower()]
				)
			)
		)


func _change_room_to(next_room_id: String, dir: String) -> void:
	var info = cube_data[next_room_id]
	# rotate the player and camera
	$Player.rotate(cube_data[current_room_id][dir].angle)

	# change preview textures)

	# and we're done
	current_room_id = next_room_id


func _on_Player_body_entered(body):
	var room = cube_data[current_room_id]
	prints(current_room_id, '->', room[body.name.to_lower()])


func _on_wall_body(body: KinematicBody2D, tag: String):
	if not body:
		return
	var offset = Vector2()
	match tag:
		"north":
			offset.y = ROOM_SIZE
		"east":
			offset.x = -ROOM_SIZE
		"south":
			offset.y = -ROOM_SIZE
		"west":
			offset.x = ROOM_SIZE
	body.position += offset
	var next_room = cube_data[current_room_id][tag].id
	_change_room_to(next_room, tag)

# end
