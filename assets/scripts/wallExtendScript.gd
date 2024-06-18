extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Wall2.get_surface_override_material(0).uv1_scale.x = scale.z
	#$Wall2.get_surface_override_material(0).uv2_scale.x = scale.z
	var wallIndex = 1
	while scale.z >= 2:
		
		var wall = $Wall2.duplicate()
		wall.position.z = -4 * wallIndex
		scale.z -= 1
		wallIndex += 1
		add_child(wall)
	if scale.z < 1:
		$Wall2.scale.y = scale.z/100
		$Wall2.get_surface_override_material(0).uv1_scale.x = scale.z
	elif scale.z > 1:
		
		var wall = $Wall2.duplicate()
		wall.position.z = -4 * wallIndex
		wall.scale.y = (scale.z - 1)/100
		wall.set_surface_override_material(0, wall.get_surface_override_material(0).duplicate())
		wall.get_surface_override_material(0).uv1_scale.x = scale.z-1
		add_child(wall)
	scale.z = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
