extends Node3D

var paused = false
var busy = false

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
	get_tree().root.use_occlusion_culling = true
	
	add_child(environment.instantiate())
	loadScreen = $WorldEnvironment/CanvasLayer/PanelContainer
	loadScreenTimer = $WorldEnvironment/CanvasLayer/PanelContainer/Timer
	
	loadScreenTimer.timeout.connect(_on_timeout)
	loadScreen.get_theme_stylebox("panel", "fadeInLoader").texture.current_frame = 0

func _process(_delta):
	if Input.is_action_just_pressed("game_pause"):
		pause_unpause()
	if Input.is_action_just_pressed("inventory") and not paused:
		pause_game()
		inventory.emit()

func pause_unpause():
	if paused or busy:
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
	busy = showCursor
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if showCursor else Input.MOUSE_MODE_CAPTURED)
	lockControls.emit(showCursor)

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
	if not loadScreenTimer.is_stopped(): return
	loadScreenTimer.start(2)
	loadScreen.theme_type_variation = "fadeOutLoader"
	loadScreen.get_theme_stylebox("panel", "fadeOutLoader").texture.current_frame = 0
	loadScreen.get_theme_stylebox("panel", "fadeOutLoader").texture.pause = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	unpause.emit()
	sceneToLoad = "res://assets/scenes/" + path + ".tscn"

func lockPlayerControls(_lock):
	lockControls.emit()
	
func _on_timeout():
	if not sceneToLoad == "":
		get_tree().change_scene_to_file(sceneToLoad)
