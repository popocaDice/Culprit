extends Area3D

var player : Node3D

func _ready():
	player = get_node("/root/World/Player/InteractionBox")
	
func _process(_delta):
	var overlap = get_overlapping_areas()
	if !overlap.find(player):
		if Input.is_action_just_pressed("interact"):
			$Door2/door_animation.play("door_open" if !get_parent().get_meta("open") else "door_close", 0.5)

