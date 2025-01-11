extends Area2D

const WIDTH = 48
const DISTANCE_APART = 184
const GAME_WIDTH = 288
const RANDOM_PIPE_DISTANCE_DELTA = 1.4

const Y_POS_MIN = 200
const Y_POS_MAX = 463

@onready var sfx = $Sfx
@onready var start_position: Vector2 = position

var scrolling : bool = false

func _ready() -> void:
	Signals.player_died.connect(_on_player_died)
	Signals.game_started.connect(_on_game_started)
	self.body_exited.connect(_on_exited_score_region)

func _process(delta: float) -> void:
	if !scrolling:
		return

	position.x += Constants.FORGROUND_AUTOSCROLL_SPEED.x * delta

	# if we've scrolled off the back of the screen, then reset
	# it back to the starting position and randomize the height,
	# add some minor variance for the x position
	if position.x < -WIDTH:
		position.x = randf_range(
			GAME_WIDTH * RANDOM_PIPE_DISTANCE_DELTA, 
			(DISTANCE_APART * 2) + WIDTH,
		)
		randomize_height()
			

func randomize_height():
	position.y = randf_range(Y_POS_MIN, Y_POS_MAX)

func _on_exited_score_region(_body:Node2D) -> void:
	if !scrolling:
		return

	sfx.play() 
	Signals.point_scored.emit()

func _on_player_died() -> void:
	scrolling = false

func _on_game_started() -> void: 
	position = start_position
	randomize_height()
	scrolling = true
