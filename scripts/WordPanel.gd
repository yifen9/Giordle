extends Control

const FONT_RES := preload("res://assets/fonts/font_wordle.otf")

signal guess_wrong(word)
signal guess_success(word)
signal guess_failed(word)

@onready var grid: GridContainer = $GridContainer

var target_word: String = ""
var max_attempts: int = 6
var current_attempt: int = 0
var letter_labels: Array = []

const BOARD_SIZE := 750
const CELL_MAX   := 400
const CELL_MIN   := 0

func _calc_max_attempts(word_length: int) -> int:
	var base = int(round(float(word_length) / 5.0 * 6.0))
	return max(base, 3)
	
func _ready() -> void:
	pass

func start(word: String) -> void:
	target_word = word.to_lower()
	current_attempt = 0
	letter_labels.clear()
	
	max_attempts = _calc_max_attempts(target_word.length())
	call_deferred("_init_grid")

func _init_grid() -> void:
	var cols := target_word.length()
	var rows := max_attempts
	
	var cell := int(min(BOARD_SIZE / cols, BOARD_SIZE / rows, CELL_MAX))
	cell = max(cell, CELL_MIN)
	
	var sep_h := grid.get_theme_constant("h_separation")
	var sep_v := grid.get_theme_constant("v_separation")
	
	var w := cols * cell + (cols - 1) * sep_h
	var h := rows * cell + (rows - 1) * sep_v
	
	grid.columns = cols
	grid.custom_minimum_size = Vector2(w, h)
	
	grid.anchor_left   = 0.5
	grid.anchor_top    = 0.5
	grid.anchor_right  = 0.5
	grid.anchor_bottom = 0.5
	grid.offset_left   = -w / 2
	grid.offset_top    = -h / 2
	grid.offset_right  =  w / 2
	grid.offset_bottom =  h / 2
	
	for c in grid.get_children():
		c.queue_free()
	letter_labels.clear()

	for i in range(rows * cols):
		var lbl := Label.new()
		lbl.custom_minimum_size = Vector2(cell, cell)
		lbl.text = ""
		lbl.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_override("font", FONT_RES)
		lbl.add_theme_font_size_override("font_size", cell)
		# lbl.add_theme_color_override("font_color", Color("#ee5b87"))
		grid.add_child(lbl)
		letter_labels.append(lbl)

func submit_guess(text: String) -> void:
	var guess = text.strip_edges().to_lower()
	if guess.length() != target_word.length():
		return
	_submit_guess(guess)

func _submit_guess(guess: String) -> void:
	var result := []
	for i in range(guess.length()):
		if guess[i] == target_word[i]:
			result.append("correct")
		else:
			result.append("")
	for i in range(guess.length()):
		if result[i] == "":
			if target_word.find(guess[i]) != -1:
				result[i] = "present"
			else:
				result[i] = "absent"
	for i in range(guess.length()):
		var idx = current_attempt * guess.length() + i
		var lbl = letter_labels[idx]
		lbl.text = guess[i].to_upper()
		match result[i]:
			"correct": lbl.add_theme_color_override("font_color", Color("#ee5b87"))
			"present": lbl.add_theme_color_override("font_color", Color("#5b9dee"))
			"absent": lbl.add_theme_color_override("font_color", Color("#a4a4a4"))
	if guess == target_word:
		emit_signal("guess_success", guess)
	else:
		current_attempt += 1
		if current_attempt >= max_attempts:
			emit_signal("guess_failed", target_word)
		else:
			emit_signal("guess_wrong", target_word)
