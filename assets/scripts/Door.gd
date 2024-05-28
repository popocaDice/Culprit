extends Area3D

var playerInRange = false

func _ready():
	pass

func _process(_delta):
	if playerInRange:
		if Input.is_action_just_pressed("interact"):
			$Door2/door_animation.play("door_open" if !get_parent().get_meta("open") else "door_close", 0.5)



func _on_area_entered(area):
	if area.get_parent_node_3d().is_in_group("player"):
		playerInRange = true


func _on_area_exited(area):
	if area.get_parent_node_3d().is_in_group("player"):
		playerInRange = false
