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

	# check tracker size and alignment
	var inner = $Tracker/Inner
	assert(inner.transform.origin == SLOT_INNER)
	var front = $Tracker/Front
	assert(front.transform.origin == SLOT_FRONT)
	var back = $Tracker/Back
	assert(back.transform.origin == SLOT_BACK)
	var left = $Tracker/Left
	assert(left.transform.origin == SLOT_LEFT)
	var right = $Tracker/Right
	assert(right.transform.origin == SLOT_RIGHT)
	var top = $Tracker/Top
	assert(top.transform.origin == SLOT_TOP)
	var bottom = $Tracker/Bottom
	assert(bottom.transform.origin == SLOT_BOTTOM)

	var room_quadrant := 0.5 * ROOM_SIZE * Vector3(1, 1, 1)
	for node in $Tracker.get_children():
		# node.shape.extents = room_quadrant
		assert(node.shape.extents == room_quadrant)


func _on_player_changed_room(new_room_tag: String):
	if new_room_tag == "inner":
		return

	# re-organize room
	prints("re-organize scene", new_room_tag)

	match new_room_tag:
		"front":
			$TesseractSurface.rotate_tesseract_backward()
		"back":
			$TesseractSurface.rotate_tesseract_forward()
		"top":
			$TesseractSurface.rotate_tesseract_down()
		"bottom":
			$TesseractSurface.rotate_tesseract_up()
		"left":
			$TesseractSurface.rotate_tesseract_right()
		"right":
			$TesseractSurface.rotate_tesseract_left()

	# hide outer room, show others
	for room in $TesseractSurface.get_children():
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

# end
