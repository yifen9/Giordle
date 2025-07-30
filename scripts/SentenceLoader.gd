extends Node

@export var chat_log_path: String = "res://data/chats.txt"

var entries: Array = []

func _ready() -> void:
	randomize()
	load_and_process_chat()
	
func load_and_process_chat() -> void:
	entries.clear()
	var text: String = ""
	var file = FileAccess.open(chat_log_path, FileAccess.READ)
	if file:
		text = file.get_as_text()
		file.close()
	else:
		push_error("SentenceLoader: Failed opening chats.txt")
		return
	_parse_chat_text(text)

func _parse_chat_text(text: String) -> void:
	var split_chars = [",", ", ", ",  ", ".", ". ", ".  "]
	for line in text.split("\n", false):
		line = line.strip_edges()
		if line == "" or not line.contains(" - "):
			continue
		var parts = line.split(" - ", false)
		if parts.size() < 2:
			continue
		var timestamp = parts[0].strip_edges()
		var sender_and_msg = parts[1].split(": ", false)
		if sender_and_msg.size() < 2:
			continue
		var sender = sender_and_msg[0].strip_edges()
		var message = sender_and_msg[1]
		var segments = _split_by_chars(message, split_chars)
		for seg in segments:
			seg = seg.strip_edges()
			if seg == "":
				continue
			var words: Array = []
			for w in seg.split(" ", false):
				w = w.to_lower().strip_edges()
				if w.length() >= 1:
					words.append(w)
			if words.size() >= 3:
				entries.append({
					"timestamp": timestamp,
					"sender":    sender,
					"words":     words
				})
		
func _split_by_chars(s: String, chars: Array) -> Array:
	var result = [s]
	for c in chars:
		var tmp: Array = []
		for seg in result:
			var parts = seg.split(c, false)
			for part in parts:
				tmp.append(part)
		result = tmp
	return result
	
func get_random_entry() -> Dictionary:
	if entries.is_empty():
		return {}
	return entries[randi() % entries.size()]

func get_random_sentence() -> Array:
	var entry = get_random_entry()
	if entry.has("words"):
		return entry.words
	else:
		return []
