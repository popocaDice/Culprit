extends Node3D

@onready var world = get_node("/root/World")
@onready var player = get_node("/root/World/Player")

@export var nextScene: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body == player: 
		if nextScene == "mainMenu": world.loadMainMenu()
		else: world.loadScene(nextScene)
