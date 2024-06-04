extends Control

@onready var world = get_node("/root/World")

var timer_stopped = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not timer_stopped:
		return
	if Input.is_action_just_pressed("game_pause"):
		timer(0.1)
		_on_resume_pressed()
		


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

func _on_pause_resume_pressed():
	if world.paused:
		hide()
		print_debug("Menu Hide")
		world.unpause_game()
		print_debug("Despausou")
	else:
		world.pause_game()
		print_debug("Pausou")
		show()
		print_debug("Menu Show")

func _on_settings_pressed():
	$Pause.hide()
	$Settings.show()
	$ClickAudio.play()


func _on_quit_pressed():
	world.loadMainMenu()


func _on_timer_timeout():
	timer_stopped = true
	
func timer(time):
	$Timer.start(time)
	timer_stopped = false
