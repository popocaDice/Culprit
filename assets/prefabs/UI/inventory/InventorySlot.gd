extends PanelContainer

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
		else:
			amount_text.visible = false
		amount_text.text = str(slot.amount)

func _on_button_pressed():
	if(get_parent().name == "HandsGrid"):
		get_parent().clicked(self, true)
		return
	get_parent().clicked(self, false)
