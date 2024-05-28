@tool
extends Node3D

@export var spawnRangeScale = [1,1]
@export var spawnRangeOffset = [0,0]
var spawnRangeScaleY = 4
var spawnRangeOffsetY = 2

@export var turnVelocity = 0.2

var spawnRange
var animationTree
var armature
var player

var playerInRangeDialogue = false

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnRange = $SpawnRange/CollisionShape3D
	animationTree = $AnimationTree
	armature = $Armature
	player = get_tree().get_first_node_in_group("player")
	spawnRange.shape = spawnRange.shape.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint:
		spawnRange.position = Vector3(spawnRangeOffset[0], spawnRangeOffsetY, spawnRangeOffset[1])
		spawnRange.shape.size = Vector3(spawnRangeScale[0], spawnRangeScaleY, spawnRangeScale[1])
	
	if playerInRangeDialogue:
		var prev_rotation = global_transform.basis.get_rotation_quaternion()
		look_at(player.position)
		var target_rotation = global_transform.basis.get_rotation_quaternion()
		rotation = prev_rotation.slerp(target_rotation, turnVelocity).get_euler()
		if Input.is_action_just_pressed("interact"):
			player.OpenDialogue()
		



func _on_spawn_range_area_entered(area):
	if area.get_parent_node_3d().is_in_group("player"):
		animationTree.set("parameters/conditions/playerInRange", true)


func _on_spawn_range_area_exited(area):
	if area.get_parent_node_3d().is_in_group("player"):
		animationTree.set("parameters/conditions/playerInRange", false)


func _on_interaction_range_area_entered(area):
	if area.get_parent_node_3d().is_in_group("player") and animationTree.get("parameters/conditions/playerInRange"):
		area.get_parent_node_3d().HintInteract(true)
		playerInRangeDialogue = true


func _on_interaction_range_area_exited(area):
	if area.get_parent_node_3d().is_in_group("player"):
		area.get_parent_node_3d().HintInteract(false)
		playerInRangeDialogue = false
		player.CloseDialogue()
