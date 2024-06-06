extends PanelContainer

var itemClass = preload("res://assets/prefabs/UI/inventory/test_item_icon.tscn")
@onready var item_visual:Sprite2D = $CenterContainer/ItemDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update(item: InventoryItem):
	if !item:
		item_visual.visible = false
	else:
		item_visual.texture = item.texture
		item_visual.visible = true
