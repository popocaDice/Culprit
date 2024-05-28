extends Node3D

var paused = false

signal pause
signal unpause
signal lockControls
signal unlockControls


func _ready():
	pass
	
func pause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true #In case you want to pause the game
	pause.emit()

func unpause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	unpause.emit()

func lock_controls(showCursor):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if showCursor else Input.MOUSE_MODE_CAPTURED)
	lockControls.emit()

func unlock_controls():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	unlockControls.emit()

func loadMainMenu():
	get_tree().change_scene_to_file("res://assets/scenes/mainMenu.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false
	unpause.emit()
	
func loadScene(path: String):
	get_tree().change_scene_to_file("res://assets/scenes/" + path + ".tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	unpause.emit()

func _process(_delta):
	if Input.is_action_just_released("game_pause"):
		paused = !paused
		if paused:
			pause_game()
		else:
			unpause_game()
