extends PanelContainer

var itemClass = preload("res://assets/prefabs/UI/inventory/test_item_icon.tscn")
@onready var visual: PanelContainer = $PanelDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update(item: InventoryItem):
	if !item:
		visual.visible = false
	else:
		visual.visible = true
		var new_style: StyleBoxTexture = visual.get_theme_stylebox("panel", "Slot").duplicate()
		new_style.texture = item.texture
		visual.add_theme_stylebox_override("panel", new_style)
