extends Node3D

@export var item: InventoryItem

@onready var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")

func _on_area_3d_body_entered(body):
	if body == player: 
		
		player.getItem(item)
		queue_free()
