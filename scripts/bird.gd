extends CharacterBody2D

@onready var sprite = $Sprite
@onready var collision = $Collision
@onready var sfx_flap = $Sfx/Flap
@onready var sfx_die = $Sfx/Die
@onready var reset_position = position

const JUMP_VELOCITY: float = -350.0
const JUMP_ANGLE_START: float = -68
const JUMP_ANGLE_DELTA:float = 2.5
const JUMP_ANGLE_STOP:float = 74

var dead : bool = false

func _ready() -> void:
	Signals.player_died.connect(_on_player_died)
	Signals.game_started.connect(_on_game_started)

func _on_game_started() -> void:
	print("[bird] game_started")
	collision.set_deferred("disable", false)
	visible = true
	dead = false
	position = reset_position

func _on_player_died() -> void:
	if dead: return

	print("[bird] disabling collision")
	collision.set_deferred("disable", true)
	dead = true
	sfx_die.play()

func _on_enter_killbox(_body:Node2D) -> void:
	print("[bird] floor death")
	Signals.player_died.emit()

func _physics_process(delta: float) -> void:
	if !visible: return

	velocity += get_gravity() * delta

	if !dead && Input.is_action_pressed("ui_accept"):
		# just play the sfx once if they're holding 
		# the action button
		if Input.is_action_just_pressed("ui_accept"):
			sfx_flap.play()

		sprite.rotation_degrees = JUMP_ANGLE_START
		velocity.y = JUMP_VELOCITY
	else:
		sprite.rotation_degrees = move_toward(sprite.rotation_degrees, JUMP_ANGLE_STOP, JUMP_ANGLE_DELTA)

	# don't let the bird exceed the top of the screen
	if position.y <= 0: position.y = 0

	move_and_slide()
