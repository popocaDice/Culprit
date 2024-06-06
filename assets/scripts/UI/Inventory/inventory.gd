extends Control

var inventory = []
var slots = []

var slotSizePixels
var gridPosition

var timer_stopped = true

@onready var items = {
	"coal": load("res://assets/prefabs/UI/inventory/test_item_icon.tscn"),
}

@onready var world = get_node("/root/World")

# Called when the node enters the scene tree for the first time.
func _ready():
	world.inventory.connect(show)
	world.unventory.connect(hide)
	slots = $InventoryGrid.get_children()
	slotSizePixels = ($InventoryGrid.size.x/ $InventoryGrid.columns)
	gridPosition = $InventoryGrid.position
	updateInventory()

func moveItem(pickIndex, targetPosition):
	var targetGridPosition = Vector2(int((targetPosition.x-gridPosition.x)/slotSizePixels), int((targetPosition.y-gridPosition.y)/slotSizePixels))
	var targetIndex = (16*targetGridPosition.y + targetGridPosition.x)
	if inventory.size() > targetIndex and inventory[targetIndex] != null :
		pass
	else:
		for i in range(inventory.size(), targetIndex-1):
			inventory.append(null)
		inventory[pickIndex].reparent(slots[targetIndex])
		inventory.append(inventory[pickIndex])
		inventory[pickIndex] = null
	updateInventory()

func updateInventory():
	for index in inventory.size():
		if slots[index].get_child_count()>0: 
			if inventory[index] == null or inventory[index].ammount <= 0: 
				slots[index].get_child(0).queue_free()
		elif inventory[index] != null: 
			slots[index].add_child(inventory[index])

func addItem(id):
	var item = items[id].instantiate()
	if item.stackable:
		for i in inventory:
			if i[0] == id:
				i[1] += 1
				print_debug("add item")
				return
	inventory.append([id, 1])
	print_debug("new item")
	#if (itemNode.instantiate().stackable):
	#	for item in inventory:
	#		print_debug(item.name())
	#		if item.get_name() == itemNode.instantiate().get_name():
	#			item.Collect(1)
	#			return
	#inventory.append(itemNode.instantiate())
	#updateInventory()


func _on_button_pressed():
	timer(0.1)
	print_debug("fuck inventory")
	timer_stopped = false
	world.unpause_game()
	hide()


func _on_timer_timeout():
	timer_stopped = true
	
func timer(time):
	$Timer.start(time)
