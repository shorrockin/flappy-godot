extends Node

@onready var score = $Score
@onready var splash_start = $Splash/Start
@onready var splash_game_over = $Splash/GameOver
@onready var splash_game_over_animation = $Splash/GameOver/Animation
@onready var night_fade_in = $Paralax/Background/Night/Animation

func _ready() -> void:
	Signals.player_died.connect(_on_player_died)

func _process(_delta: float) -> void:
	# don't let them start the game until the end game 
	# animation is done fading in
	if splash_game_over_animation.is_playing():
		return

	# if a splash screen isn't visible then ignore inputs
	if !splash_start.visible && !splash_game_over.visible:
		return

	if Input.is_action_just_pressed("ui_accept"):
		_start_game()

func _start_game() -> void:
	print("[game] starting")
	score.visible = true
	splash_start.visible = false
	splash_game_over.visible = false
	night_fade_in.stop()
	night_fade_in.play("fade")

	Signals.game_started.emit()

func _on_player_died() -> void:
	if !splash_game_over.visible:
		print("[game] player died")
		splash_game_over_animation.play("fade_in")
		splash_game_over.visible = true
		night_fade_in.pause()
