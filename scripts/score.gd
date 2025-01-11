extends Label

var score : int = 0:
	set(value):
		score = value
		text = str(score)

func _ready() -> void:
	Signals.point_scored.connect(_on_point_scored)
	Signals.game_started.connect(_on_game_started)

func _on_game_started() -> void:
	self.score = 0

func _on_point_scored() -> void:
	self.score += 1
