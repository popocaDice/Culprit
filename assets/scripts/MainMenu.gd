extends Control

@onready var world = get_tree().current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	world.loadScene("IntroScene")


func _on_settings_pressed():
	$Main.hide()
	$Settings.show()
	$ClickAudio.play()


func on_cancel_pressed():
	$Settings.hide()
	$Main.show()
