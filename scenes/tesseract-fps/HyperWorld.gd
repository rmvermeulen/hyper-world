extends Spatial

const TData := preload("res://resources/tesseract/Data.gd")

const ROOM_SIZE := 20

const SLOT_INNER := Vector3() * ROOM_SIZE
const SLOT_OUTER := Vector3(10, 0, 0) * ROOM_SIZE
const SLOT_TOP := Vector3.UP * ROOM_SIZE
const SLOT_BOTTOM := Vector3.DOWN * ROOM_SIZE
const SLOT_LEFT := Vector3.LEFT * ROOM_SIZE
const SLOT_RIGHT := Vector3.RIGHT * ROOM_SIZE
# note: front/back in the map data are reversed of the Vector3 constants
const SLOT_FRONT := Vector3.BACK * ROOM_SIZE
const SLOT_BACK := Vector3.FORWARD * ROOM_SIZE

var data = TData.new()
var _player_current_room_transform := Transform()


func _ready():
	assert(OK == $Tracker.connect("changed_room", self, "_on_player_changed_room"))

	# check room size and alignment
	var room_inner := $Rooms/RoomInner
	assert(room_inner)
	room_inner.transform.origin = SLOT_INNER
	assert(room_inner.transform.origin == SLOT_INNER)

	var room_outer := $Rooms/RoomOuter
	assert(room_outer)
	room_outer.transform.origin = SLOT_OUTER
	assert(room_outer.transform.origin == SLOT_OUTER)

	var room_top := $Rooms/RoomTop
	assert(room_top)
	room_top.transform.origin = SLOT_TOP
	assert(room_top.transform.origin == SLOT_TOP)

	var room_bottom := $Rooms/RoomBottom
	assert(room_bottom)
	room_bottom.transform.origin = SLOT_BOTTOM
	assert(room_bottom.transform.origin == SLOT_BOTTOM)

	var room_left := $Rooms/RoomLeft
	assert(room_left)
	room_left.transform.origin = SLOT_LEFT
	assert(room_left.transform.origin == SLOT_LEFT)

	var room_right := $Rooms/RoomRight
	assert(room_right)
	room_right.transform.origin = SLOT_RIGHT
	assert(room_right.transform.origin == SLOT_RIGHT)

	var room_front := $Rooms/RoomFront
	assert(room_front)
	room_front.transform.origin = SLOT_FRONT
	assert(room_front.transform.origin == SLOT_FRONT)

	var room_back := $Rooms/RoomBack
	assert(room_back)
	room_back.transform.origin = SLOT_BACK
	assert(room_back.transform.origin == SLOT_BACK)

	# check tracker size and alignment
	var inner = $Tracker/Inner
	assert(inner.transform.origin == SLOT_INNER)
	var front = $Tracker/Front
	assert(front.transform.origin == SLOT_FRONT)
	var back = $Tracker/Back
	assert(back.transform.origin == SLOT_BACK)
	var s1 = inner.get_child(0).shape
	var s2 = front.get_child(0).shape
	var s3 = back.get_child(0).shape

	assert(s1 != null)
	assert(s2 == s1)
	assert(s3 == s2)

	var room_quadrant := 0.5 * ROOM_SIZE * Vector3(1, 1, 1)
	s1.extents = room_quadrant
	assert(s1.extents == room_quadrant)


func _on_player_changed_room(new_room_tag: String):
	if new_room_tag == "inner":
		return

	# re-organize room
	prints("re-organize scene", new_room_tag)

	match new_room_tag:
		"front":
			_rotate_tesseract_backward()
		"back":
			_rotate_tesseract_forward()
		"top":
			_rotate_tesseract_down()
		"bottom":
			_rotate_tesseract_up()
		"left":
			_rotate_tesseract_right()
		"right":
			_rotate_tesseract_left()

	# hide outer room, show others
	for room in $Rooms.get_children():
		var d: int = room.transform.origin.distance_squared_to(SLOT_OUTER)
		room.set("visible", d != 0)

	# move player to wrapped position
	var extent = .5 * ROOM_SIZE
	var pos: Vector3 = $Player.transform.origin
	pos.x = wrapf(pos.x, -extent, extent)
	pos.y = wrapf(pos.y, -extent, extent)
	pos.z = wrapf(pos.z, -extent, extent)
	$Player.transform.origin = pos

	# done
	prints("done")


# helper methods
func _room_at(pos: Vector3) -> Spatial:
	var room = null
	for child in $Rooms.get_children():
		if child.transform.origin.distance_squared_to(pos) < 0.5:
			room = child
			break
	assert(room)
	return room


# tesseract rotation methods


