extends Node

# surface rooms
const ROOM_INNER := "ROOM_INNER"
const ROOM_OUTER := "ROOM_OUTER"
const ROOM_FRONT := "ROOM_FRONT"
const ROOM_BACK := "ROOM_BACK"
const ROOM_LEFT := "ROOM_LEFT"
const ROOM_RIGHT := "ROOM_RIGHT"
const ROOM_TOP := "ROOM_TOP"
const ROOM_BOTTOM := "ROOM_BOTTOM"

# room connections
const SIDE_TOP := "SIDE_TOP"
const SIDE_BOTTOM := "SIDE_BOTTOM"
const SIDE_LEFT := "SIDE_LEFT"
const SIDE_RIGHT := "SIDE_RIGHT"
const SIDE_FRONT := "SIDE_FRONT"
const SIDE_BACK := "SIDE_BACK"

# think of dali's cross for a map!
# also think of the 3d projection of a tesseract!

const DEG_90 := 0.5 * PI
const T_NONE = Transform()
var turn_left := Transform().rotated(Vector3.UP, DEG_90)
var turn_right := Transform().rotated(Vector3.UP, -DEG_90)
var pitch_up := Transform().rotated(Vector3.LEFT, DEG_90)
var pitch_down := Transform().rotated(Vector3.LEFT, -DEG_90)
var roll_left := Transform().rotated(Vector3.FORWARD, DEG_90)
var roll_right := Transform().rotated(Vector3.FORWARD, -DEG_90)

