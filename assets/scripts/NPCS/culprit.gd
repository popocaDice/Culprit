extends Node3D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
const Balloon = preload("res://assets/dialogue/balloon.tscn")

@export var spawnRangeScale = [1.5,1.5]
@export var spawnRangeOffset = [0.5,0.5]
var spawnRangeScaleY = 4
var spawnRangeOffsetY = 2

@export var turnVelocity = 0.2

var spawnRange
var animationTree: AnimationTree
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
	
	if not Engine.is_editor_hint():
		if DialogueState.CulpritHide and not animationTree.get("parameters/playback").get_current_node() == "hide": 
			animationTree.get("parameters/playback").travel("leave")
		
	if playerInRangeDialogue:
		var prev_rotation = global_transform.basis.get_rotation_quaternion()
		look_at(player.position)
		var target_rotation = global_transform.basis.get_rotation_quaternion()
		rotation = prev_rotation.slerp(target_rotation, turnVelocity).get_euler()
		if animationTree.get("parameters/playback").get_current_node() == "idle" and Input.is_action_just_pressed("interact"):
			startDialogue()
		

func _on_spawn_range_area_entered(area):
	if area.get_parent_node_3d().is_in_group("player") and not DialogueState.CulpritHide and not animationTree.get("parameters/playback").get_current_node() == "idle":
		animationTree.get("parameters/playback").travel("appear")


func _on_spawn_range_area_exited(area):
	if area.get_parent_node_3d().is_in_group("player") and not animationTree.get("parameters/playback").get_current_node() == "hide":
		animationTree.get("parameters/playback").travel("leave")
	DialogueState.CulpritHide = false


func _on_interaction_range_area_entered(area):
	if area.get_parent_node_3d().is_in_group("player") and animationTree.get("parameters/playback").get_current_node() == "idle":
		area.get_parent_node_3d().HintInteract(true)
		playerInRangeDialogue = true


func _on_interaction_range_area_exited(area):
	if area.get_parent_node_3d().is_in_group("player"):
		area.get_parent_node_3d().HintInteract(false)
		playerInRangeDialogue = false
		
func forceState(state: String):
	animationTree.get("parameters/playback").start(state)
	
func startDialogue():
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
