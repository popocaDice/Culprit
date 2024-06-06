extends Node3D

var paused = false
@onready var player = get_tree().get_first_node_in_group("player")

signal pause
signal unpause
signal lockControls
signal unlockControls
signal inventory
signal unventory

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("game_pause"):
		pause_unpause()
	if Input.is_action_just_pressed("inventory") and not paused:
		pause_game()
		inventory.emit()

func pause_unpause():
	if paused:
		unpause_game()
	else:
		pause_game()

func pause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true #In case you want to pause the game
	paused = true
	pause.emit()

func unpause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	unventory.emit()
	get_tree().paused = false
	paused = false
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

func lockPlayerControls(lock):
	player.LockControls(lock)
