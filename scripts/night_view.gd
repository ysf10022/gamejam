extends Node2D



func _ready() -> void:
	RoomData.clause_changed.connect(func(_id): queue_redraw())
	GameState.phase_changed.connect(func(_p): queue_redraw())

func _draw() -> void:
	var t: int = RoomData.TILE
	# 出口方块（胜利方块）
	var exit_pos = RoomData.ORIGIN + Vector2(RoomData.exit_cell) * t
	draw_rect(Rect2(exit_pos + Vector2(t*0.2, t*0.2), Vector2(t*0.6, t*0.6)), Color(0.2, 0.8, 0.4))
	# 边界墙 + 内部墙
	for cell in RoomData.wall_cells:
		draw_rect(Rect2(RoomData.ORIGIN + Vector2(cell) * t, Vector2(t, t)),
				Color(0.25, 0.25, 0.3))
	for cell in RoomData.walls:
		draw_rect(Rect2(RoomData.ORIGIN + Vector2(cell) * t, Vector2(t, t)),
				Color(0.3, 0.3, 0.35))
	# 物理门(未 open 时画实体)
	for id in RoomData.doors:
		var d = RoomData.doors[id]
		var cid = d["clause_id"]
		var is_open = false
		if RoomData.clauses.has(cid) and RoomData.clauses[cid]["value"] == d["open_value"]:
			is_open = true
			
		if not is_open:
			for cell in d["cells"]:
				draw_rect(Rect2(RoomData.ORIGIN + Vector2(cell) * t, Vector2(t, t)),
						Color(0.4, 0.2, 0.2))
