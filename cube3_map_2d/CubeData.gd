extends Reference

static func create():
	return {
		"front":
		{
			"north": {"id": "top", "connection": "south", "angle": 0},
			"south": {"id": "bottom", "connection": "north", "angle": 0},
			"east": {"id": "right", "connection": "west", "angle": 0},
			"west": {"id": "left", "connection": "east", "angle": 0},
		},
		"back":
		{
			"north": {"id": "top", "connection": "north", "angle": TAU},
			"south": {"id": "bottom", "connection": "south", "angle": TAU},
			"east": {"id": "left", "connection": "west", "angle": 0},
			"west": {"id": "right", "connection": "east", "angle": 0},
		},
		"left":
		{
			"north": {"id": "top", "connection": "west", "angle": TAU + PI},
			"south": {"id": "bottom", "connection": "east", "angle": TAU + PI},
			"east": {"id": "front", "connection": "west", "angle": 0},
			"west": {"id": "back", "connection": "east", "angle": 0},
		},
		"right":
		{
			"north": {"id": "top", "connection": "east", "angle": PI},
			"south": {"id": "bottom", "connection": "west", "angle": PI},
			"east": {"id": "back", "connection": "west", "angle": 0},
			"west": {"id": "front", "connection": "east", "angle": 0},
		},
		"top":
		{
			"north": {"id": "back", "connection": "north", "angle": TAU},
			"south": {"id": "front", "connection": "north", "angle": 0},
			"east": {"id": "right", "connection": "north", "angle": TAU + PI},
			"west": {"id": "left", "connection": "north", "angle": PI},
		},
		"bottom":
		{
			"north": {"id": "front", "connection": "south", "angle": 0},
			"south": {"id": "back", "connection": "south", "angle": TAU},
			"east": {"id": "right", "connection": "south", "angle": PI},
			"west": {"id": "left", "connection": "south", "angle": TAU + PI},
		},
	}
