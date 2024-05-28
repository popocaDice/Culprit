extends Control

@onready var world = get_node("/root/World")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func on_cancel_pressed():
	$Settings.hide()
	$Pause.show()


func on_save_pressed():
	$Settings.hide()
	$Pause.show()

func _on_resume_pressed():
	world.unpause_game()
	hide()


func _on_settings_pressed():
	$Pause.hide()
	$Settings.show()
	$ClickAudio.play()


func _on_quit_pressed():
	world.loadMainMenu()
