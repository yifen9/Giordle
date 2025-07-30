extends Control

const CHAR_DELAY := 0.05
const IDLE_TIMEOUT := 30.0

const EMOTIONS := {
	"win": {
		"texts": [
			"The important thing is that you are getting progress",
			"Seems I underestimated you",
			"Keep going and you will be successful in the end",
			"Seeing you get recovered again is the most joyful thing"
		],
		"stickers": [
			"res://assets/stickers/win_0.webp",
			"res://assets/stickers/win_1.webp",
			"res://assets/stickers/win_2.webp"
		]
	},
	"fail": {
		"texts": [
			"Hey, don't be sad ... wanna eat some ice cream together?",
			"It's fine, I failed this as well. It's not your fault ...",
			"Even if you fail, I am still willing to be here with you ...",
			"Don't push yourself too hard. You don't need to be perfect at everything ..."
		],
		"stickers": [
			"res://assets/stickers/idle_0.webp",
			"res://assets/stickers/idle_1.webp",
			"res://assets/stickers/idle_2.webp"
		]
	},
	"correct": {
		"texts": [
			"I mean, at least it is something",
			"IQ 133 moment",
			"Still doesn't mean you are an INTP or an introvert",
			"Peak Italian education",
			"I cannot believe you spent that much time on this retarded question",
			"Lucky",
			"Yes, of course it worths a party",
			"Would be weird if you fail this"
		],
		"stickers": [
			"res://assets/stickers/correct_0.webp",
			"res://assets/stickers/correct_1.webp",
			"res://assets/stickers/correct_2.webp"
		]
	},
	"wrong": {
		"texts": [
			"Stupid as always",
			"If you fail again, I will kill you by my hand",
			"Seems I need to rejudge you",
			"Yet you are still at an university?",
			"What? Did Genshin rot your brain or something?",
			"Exactly what I can expect from a TikTok party enjoyer",
			"Funny",
			"If you cannot pass this even, what else can you success in your life?"
		],
		"stickers": [
			"res://assets/stickers/wrong_0.webp",
			"res://assets/stickers/wrong_1.webp",
			"res://assets/stickers/wrong_2.webp"
		]
	},
	"idle": {
		"texts": [
			"I stare at my screen ... waiting for her reply",
			"Did I do anything wrong? ... I question myself",
			"She is with her friends again ... but isn't me her friend as well?",
			"I tell her my thoughts ... wait, too long",
			"She is kind to me, but she is kind to everyone ...",
			"Is Star Rail better than me? But she rejected me playing with her ...",
			"I know she doesn't need, but doesn't she want? ... OK she doesn't want, but I want",
			"She is yapping again, taking notes ...",
			"She always say she doesn't deserve me. I wonder why ...",
			"Maybe she cannot fall asleep? Let me check her Discord ...",
			"What if I could become friend with her years ago? Will her past be better? ...",
			"She keeps rejecting me. I cannot distinguish if she likes me anymore ...",
			"Will you return? A beautiful wish ...",
			"Why doesn't she just tell me all her feeling? ... Is she stupid?",
			"I want to help her, but how ...",
			"Why does she spend tons of time on appearance? She is already beautiful enough ..."
		],
		"stickers": [
			"res://assets/stickers/idle_0.webp",
			"res://assets/stickers/idle_1.webp",
			"res://assets/stickers/idle_2.webp"
		]
	}
}

@onready var chat_label: Label      = $ChatPanelContainer/ChatPanel/Chat
@onready var sticker_sprite: Sprite2D = $StickerPanelContainer/StickerPanel/Sticker

var _is_typing: bool = false
var _typing_text: String = ""
var _typing_index: int = 0
var _typing_acc: float = 0.0

var _idle_timer: Timer
var _in_idle: bool = false

func _ready() -> void:
	randomize()
	_idle_timer = Timer.new()
	_idle_timer.one_shot = true
	add_child(_idle_timer)
	_idle_timer.timeout.connect(_on_idle_timeout)
	_reset_idle_timer()

func _process(delta: float) -> void:
	if _is_typing:
		_typing_acc += delta
		while _typing_acc >= CHAR_DELAY and _is_typing:
			_typing_acc -= CHAR_DELAY
			chat_label.text += _typing_text[_typing_index]
			_typing_index += 1
			if _typing_index >= _typing_text.length():
				_is_typing = false
				break

func show_emotion(kind: String) -> void:
	if not EMOTIONS.has(kind):
		return
	_reset_idle_timer()

	var data = EMOTIONS[kind]
	var arr = data["stickers"]
	sticker_sprite.texture = load(arr[randi() % arr.size()])

	_is_typing = false
	chat_label.text = ""

	_typing_text = data["texts"][randi() % data["texts"].size()]
	_typing_index = 0
	_typing_acc = 0.0
	_is_typing = true

	if kind != "idle":
		_in_idle = false

func _reset_idle_timer() -> void:
	_idle_timer.wait_time = IDLE_TIMEOUT
	_idle_timer.start()

func _on_idle_timeout() -> void:
	if not _in_idle:
		_in_idle = true
		show_emotion("idle")
		_schedule_idle_refresh()

func _schedule_idle_refresh() -> void:
	var t = Timer.new()
	t.one_shot = true
	add_child(t)
	t.wait_time = randf_range(60.0, 120.0)
	t.timeout.connect(Callable(self, "_on_idle_refresh_timer"))
	t.start()

func _on_idle_refresh_timer() -> void:
	if _in_idle:
		show_emotion("idle")
		_schedule_idle_refresh()
