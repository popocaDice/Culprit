extends CharacterBody3D

@export var base_speed = 5
@export var sprint_speed = 8
@export var jump_velocity = 4
@export var sensitivity = 0.1
@export var accel = 10
@export var max_stamina = 6.0

var stamina = max_stamina
var speed = base_speed
var sprinting = false
var camera_fov_extents = [75.0, 85.0] #index 0 is normal, index 1 is sprinting


@onready var parts = {
	"head": $Head,
	"hands": $Hands,
	"camera": $Head/Camera,
	"camera_animation": $Head/Camera/camera_animation,
	"stamina_bar": $HUD/StaminaBar,
	"pause": $HUD/PauseMenu
}
@onready var world = get_parent()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	world.pause.connect(_on_pause)
	world.unpause.connect(_on_unpause)
	
	parts.camera.current = true
	parts.stamina_bar.max_value = max_stamina

func _process(delta):
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
	
	elif stamina <= max_stamina:
		sprinting = false
		speed = base_speed
		stamina += delta/2
		
	if Input.is_action_pressed("game_pause"):
		world.pause_game()
		parts.pause.show()
	
	parts.stamina_bar.setValue(stamina)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y += jump_velocity

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
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
		parts.camera_animation.play("reset", 0.5)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		if !world.paused:
			parts.head.rotation_degrees.y -= event.relative.x * sensitivity
			parts.hands.rotation_degrees.y -= event.relative.x * sensitivity
			parts.head.rotation_degrees.x -= event.relative.y * sensitivity
			parts.head.rotation.x = clamp(parts.head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _on_pause():
	pass

func _on_unpause():
	pass

func damage(value):
	stamina -= value
	
func damagePercent(value):
	stamina -= (value*max_stamina)/100
