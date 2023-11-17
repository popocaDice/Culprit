extends Node3D

var current_movement_speed : float = 0

var idle : bool = true
var waiting : bool = false
var player_in_sight : bool = false
var chasing : float = 0
var patrolling : float = 0

@export var walk_movement_speed : float
@export var sprint_movement_speed : float
@export var chase_duration : int
@export var listen_radius : float
@export var patrol_duration : int

@onready var sight : RayCast3D = $Sight
var player : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")

func _physics_process(delta):
	sight.target_position = sight.to_local(player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(sight.get_collider() == player):
		idle = false
		waiting = false
		player_in_sight = true
		playerInSightState()
	
	elif (chasing > 0):
		player_in_sight = false
		chasing -= delta
		if not waiting: 
			chaseLostPlayerState()
			waiting = true
	
	elif (player.sprinting and player.global_position.distance_to(global_position) < listen_radius):
		idle = false
		waiting = false
		patrolling = patrol_duration
		chaseSoundState()
		
	elif idle and patrolling >= 0:
		patrolling -= delta
		print_debug(patrolling)
		if not waiting:
			patrolState()
			waiting = true
	
	elif idle && not waiting:
		waiting = true
		idleState()

func getMovementSpeed():
	return current_movement_speed

func idleState():
	await get_tree().create_timer(randf_range(2.0, 10.0)).timeout
	waiting = false
	if not idle: return
	idle = false
	current_movement_speed = walk_movement_speed
	get_parent_node_3d().set_movement_target(get_parent_node_3d().position + Vector3(randf_range(-8, 8), 0, randf_range(-8, 8)))
	return

func playerInSightState():
	if chasing <= 0: await get_tree().create_timer(3).timeout
	chasing = chase_duration
	current_movement_speed = sprint_movement_speed
	get_parent_node_3d().set_movement_target(player.position)
	return

func chaseLostPlayerState():
	await get_tree().create_timer(4).timeout
	if (player_in_sight): return
	waiting = false
	current_movement_speed = sprint_movement_speed
	get_parent_node_3d().set_movement_target(player.position)
	return

func chaseSoundState():
	current_movement_speed = sprint_movement_speed
	get_parent_node_3d().set_movement_target(player.position)
	return

func patrolState():
	await get_tree().create_timer(2).timeout
	if(waiting):
		waiting = false
		get_parent_node_3d().set_movement_target(get_parent_node_3d().position + Vector3(randf_range(-8, 8), 0, randf_range(-8, 8)))
	return
