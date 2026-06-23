@tool
extends Node2D

@export var sprite: Texture2D:
	set(v):
		sprite = v
		queue_redraw()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	var cell = Vector2i(((global_position - RoomData.ORIGIN) / float(RoomData.TILE)).round())
	global_position = RoomData.ORIGIN + Vector2(cell) * float(RoomData.TILE)
	RoomData.set_exit_cell(cell)
	
	GameState.phase_changed.connect(func(_p): queue_redraw())

func _draw() -> void:
	if not Engine.is_editor_hint():
		if GameState.phase == GameState.Phase.DAY:
			return
		
	var t = 64
	if sprite != null:
		draw_texture_rect(sprite, Rect2(0, 0, t, t), false)
	else:
		draw_rect(Rect2(t*0.2, t*0.2, t*0.6, t*0.6), Color(0.2, 0.8, 0.4))
