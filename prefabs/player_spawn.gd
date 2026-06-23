@tool
extends Node2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	var cell = Vector2i(((global_position - RoomData.ORIGIN) / float(RoomData.TILE)).round())
	global_position = RoomData.ORIGIN + Vector2(cell) * float(RoomData.TILE)
	RoomData.set_player_start(cell)

func _draw() -> void:
	if Engine.is_editor_hint():
		var font = ThemeDB.fallback_font
		var fs = 24
		var col = Color(0.9, 0.8, 0.3, 0.5) # 半透明金色
		var t = 64
		var text = "Spawn"
		var text_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
		var offset_x = (t - text_size.x) / 2.0
		var offset_y = t / 2.0 + fs * 0.35
		draw_string(font, Vector2(offset_x, offset_y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
