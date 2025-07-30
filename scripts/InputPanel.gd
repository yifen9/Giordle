extends Control

signal submitted(text)

@onready var box: LineEdit = $LineEdit

func _ready() -> void:
	box.alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.connect("text_submitted", Callable(self, "_on_submit"))

func _on_submit(text: String) -> void:
	emit_signal("submitted", text)
	box.text = ""
