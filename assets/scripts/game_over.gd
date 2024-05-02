extends Control

@onready var world

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_node("/root/World")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	world.loadMainMenu()


func _on_load_pressed():
	world.loadScene("Level1")
	
func gameOver():
	visible = true
	world.pause_game()
	$Panel/AnimationPlayer.play("fade_in")
