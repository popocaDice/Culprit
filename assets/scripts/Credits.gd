extends Control

@onready var world

var label_height

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_node("/root/World")
	label_height = $Container/Label.get_line_count() * $Container/Label.get_line_height()
	
func _process(delta):
	if $Container/Label.global_position.y + label_height <= -2 * get_viewport_rect().size.y/3:
		world.loadMainMenu()
	
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			$Container/AnimationPlayer.speed_scale = 10
		else:
			$Container/AnimationPlayer.speed_scale = 0.8

