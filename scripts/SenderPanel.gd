extends Control

@onready var name_label: Label = $Label

const FONT_RES := preload("res://assets/fonts/font_wordle.otf")

func _ready() -> void:
	name_label.add_theme_font_override("font", FONT_RES)
	name_label.add_theme_font_size_override("font_size", 56)
	name_label.add_theme_color_override("font_color", Color("#5b9dee"))
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER

func set_sender(sender: String) -> void:
	var short_sender := " ".join(sender.split(" ", false, 2).slice(0, 2))
	name_label.text = short_sender.capitalize()
