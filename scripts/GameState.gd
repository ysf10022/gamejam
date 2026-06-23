extends Node

enum Phase { DAY, NIGHT }

signal phase_changed(new_phase: Phase)

var phase: Phase = Phase.DAY
var player_cell: Vector2i = Vector2i.ZERO
var is_win: bool = false

signal win_event

func toggle_phase() -> void:
	if is_win: return
	phase = Phase.NIGHT if phase == Phase.DAY else Phase.DAY
	phase_changed.emit(phase)

func set_win() -> void:
	is_win = true
	win_event.emit()
