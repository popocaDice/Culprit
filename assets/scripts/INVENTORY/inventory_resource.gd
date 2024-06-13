extends Resource

class_name Inventory

signal update

@export var slots: Array[InventorySlot]
@export var hands: Array[InventorySlot]

func insert(item: InventoryItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if itemslots.is_empty():
		itemslots = hands.filter(func(slot): return slot.item == item)
	if itemslots.is_empty():
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
		update.emit()
		return
	if(itemslots[0].item.stackable):
			itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()

func moveItem(firstSlot:int, secondSlot:int):
	var tempSlot = slots[firstSlot]
	slots[firstSlot] = slots[secondSlot]
	slots[secondSlot] = tempSlot
	update.emit()

func invertHands():
	var tempSlot = hands[0]
	hands[0] = hands[1]
	hands[1] = tempSlot
	update.emit()

func equipItem(inventorySlot:int, handSlot:int):
	if(!slots[inventorySlot].item):
		var tempSlot = hands[handSlot]
		hands[handSlot] = slots[inventorySlot]
		slots[inventorySlot] = tempSlot
		update.emit()
		return
	if(slots[inventorySlot].item.equipable):
		var tempSlot = hands[handSlot]
		hands[handSlot] = slots[inventorySlot]
		slots[inventorySlot] = tempSlot
	update.emit()
