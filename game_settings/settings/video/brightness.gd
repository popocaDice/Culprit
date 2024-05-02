@tool
extends ggsSetting


func apply(value: float) -> void:
	var f = load("res://assets/prefabs/cameraSettings.tres")
	f.exposure_multiplier = value
	ResourceSaver.save(f, f.resource_path)
