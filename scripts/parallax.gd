extends Parallax2D

@export var is_background: bool = true

func _ready() -> void:
	_start_scrolling()
	Signals.player_died.connect(_stop_scrolling)
	Signals.game_started.connect(_start_scrolling)

func _stop_scrolling() -> void:
	autoscroll = Vector2(0, 0)

func _start_scrolling() -> void:
	if is_background:
		autoscroll = Constants.BACKGROUND_AUTOSCROLL_SPEED
	else:
		autoscroll = Constants.FORGROUND_AUTOSCROLL_SPEED
