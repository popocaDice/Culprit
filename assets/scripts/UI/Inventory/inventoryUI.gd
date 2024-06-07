extends Control

@onready var inventory: InventoryResource = preload("res://assets/prefabs/inventory/playerinventory.tres")
@onready var slots: Array = $InventoryGrid.get_children()
@onready var world = get_node("/root/World")

# Called when the node enters the scene tree for the first time.
func _ready():
	updateSlots()
	world.inventory.connect(openInventory)
	world.unventory.connect(closeInventory)

func updateSlots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func openInventory():
	updateSlots()
	show()

func closeInventory():
	hide()

func _on_button_pressed():
	world.unpause_game()
	hide()
