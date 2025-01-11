extends Area2D

func ready() -> void: 
	self.on_body_entered.connect(_on_body_entered)

func _on_body_entered(_body:Node2D) -> void:
	print("[killbox] _on_body_entered")
	Signals.player_died.emit()