var data := {
	ROOM_INNER:
	{
		SIDE_TOP: {"room": ROOM_TOP, "side": SIDE_BOTTOM, "transform": T_NONE},
		SIDE_BOTTOM: {"room": ROOM_BOTTOM, "side": SIDE_TOP, "transform": T_NONE},
		SIDE_LEFT: {"room": ROOM_LEFT, "side": SIDE_RIGHT, "transform": T_NONE},
		SIDE_RIGHT: {"room": ROOM_RIGHT, "side": SIDE_LEFT, "transform": T_NONE},
		SIDE_FRONT: {"room": ROOM_FRONT, "side": SIDE_BACK, "transform": T_NONE},
		SIDE_BACK: {"room": ROOM_BACK, "side": SIDE_FRONT, "transform": T_NONE},
	},
	ROOM_OUTER:
	{
		SIDE_TOP: {"room": ROOM_BOTTOM, "side": SIDE_BOTTOM, "transform": T_NONE},
		SIDE_BOTTOM: {"room": ROOM_TOP, "side": SIDE_TOP, "transform": T_NONE},
		SIDE_LEFT: {"room": ROOM_RIGHT, "side": SIDE_LEFT, "transform": T_NONE},
		SIDE_RIGHT: {"room": ROOM_LEFT, "side": SIDE_RIGHT, "transform": T_NONE},
		SIDE_FRONT: {"room": ROOM_BACK, "side": SIDE_FRONT, "transform": T_NONE},
		SIDE_BACK: {"room": ROOM_FRONT, "side": SIDE_BACK, "transform": T_NONE},
	},
	ROOM_FRONT:
	{
		SIDE_TOP: {"room": ROOM_TOP, "side": SIDE_FRONT, "transform": pitch_up},
		SIDE_BOTTOM: {"room": ROOM_BOTTOM, "side": SIDE_FRONT, "transform": pitch_down},
		SIDE_LEFT: {"room": ROOM_LEFT, "side": SIDE_FRONT, "transform": turn_right},
		SIDE_RIGHT: {"room": ROOM_RIGHT, "side": SIDE_FRONT, "transform": turn_left},
		SIDE_FRONT: {"room": ROOM_OUTER, "side": SIDE_BACK, "transform": T_NONE},
		SIDE_BACK: {"room": ROOM_INNER, "side": SIDE_FRONT, "transform": T_NONE},
	},
	ROOM_BACK:
	{
		SIDE_TOP: {"room": ROOM_TOP, "side": SIDE_BACK, "transform": pitch_down},
		SIDE_BOTTOM: {"room": ROOM_BOTTOM, "side": SIDE_BACK, "transform": pitch_up},
		SIDE_LEFT: {"room": ROOM_LEFT, "side": SIDE_BACK, "transform": turn_left},
		SIDE_RIGHT: {"room": ROOM_RIGHT, "side": SIDE_BACK, "transform": turn_right},
		SIDE_FRONT: {"room": ROOM_INNER, "side": SIDE_BACK, "transform": T_NONE},
		SIDE_BACK: {"room": ROOM_OUTER, "side": SIDE_FRONT, "transform": T_NONE},
	},
	ROOM_LEFT:
	{
		SIDE_TOP: {"room": ROOM_TOP, "side": SIDE_LEFT, "transform": roll_left},
		SIDE_BOTTOM: {"room": ROOM_BOTTOM, "side": SIDE_LEFT, "transform": roll_right},
		SIDE_LEFT: {"room": ROOM_OUTER, "side": SIDE_RIGHT, "transform": T_NONE},
		SIDE_RIGHT: {"room": ROOM_INNER, "side": SIDE_LEFT, "transform": T_NONE},
		SIDE_FRONT: {"room": ROOM_FRONT, "side": SIDE_LEFT, "transform": turn_left},
		SIDE_BACK: {"room": ROOM_BACK, "side": SIDE_LEFT, "transform": turn_right},
	},
	ROOM_RIGHT:
	{
		SIDE_TOP: {"room": ROOM_TOP, "side": SIDE_RIGHT, "transform": roll_right},
		SIDE_BOTTOM: {"room": ROOM_BOTTOM, "side": SIDE_RIGHT, "transform": roll_left},
		SIDE_LEFT: {"room": ROOM_INNER, "side": SIDE_RIGHT, "transform": T_NONE},
		SIDE_RIGHT: {"room": ROOM_OUTER, "side": SIDE_LEFT, "transform": T_NONE},
		SIDE_FRONT: {"room": ROOM_FRONT, "side": SIDE_RIGHT, "transform": turn_right},
		SIDE_BACK: {"room": ROOM_BACK, "side": SIDE_RIGHT, "transform": turn_left},
	},
	ROOM_TOP:
	{
		SIDE_TOP: {"room": ROOM_OUTER, "side": SIDE_BOTTOM, "transform": T_NONE},
		SIDE_BOTTOM: {"room": ROOM_INNER, "side": SIDE_TOP, "transform": T_NONE},
		SIDE_LEFT: {"room": ROOM_LEFT, "side": SIDE_TOP, "transform": roll_right},
		SIDE_RIGHT: {"room": ROOM_RIGHT, "side": SIDE_TOP, "transform": roll_left},
		SIDE_FRONT: {"room": ROOM_FRONT, "side": SIDE_TOP, "transform": pitch_down},
		SIDE_BACK: {"room": ROOM_BACK, "side": SIDE_TOP, "transform": pitch_up},
	},
	ROOM_BOTTOM:
	{
		SIDE_TOP: {"room": ROOM_INNER, "side": SIDE_BOTTOM, "transform": T_NONE},
		SIDE_BOTTOM: {"room": ROOM_OUTER, "side": SIDE_TOP, "transform": T_NONE},
		SIDE_LEFT: {"room": ROOM_LEFT, "side": SIDE_BOTTOM, "transform": roll_left},
		SIDE_RIGHT: {"room": ROOM_RIGHT, "side": SIDE_BOTTOM, "transform": roll_right},
		SIDE_FRONT: {"room": ROOM_FRONT, "side": SIDE_BOTTOM, "transform": pitch_up},
		SIDE_BACK: {"room": ROOM_BACK, "side": SIDE_BOTTOM, "transform": pitch_down},
	},
}


func is_valid() -> bool:
	# assert that each side is
	# defined correctly (inverse) in both places
	for room_key in data.keys():
		var room = data[room_key]
		for conn_key in room.keys():
			var conn = room[conn_key]
			assert(conn.room is String)
			assert(conn.side is String)
			assert(conn.transform is Transform)

			assert(data.has(conn.room), "Invalid room")
			var other = data[conn.room]

			assert(other.has(conn.side), "Invalid side")
			var t: Transform = other[conn.side].transform

			assert(
				t.inverse() == conn.transform,
				"Unmirrored transform! %s/%s -> %s/%s" % [room_key, conn_key, conn.room, conn.side]
			)
	return true


# leave <room> via <side>, get next room
func transition(room: String, side: String) -> Dictionary:
	var conn = data[room][side]
	return data[conn.room]

# end
