extends CharacterBody3D

@export var base_speed = 5
@export var sprint_speed = 8
@export var sneak_speed = 1
@export var jump_velocity = 4
@export var sensitivity = 0.1
@export var accel = 10
@export var max_stamina = 6.0
@export var tired_duration = 1.5
@export var initial_angle: float = 0

var stamina = max_stamina
var regen_stamina: bool = true
var speed = base_speed
var sprinting = false
var camera_fov_extents = [75.0, 85.0] #index 0 is normal, index 1 is sprinting
var left_hand: bool = false
var right_hand: bool = false

var locked_controls = false

@onready var parts = {
	"head": $Head,
	"hands": $Hands,
	"camera": $Head/Camera,
	"camera_animation": $Head/Camera/camera_animation,
	"stamina_bar": $HUD/StaminaBar,
	"breathing_audio_player": $Breathing,
	"sfx_audio_player": $SFX,
	"ambience_audio_player": $Ambience,
	"pause": $HUD/PauseMenu,
	"inventory": $HUD/Inventory
}
@onready var world = get_tree().current_scene
@export var inventory: Inventory

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var ambienceWait: bool = false

func _ready():
	world.pause.connect(_on_pause)
	world.unpause.connect(_on_unpause)
	world.unpause.connect(UpdateHands)
	world.lockControls.connect(LockControls)
	
	parts.camera.current = true
	parts.stamina_bar.max_value = max_stamina
	
	parts.head.rotation_degrees.y = initial_angle
	parts.hands.rotation_degrees.y = initial_angle
	UpdateHands()

func _process(delta):
	#if Input.is_action_just_pressed("game_pause"):
		#if not parts.pause.timer_stopped: return
		#parts.pause.timer(0.1)
		#world.pause_game()
		#parts.pause.show()
	#
	#if Input.is_action_just_pressed("inventory"):
		#if not parts.inventory.timer_stopped: return
		#parts.inventory.timer(0.1)
		#world.pause_game()
		#parts.inventory.show()
	
	if not ambienceWait: AmbiencePlay()
	
	if locked_controls: return
	
	speed = base_speed
	
	if Input.is_action_pressed("move_sprint"):
		if (stamina > 0):
			stamina -= delta
			sprinting = true
			speed = sprint_speed
			parts.camera.fov = lerp(parts.camera.fov, camera_fov_extents[1], 10*delta)
		
		else:
			sprinting = false
			speed = base_speed
			parts.camera.fov = lerp(parts.camera.fov, camera_fov_extents[0], 10*delta)
			tired()
			
	elif stamina <= max_stamina and regen_stamina:
		stamina += delta/2
	
	if Input.is_action_just_pressed("move_sprint"):
		parts.breathing_audio_player.stream = load("res://assets/audio/playerBreathingLoop.mp3")
		parts.breathing_audio_player.playing = true
	
	if Input.is_action_just_released("move_sprint"):
		parts.breathing_audio_player.stream = load("res://assets/audio/playerBreathing.wav")
		parts.breathing_audio_player.play()
		sprinting = false
		speed = base_speed
		parts.camera.fov = lerp(parts.camera.fov, camera_fov_extents[0], 10*delta)
		tired()
	
	parts.stamina_bar.setValue(stamina)

func _physics_process(delta):
	if locked_controls: return
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y += jump_velocity

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if Input.is_action_pressed("move_lean"):
		speed = sneak_speed
		parts.head.rotation.z = lerp(parts.head.rotation.z, -0.25 * sign(input_dir.x), 0.3)
		input_dir.x = 0
	else:
		parts.head.rotation.z = lerp(parts.head.rotation.z, 0.0, 0.3)
	var direction = input_dir.normalized().rotated(-parts.head.rotation.y)
	direction = Vector3(direction.x, 0, direction.y)
	velocity.x = lerp(velocity.x, direction.x * speed, accel * delta)
	velocity.z = lerp(velocity.z, direction.z * speed, accel * delta)
	
	#bob head
	if input_dir and is_on_floor():
		if sprinting == true:
			parts.camera_animation.play("head_bob_sprint", 0.5)
		else:
			parts.camera_animation.play("head_bob_walk", 0.5)	
	else:
		parts.camera_animation.play("RESET", 0.5)

	move_and_slide()

func _input(event):
	if locked_controls: return
	if event is InputEventMouseMotion:
		if !world.paused:
			parts.head.rotation_degrees.y -= event.relative.x * sensitivity
			parts.hands.rotation_degrees.y -= event.relative.x * sensitivity
			parts.camera.rotation_degrees.x -= event.relative.y * sensitivity
			parts.camera.rotation.x = clamp(parts.camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func tired():
	regen_stamina = false
	await get_tree().create_timer(tired_duration).timeout
	regen_stamina = true

func _on_pause():
	pass

func _on_unpause():
	pass

func damage(value):
	stamina -= value
	tired()
	if (stamina < 0): $HUD/GameOver.gameOver()
	
func damagePercent(value):
	damage((value*max_stamina)/100)
	
func getItem(item : InventoryItem):
	parts.sfx_audio_player.stream = load("res://assets/audio/click.mp3")
	parts.sfx_audio_player.volume_db = -23
	parts.sfx_audio_player.play()
	inventory.insert(item)
	

func AmbiencePlay():
	ambienceWait = true
	await get_tree().create_timer(randf_range(1, 10)).timeout
	parts.ambience_audio_player.stream = load("res://assets/audio/ambienceWind.mp3")
	parts.ambience_audio_player.play()
	ambienceWait = false
	
func HintInteract(show):
	$HUD/InteractionHint.visible = show
	
func UpdateHands():
	left_hand = not !inventory.hands[0].item
	right_hand = not !inventory.hands[1].item
	if !left_hand and !right_hand:
		parts.hands.visible = false
	else:
		parts.hands.visible = true
		parts.hands.leftHand(inventory.hands[0].item)
		parts.hands.rightHand(inventory.hands[1].item)
	
func LockControls(state):
	locked_controls = state
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if state else Input.MOUSE_MODE_CAPTURED)
