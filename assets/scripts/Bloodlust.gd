extends Node3D

var current_movement_speed : float = 0

var idle : bool = true
var waiting : bool = false
var player_in_sight : bool = false
var chasing : float = 0
var patrolling : float = 0
var player_in_attack_range : bool = false
var can_attack : bool = true

@export var walk_movement_speed : float
@export var sprint_movement_speed : float
@export var chase_duration : int
@export var listen_radius : float
@export var patrol_duration : int
@export var attack_cooldown : float

@onready var sight : RayCast3D = $Sight
var animator: AnimationPlayer
var player : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")
	animator = get_node("../Bloodlust/Armature/Skeleton3D/AnimationPlayer")

func _physics_process(_delta):
	sight.target_position = sight.to_local(player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (player_in_attack_range or not can_attack):
		if (can_attack): attackState()
		
	elif(sight.get_collider() == player):
		idle = false
		waiting = false
		player_in_sight = true
		playerInSightState()
	
	elif (chasing > 0):
		player_in_sight = false
		chasing -= delta
		patrolling = patrol_duration
		if not waiting: 
			waiting = true
			animator.play("idle")
			chaseLostPlayerState()
	
	elif (player.sprinting and player.position.distance_to(global_position) < listen_radius):
		idle = false
		waiting = false
		patrolling = patrol_duration
		chaseSoundState()
		
	elif idle and patrolling >= 0:
		patrolling -= delta
		if not waiting:
			waiting = true
			animator.play("idle")
			patrolState()
	
	elif idle && not waiting:
		waiting = true
		idleState()

func getMovementSpeed():
	return current_movement_speed

func idleState():
	animator.play("idle")
	current_movement_speed = walk_movement_speed
	await get_tree().create_timer(randf_range(2.0, 10.0)).timeout
	waiting = false
	if not idle: return
	idle = false
	animator.play("walk")
	get_parent_node_3d().set_movement_target(global_position + Vector3(randf_range(-8, 8), 0, randf_range(-8, 8)))
	return

func playerInSightState():
	if current_movement_speed == walk_movement_speed:
		get_parent_node_3d().set_movement_target(global_position)
		idle = false
		animator.play("howl")
		$bufando.stop()
		if not $rugindo.playing: $rugindo.play()
		await get_tree().create_timer(3).timeout
		current_movement_speed = sprint_movement_speed
		$bufando.play()
	animator.play("sprint")
	chasing = chase_duration
	current_movement_speed = sprint_movement_speed
	get_parent_node_3d().set_movement_target(player.position)
	return

func chaseLostPlayerState():
	current_movement_speed = sprint_movement_speed
	await get_tree().create_timer(4).timeout
	if (player_in_sight): return
	animator.play("sprint")
	waiting = false
	get_parent_node_3d().set_movement_target(player.position)
	return

func chaseSoundState():
	animator.play("sprint")
	current_movement_speed = sprint_movement_speed
	get_parent_node_3d().set_movement_target(player.position)
	return

func patrolState():
	await get_tree().create_timer(2).timeout
	if(waiting):
		waiting = false
		current_movement_speed = sprint_movement_speed
		animator.play("sprint")
		get_parent_node_3d().set_movement_target(global_position + Vector3(randf_range(-8, 8), 0, randf_range(-8, 8)))
	return
	
func attackState():
	can_attack = false
	animator.play("attack")
	$atacando.play()
	await get_tree().create_timer(0.3).timeout
	player.damagePercent(50)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	


func _on_area_3d_body_entered(body):
	if body == player:
		player_in_attack_range = true


func _on_area_3d_body_exited(body):
	if body == player:
		player_in_attack_range = false
