extends Control

func _ready() -> void:
	RoomData.clause_changed.connect(func(_id): queue_redraw())
	queue_redraw()

func _draw() -> void:
	var font: Font = ThemeDB.fallback_font
	var t: float = float(RoomData.TILE)



	# 2. 绘制地形文字
	var fs := 28
	
	_draw_terrain(RoomData.wall_cells + RoomData.walls, "wall", Color(0.8, 0.8, 0.8), font, t, fs)
	_draw_terrain(RoomData.fire_cells, "fire", Color(0.9, 0.3, 0.3), font, t, fs)
	_draw_terrain(RoomData.water_cells, "water", Color(0.3, 0.5, 0.9), font, t, fs)
	_draw_terrain(RoomData.grass_cells, "grass", Color(0.3, 0.8, 0.4), font, t, fs)

func _draw_terrain(cells: Array, text: String, color: Color, font: Font, t: float, fs: int) -> void:
	for cell in cells:
		var pos = RoomData.ORIGIN + Vector2(cell) * t
		for row in range(2):
			var y = pos.y + (row * 32) + 26
			draw_string(font, Vector2(pos.x + 8, y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, color)
