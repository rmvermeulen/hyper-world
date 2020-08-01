tool
extends MeshInstance

export (float) var seconds_per_rotation := 120.0


func _ready():
	rotation.z = 0


func _process(delta):
	rotation.z += delta * (TAU / seconds_per_rotation)
