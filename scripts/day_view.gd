extends Control

func _ready() -> void:
	RoomData.clause_changed.connect(func(_id): queue_redraw())
	queue_redraw()

func _draw() -> void:
	var font: Font = ThemeDB.fallback_font
	var t: float = float(RoomData.TILE)

	# 1. 绘制边界墙和实体墙
	var wall_fs := 28
	var wall_col := Color(0.65, 0.65, 0.65)
	for cell in RoomData.wall_cells + RoomData.walls:
		var pos = RoomData.ORIGIN + Vector2(cell) * t
		# 64x64的格子，填入1列x2行的wall，完美复刻上一版的视觉密度
		for row in range(2):
			var y = pos.y + (row * 32) + 26
			draw_string(font, Vector2(pos.x + 8, y), "wall", HORIZONTAL_ALIGNMENT_LEFT, -1, wall_fs, wall_col)

	# 2. 绘制静态文字 (the, door, is)
	var static_fs := 24
	var static_col := Color(0.8, 0.8, 0.8)
	for word_data in RoomData.static_words:
		var pos = RoomData.ORIGIN + Vector2(word_data["cell"]) * t
		var text = word_data["word"]
		var text_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, static_fs)
		var offset_x = (t - text_size.x) / 2.0
		var offset_y = t / 2.0 + static_fs * 0.35
		draw_string(font, pos + Vector2(offset_x, offset_y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, static_fs, static_col)

	# 3. 绘制动态交互文字 (locked / open)
	var clause_fs := 24
	var clause_col := Color(0.8, 0.53, 0.26) # 金色，提示可交互
	for id in RoomData.clauses:
		var c: Dictionary = RoomData.clauses[id]
		var pos = RoomData.ORIGIN + Vector2(c["cell"]) * t
		var text = c["value"]
		var text_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, clause_fs)
		var offset_x = (t - text_size.x) / 2.0
		var offset_y = t / 2.0 + clause_fs * 0.35
		draw_string(font, pos + Vector2(offset_x, offset_y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, clause_fs, clause_col)

	# 4. 绘制物理门 (用 door 单词密排)
	var door_fs := 28
	var door_col := Color(0.55, 0.35, 0.15) # 木门棕色
	for id in RoomData.doors:
		var d: Dictionary = RoomData.doors[id]
		for cell in d["cells"]:
			var pos = RoomData.ORIGIN + Vector2(cell) * t
			for row in range(2):
				var y = pos.y + (row * 32) + 26
				draw_string(font, Vector2(pos.x + 8, y), "door", HORIZONTAL_ALIGNMENT_LEFT, -1, door_fs, door_col)
