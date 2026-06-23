extends Node2D



func _ready() -> void:
	RoomData.clause_changed.connect(func(_id): queue_redraw())
	GameState.phase_changed.connect(func(_p): queue_redraw())

func _draw() -> void:
	var t: int = RoomData.TILE
