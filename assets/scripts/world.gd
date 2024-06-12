extends Node3D

var paused = false

var loadScreen : PanelContainer
var loadScreenTimer : Timer

@export var environment : Resource = preload("res://assets/prefabs/world_environment.tscn")

signal pause
signal unpause
signal lockControls
signal unlockControls
signal inventory
signal unventory

var sceneToLoad = ""

func _ready():
	add_child(environment.instantiate())
	loadScreen = $WorldEnvironment/CanvasLayer/PanelContainer
	loadScreenTimer = $WorldEnvironment/CanvasLayer/PanelContainer/Timer
	
	loadScreenTimer.timeout.connect(_on_timeout)
	loadScreen.get_theme_stylebox("panel", "fadeInLoader").texture.current_frame = 0

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
	loadScreenTimer.start(2)
	loadScreen.theme_type_variation = "fadeOutLoader"
	loadScreen.get_theme_stylebox("panel", "fadeOutLoader").texture.current_frame = 0
	loadScreen.get_theme_stylebox("panel", "fadeOutLoader").texture.pause = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false
	unpause.emit()
	sceneToLoad = "res://assets/scenes/mainMenu.tscn"
	
func loadScene(path: String):
	loadScreenTimer.start(2)
	loadScreen.theme_type_variation = "fadeOutLoader"
	loadScreen.get_theme_stylebox("panel", "fadeOutLoader").texture.current_frame = 0
	loadScreen.get_theme_stylebox("panel", "fadeOutLoader").texture.pause = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	unpause.emit()
	sceneToLoad = "res://assets/scenes/" + path + ".tscn"

func lockPlayerControls(lock):
	lockControls.emit()
	
func _on_timeout():
	if not sceneToLoad == "":
		get_tree().change_scene_to_file(sceneToLoad)
