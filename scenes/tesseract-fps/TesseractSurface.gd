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

export var _scene_inner := preload("./rooms/RoomInner.tscn") setget _set_scene_inner
export var _scene_outer := preload("./rooms/RoomOuter.tscn") setget _set_scene_outer
export var _scene_top := preload("./rooms/RoomTop.tscn") setget _set_scene_top
export var _scene_bottom := preload("./rooms/RoomBottom.tscn") setget _set_scene_bottom
export var _scene_left := preload("./rooms/RoomLeft.tscn") setget _set_scene_left
export var _scene_right := preload("./rooms/RoomRight.tscn") setget _set_scene_right
export var _scene_front := preload("./rooms/RoomFront.tscn") setget _set_scene_front
export var _scene_back := preload("./rooms/RoomBack.tscn") setget _set_scene_back

var data = TData.new()
var _rooms_dirty := true

# helper methods


func _ready():
	if _instantiate_rooms():
		_rooms_dirty = false


func _physics_process(_delta):
	if not _rooms_dirty:
		return
	if _instantiate_rooms():
		_rooms_dirty = false


func _set_scene_inner(value):
	_scene_inner = value
	_rooms_dirty = true


func _set_scene_outer(value):
	_scene_outer = value
	_rooms_dirty = true


func _set_scene_top(value):
	_scene_top = value
	_rooms_dirty = true


func _set_scene_bottom(value):
	_scene_bottom = value
	_rooms_dirty = true


func _set_scene_left(value):
	_scene_left = value
	_rooms_dirty = true


func _set_scene_right(value):
	_scene_right = value
	_rooms_dirty = true


func _set_scene_front(value):
	_scene_front = value
	_rooms_dirty = true


func _set_scene_back(value):
	_scene_back = value
	_rooms_dirty = true


func _instantiate_rooms() -> bool:
	# for now just a dumb replace-all

	# remove existing rooms
	for room in get_children():
		remove_child(room)
		room.queue_free()

	# create new scenes
	for scene in [
		[_scene_inner, SLOT_INNER],
		[_scene_outer, SLOT_OUTER],
		[_scene_top, SLOT_TOP],
		[_scene_bottom, SLOT_BOTTOM],
		[_scene_left, SLOT_LEFT],
		[_scene_right, SLOT_RIGHT],
		[_scene_front, SLOT_FRONT],
		[_scene_back, SLOT_BACK]
	]:
		var room = scene[0].instance()
		room.set_indexed(":transform:origin", scene[1])
		add_child(room)
	return true


func _room_at(pos: Vector3) -> Spatial:
	var room = null
	for child in get_children():
		if child.transform.origin.distance_squared_to(pos) < 0.5:
			room = child
			break
	assert(room)
	return room


# tesseract rotation methods


func rotate_tesseract_up() -> void:
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


func rotate_tesseract_down() -> void:
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


func rotate_tesseract_left() -> void:
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


func rotate_tesseract_right() -> void:
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


func rotate_tesseract_forward() -> void:
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


func rotate_tesseract_backward() -> void:
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
