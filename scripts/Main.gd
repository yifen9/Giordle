extends Control

@onready var sentence_panel := $GameLayer/GameUI/LeftPanel/SentencePanelContainer/SentencePanel
@onready var sender_panel   := $GameLayer/GameUI/LeftPanel/SenderPanelContainer/SenderPanel
@onready var word_panel     := $GameLayer/GameUI/GuessPanel/WordPanelContainer/WordPanel
@onready var input_panel    := $GameLayer/GameUI/GuessPanel/InputPanelContainer/InputPanel
@onready var wins_panel     := $GameLayer/GameUI/RightPanelContainer/RightPanel/StatsContainer/WinsPanelContainer/WinsPanel
@onready var log_panel      := $GameLayer/GameUI/RightPanelContainer/RightPanel/LogContainer

var words: Array = []
var current_index: int = 0

var waiting_for_next = false

func _input(event: InputEvent) -> void:
	if waiting_for_next and event.is_action_pressed("ui_accept"):
		waiting_for_next = false
		log_panel.show_emotion("idle")
		sentence_panel.reveal_word(2, current_index)
		if current_index < words.size():
			word_panel.call_deferred("start", words[current_index])
		else:
			start_round()
		return

func _ready() -> void:
	word_panel.connect("guess_wrong", Callable(self, "_on_guess_wrong"))
	word_panel.connect("guess_success", Callable(self, "_on_guess_success"))
	word_panel.connect("guess_failed", Callable(self, "_on_guess_failed"))
	input_panel.connect("submitted", Callable(word_panel, "submit_guess"))

	start_round()

func start_round() -> void:
	log_panel.show_emotion("idle")
	
	var entry = SentenceLoader.get_random_entry()
	
	if entry.is_empty():
		push_error("No entry")
		return
	
	words = entry.words
	current_index = 0
	
	print(words)
	
	sentence_panel.setup(words)
	sender_panel.set_sender(entry.sender)
	
	word_panel.call_deferred("start", words[current_index])

func _on_guess_wrong(word: String) -> void:
	log_panel.show_emotion("wrong")

func _on_guess_success(word: String) -> void:
	sentence_panel.reveal_word(1, current_index)
	current_index += 1
	if current_index < words.size():
		log_panel.show_emotion("correct")
		waiting_for_next = true
	else:
		log_panel.show_emotion("win")
		wins_panel.add_win()
		waiting_for_next = true

func _on_guess_failed(word: String) -> void:
	log_panel.show_emotion("fail")
	for i in range(current_index, words.size()):
		sentence_panel.reveal_word(0, i)
	current_index = words.size()
	waiting_for_next = true
