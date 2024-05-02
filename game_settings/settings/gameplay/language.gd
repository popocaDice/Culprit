@tool
extends ggsSetting

@export var languages: Array[String]: set = set_scales

func _init() -> void:
	value_hint_string = ",".join(_get_scales_strings())

func apply(value: int) -> void:
	TranslationServer.set_locale(languages[value])


### Scales

func set_scales(value: Array[String]) -> void:
	languages = value
	
	if Engine.is_editor_hint():
		value_hint_string = ",".join(_get_scales_strings())
		ggsUtils.get_editor_interface().call_deferred("inspect_object", self)

func _get_scales_strings() -> PackedStringArray:
	var languages_strings: PackedStringArray = []
	for language in languages:
		languages_strings.append(language + "_LANGUAGE")
	
	return languages_strings
