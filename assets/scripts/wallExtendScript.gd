extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Wall2.get_surface_override_material(0).uv1_scale.x = scale.z


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
