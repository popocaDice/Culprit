extends CharacterBody3D
var movement_target_position: Vector3

@onready var entity: Node3D = $Behaviour
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	
	entity = get_node("Behaviour")

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	movement_target_position = position
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		entity.idle = true
		return

	var current_agent_position: Vector3 = position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var new_velocity: Vector3 = next_path_position - current_agent_position
	rotation.y = atan2(new_velocity.x, new_velocity.z)
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * entity.getMovementSpeed()

	velocity = new_velocity
	move_and_slide()