func _rotate_tesseract_up() -> void:
	var inner := _room_at(SLOT_INNER)
	# bottom -> inner
	_room_at(SLOT_BOTTOM).transform.origin = SLOT_INNER
	# outer -> bottom
	_room_at(SLOT_OUTER).transform.origin = SLOT_BOTTOM
	# top -> outer
	_room_at(SLOT_TOP).transform.origin = SLOT_OUTER
	# inner -> top
	inner.transform.origin = SLOT_TOP

	# front -> pitch down
	_room_at(SLOT_FRONT).transform *= data.pitch_down
	# back -> pitch up
	_room_at(SLOT_BACK).transform *= data.pitch_up
	# left -> roll left
	_room_at(SLOT_LEFT).transform *= data.roll_left
	# right -> roll right
	_room_at(SLOT_RIGHT).transform *= data.roll_right


func _rotate_tesseract_down() -> void:
	var inner := _room_at(SLOT_INNER)
	# top -> inner
	_room_at(SLOT_TOP).transform.origin = SLOT_INNER
	# outer -> top
	_room_at(SLOT_OUTER).transform.origin = SLOT_TOP
	# bottom -> outer
	_room_at(SLOT_BOTTOM).transform.origin = SLOT_OUTER
	# inner -> bottom
	inner.transform.origin = SLOT_BOTTOM

	# front -> pitch up
	_room_at(SLOT_FRONT).transform *= data.pitch_up
	# back -> pitch down
	_room_at(SLOT_BACK).transform *= data.pitch_down
	# left -> roll right
	_room_at(SLOT_LEFT).transform *= data.roll_right
	# right -> roll left
	_room_at(SLOT_RIGHT).transform *= data.roll_left


func _rotate_tesseract_left() -> void:
	var inner := _room_at(SLOT_INNER)
	# right -> inner
	_room_at(SLOT_RIGHT).transform.origin = SLOT_INNER
	# outer -> right
	_room_at(SLOT_OUTER).transform.origin = SLOT_RIGHT
	# left -> outer
	_room_at(SLOT_LEFT).transform.origin = SLOT_OUTER
	# inner -> left
	inner.transform.origin = SLOT_LEFT

	# front -> turn left
	_room_at(SLOT_FRONT).transform *= data.turn_left
	# back -> turn right
	_room_at(SLOT_BACK).transform *= data.turn_right
	# top -> roll right
	_room_at(SLOT_TOP).transform *= data.roll_right
	# bottom -> roll left
	_room_at(SLOT_BOTTOM).transform *= data.roll_left


func _rotate_tesseract_right() -> void:
	var inner := _room_at(SLOT_INNER)
	# left -> inner
	_room_at(SLOT_LEFT).transform.origin = SLOT_INNER
	# outer -> left
	_room_at(SLOT_OUTER).transform.origin = SLOT_LEFT
	# right -> outer
	_room_at(SLOT_RIGHT).transform.origin = SLOT_OUTER
	# inner -> right
	inner.transform.origin = SLOT_RIGHT

	# front -> turn right
	_room_at(SLOT_FRONT).transform *= data.turn_right
	# back -> turn left
	_room_at(SLOT_BACK).transform *= data.turn_left
	# top -> roll left
	_room_at(SLOT_TOP).transform *= data.roll_left
	# bottom -> roll right
	_room_at(SLOT_BOTTOM).transform *= data.roll_right


func _rotate_tesseract_forward() -> void:
	var inner := _room_at(SLOT_INNER)
	# back -> inner
	_room_at(SLOT_BACK).transform.origin = SLOT_INNER
	# outer -> back
	_room_at(SLOT_OUTER).transform.origin = SLOT_BACK
	# front -> outer
	_room_at(SLOT_FRONT).transform.origin = SLOT_OUTER
	# inner -> front
	inner.transform.origin = SLOT_FRONT

	# left -> turn right
	_room_at(SLOT_LEFT).transform *= data.turn_right
	# right -> turn left
	_room_at(SLOT_RIGHT).transform *= data.turn_left
	# top -> pitch up
	_room_at(SLOT_TOP).transform *= data.pitch_up
	# bottom -> pitch down
	_room_at(SLOT_BOTTOM).transform *= data.pitch_down


func _rotate_tesseract_backward() -> void:
	var inner := _room_at(SLOT_INNER)
	# front -> inner
	_room_at(SLOT_FRONT).transform.origin = SLOT_INNER
	# outer -> front
	_room_at(SLOT_OUTER).transform.origin = SLOT_FRONT
	# back -> outer
	_room_at(SLOT_BACK).transform.origin = SLOT_OUTER
	# inner -> back
	inner.transform.origin = SLOT_BACK

	# left -> turn left
	_room_at(SLOT_LEFT).transform *= data.turn_left
	# right -> turn right
	_room_at(SLOT_RIGHT).transform *= data.turn_right
	# top -> pitch down
	_room_at(SLOT_TOP).transform *= data.pitch_down
	# bottom -> pitch up
	_room_at(SLOT_BOTTOM).transform *= data.pitch_up

# end
