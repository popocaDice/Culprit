extends Control

@onready var world = get_node("/root/World")

var timer_stopped = true

# Called when the node enters the scene tree for the first time.
func _ready():
	world.pause.connect(show)
	world.unpause.connect(hide)

func on_cancel_pressed():
	$Settings.hide()
	$Pause.show()


func on_save_pressed():
	$Settings.hide()
	$Pause.show()

func _on_resume_pressed():
	timer(0.1)
	world.unpause_game()
	hide()

func _on_settings_pressed():
	$Pause.hide()
	$Settings.show()
	$ClickAudio.play()


func _on_quit_pressed():
	world.loadMainMenu()


func _on_timer_timeout():
	timer_stopped = true
	
func timer(time):
	timer_stopped = false
	$Timer.start(time)
