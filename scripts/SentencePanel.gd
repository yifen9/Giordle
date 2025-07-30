extends Control

const FONT_RES := preload("res://assets/fonts/font_wordle.otf")
const CLR_SOLVED   := Color("#ee5b87")
const CLR_SOLVED_FIRST   := Color("#b30452")
const CLR_CURRENT  := Color("#5b9dee")
const CLR_CURRENT_FIRST  := Color("#046fb3")
const CLR_UNSOLVED := Color("#a4a4a4")
const CLR_UNSOLVED_FIRST    := Color("#5b5b5b")

@onready var sentence_container := $Sentence

var word_labels: Array = []

func _build_unsolved_text(word: String) -> String:
	var bb := "[color=" + CLR_UNSOLVED_FIRST.to_html(false) + "]" + word.substr(0,1).to_upper() + "[/color] "
	for i in range(1, word.length()):
		bb += "[color=" + CLR_UNSOLVED.to_html(false) + "]_ [/color]"
	return bb.strip_edges()

func _build_current_text(word: String) -> String:
	var bb := "[color=" + CLR_CURRENT_FIRST.to_html(false) + "]" + word.substr(0,1).to_upper() + "[/color] "
	for i in range(1, word.length()):
		bb += "[color=" + CLR_CURRENT.to_html(false) + "]_ [/color]"
	return bb.strip_edges()

func _build_solved_text(word: String) -> String:
	var bb := "[color=" + CLR_SOLVED_FIRST.to_html(false) + "]" + word.substr(0,1).to_upper() + "[/color]"
	for i in range(1, word.length()):
		bb += " [color=" + CLR_SOLVED.to_html(false) + "]" + word[i].to_upper() + "[/color]"
	return bb.strip_edges()

func _build_failed_text(word: String) -> String:
	var bb := "[color=" + CLR_UNSOLVED_FIRST.to_html(false) + "]" + word.substr(0,1).to_upper() + "[/color]"
	for i in range(1, word.length()):
		bb += " [color=" + CLR_UNSOLVED.to_html(false) + "]" + word[i].to_upper() + "[/color]"
	return bb.strip_edges()

func _ready():
	pass
	
func setup(words: Array) -> void:
	for lbl in word_labels:
		lbl.queue_free()
	word_labels.clear()

	for idx in words.size():
		var w = words[idx]
		var lbl := RichTextLabel.new()
		lbl.bbcode_enabled = true
		lbl.fit_content = true
		lbl.custom_minimum_size.x = 370
		lbl.add_theme_font_override("normal_font", FONT_RES)
		lbl.add_theme_font_size_override("normal_font_size", 32)

		lbl.set_meta("word", w)

		if idx == 0:
			lbl.text = _build_current_text(w)
		else:
			lbl.text = _build_unsolved_text(w)

		sentence_container.add_child(lbl)
		word_labels.append(lbl)
		
func reveal_word(is_solved: int, idx: int) -> void:
	if idx >= 0 and idx < word_labels.size():
		var full = word_labels[idx]
		full.text = full.text.replace("_", "")
		if is_solved == 0:
			full.text = _build_failed_text(full.get_meta("word").to_upper())
		elif is_solved == 1:
			full.text = _build_solved_text(full.get_meta("word").to_upper())
		else:
			full.text = _build_current_text(full.get_meta("word").to_upper())
