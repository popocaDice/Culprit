extends Control

@onready var world

# Called when the node enters the scene tree for the first time.
func _ready():

	world = get_node("/root/World")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("game_pause"):
		hide()
		world.unpause_game()


func on_cancel_pressed():
	$Settings.hide()
	$Pause.show()


func on_save_pressed():
	$Settings.hide()
	$Pause.show()

func _on_resume_pressed():
	print_debug("resume")
	world.unpause_game()
	hide()


func _on_settings_pressed():
	$Pause.hide()
	$Settings.show()


func _on_quit_pressed():
	world.loadMainMenu()
