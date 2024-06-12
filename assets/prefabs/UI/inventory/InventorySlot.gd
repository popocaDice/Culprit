extends PanelContainer

var itemClass = preload("res://assets/prefabs/UI/inventory/test_item_icon.tscn")
@onready var visual: PanelContainer = $PanelDisplay
@onready var amount_text: Label = $Label

func update(slot: InventorySlot):
	if !slot.item:
		visual.visible = false
		amount_text.visible = false
	else:
		visual.visible = true
		var new_style: StyleBoxTexture = visual.get_theme_stylebox("panel", "Slot").duplicate()
		new_style.texture = slot.item.texture
		visual.add_theme_stylebox_override("panel", new_style)
		if slot.amount > 1:
			amount_text.visible = true
		amount_text.text = str(slot.amount)
