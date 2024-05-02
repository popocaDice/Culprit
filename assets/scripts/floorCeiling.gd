extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Plane.get_surface_override_material(0).uv1_scale.x = scale.x*2
	$Plane.get_surface_override_material(0).uv1_scale.y = scale.z*2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
