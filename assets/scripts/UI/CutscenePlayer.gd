extends VideoStreamPlayer

@export var scene : String

@onready var world = get_tree().current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(_end)

func _end():
	paused = true
	world.loadScene(scene)
