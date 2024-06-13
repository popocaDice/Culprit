extends Control

@onready var inventory: Inventory = preload("res://assets/prefabs/inventory/playerinventory.tres")
@onready var slots: Array = $InventoryGrid.get_children()
@onready var hands: Array = $HandsGrid.get_children()
@onready var world = get_node("/root/World")

var clickedPosition = -1
var clickedPositionHand = false

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.update.connect(updateSlots)
	updateSlots()
	world.inventory.connect(openInventory)
	world.unventory.connect(closeInventory)

func updateSlots():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])
	for i in range(min(inventory.hands.size(), hands.size())):
		hands[i].update(inventory.hands[i])

func openInventory():
	updateSlots()
	show()

func closeInventory():
	hide()

func _on_button_pressed():
	world.unpause_game()
	hide()

func clicked(slotIndex:int, isHand:bool):
	if(clickedPosition == slotIndex):
		if(clickedPositionHand == isHand):
			clickedPosition = -1
			clickedPositionHand = false
			if(isHand):
				hands[slotIndex].get_children()[2].release_focus()
			else:
				slots[slotIndex].get_children()[2].release_focus()
			return
	if(clickedPosition == -1):
		clickedPosition = slotIndex
		clickedPositionHand = isHand
		return
	if(clickedPositionHand and isHand):
		inventory.invertHands()
	elif(clickedPositionHand):
		inventory.equipItem(slotIndex, clickedPosition)
	elif(isHand):
		inventory.equipItem(clickedPosition, slotIndex)
	else:
		inventory.moveItem(clickedPosition, slotIndex)
	#2 is the index of the button in inventory_space
	if(isHand):
		hands[slotIndex].get_children()[2].release_focus()
	else:
		slots[slotIndex].get_children()[2].release_focus()
	clickedPosition = -1
	clickedPositionHand = false
