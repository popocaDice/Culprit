extends Control

@onready var world


# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_node("/root/World")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_return_pressed():
	get_parent().on_cancel_pressed()
	$CancelAudio.play()


func _on_audio_pressed():
	$Main.hide()
	$AudioSettings.show()
	$ClickAudio.play()


func _on_cancel_pressed():
	$AudioSettings.hide()
	$VideoSettings.hide()
	$GameplaySettings.hide()
	$Main.show()
	$CancelAudio.play()


func _on_save_pressed():
	$AudioSettings.hide()
	$VideoSettings.hide()
	$GameplaySettings.hide()
	$Main.show()
	$ClickAudio.play()


func _on_video_pressed():
	$Main.hide()
	$VideoSettings.show()
	$ClickAudio.play()
