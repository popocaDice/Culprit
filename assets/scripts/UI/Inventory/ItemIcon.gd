extends Control

@export var stackable = true

var ammount = 1
var drag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	gui_input.connect(_on_gui_input)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if drag and event is InputEventMouseMotion:
		position += event.relative

func Collect(value):
	ammount += value
	$Label.text = str(ammount)


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			z_index = 10
			drag = true
		else:
			z_index = 0
			drag = false
			get_parent().get_parent().get_parent().moveItem(get_parent().get_name().substr(13, -1).to_int() - 1, get_viewport().get_mouse_position())
			position = Vector2.ZERO
