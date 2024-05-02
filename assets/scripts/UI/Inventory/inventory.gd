extends Control

var inventory = []
var slots = []

var slotSizePixels
var gridPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	
	slots = $InventoryGrid.get_children()
	slotSizePixels = ($InventoryGrid.size.x/ $InventoryGrid.columns)
	gridPosition = $InventoryGrid.position
	updateInventory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	 if Input.is_action_just_pressed("move_jump"):
#		addItem(load("res://assets/prefabs/UI/inventory/test_item_icon.tscn"))
#		
#	if (Input.is_action_just_pressed("move_forward")):
#		addItem(load("res://assets/prefabs/UI/inventory/test_item_red_icon.tscn"))
	pass

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

func addItem(itemNode):
	if (itemNode.instantiate().stackable):
		for item in inventory:
			print_debug(item.name())
			if item.get_name() == itemNode.instantiate().get_name():
				item.Collect(1)
				return
	inventory.append(itemNode.instantiate())
	updateInventory()
