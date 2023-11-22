extends Control

@onready var world

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_node("/root/World")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	world.loadScene("res://assets/scenes/test_scene.tscn")


func _on_settings_pressed():
	$Main.hide()
	$Settings.show()


func on_cancel_pressed():
	$Settings.hide()
	$Main.show()


func on_save_pressed():
	$Settings.hide()
	$Main.show()
