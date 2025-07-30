extends Control

const SAVE_PATH := "res://data/win_count.txt"

@onready var number_label: Label = $"HBoxContainer/NumberPanel/Number"

var win_count: int = 0

func _ready() -> void:
	_load_count()
	_update_label()

func add_win(amount: int = 1) -> void:
	win_count += amount
	_update_label()
	_save_count()

func reset() -> void:
	win_count = 0
	_update_label()
	_save_count()

func _update_label() -> void:
	number_label.text = str(win_count)

func _load_count() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
		if f:
			win_count = int(f.get_as_text().strip_edges())
			f.close()
	else:
		win_count = 0
		_save_count()

func _save_count() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(str(win_count))
		f.close()
