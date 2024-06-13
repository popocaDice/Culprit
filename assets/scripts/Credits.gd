extends Control

@onready var world

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_tree().current_scene
	
func _process(delta):
	if Input.is_action_just_pressed("game_pause"):
		world.loadMainMenu()
	
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			$Container/AnimationPlayer.speed_scale = 10
		else:
			$Container/AnimationPlayer.speed_scale = 0.8

