@tool
extends Node2D

@export var word: String = "word":
	set(v):
		word = v
		queue_redraw()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	# Convert global position to grid cell (assuming origin offset applies, wait.
    # In main.tscn, RoomData.ORIGIN was Vector2(320, 156).
    # If Level_01 is placed at (0,0), then we need to subtract ORIGIN or position the map at ORIGIN.
    # Let's assume the level starts at ORIGIN. So cell = (global_position - ORIGIN) / TILE.
	var cell = Vector2i(((global_position - RoomData.ORIGIN) / float(RoomData.TILE)).round())
	global_position = RoomData.ORIGIN + Vector2(cell) * float(RoomData.TILE)
	RoomData.register_static_word(cell, word)
	
	GameState.phase_changed.connect(func(_p): queue_redraw())

func _draw() -> void:
	if not Engine.is_editor_hint():
		if GameState.phase == GameState.Phase.NIGHT:
			return
		
	var font = ThemeDB.fallback_font
	var fs = 24
	var col = Color(0.8, 0.8, 0.8)
	var t = 64 # RoomData.TILE
	
	var text_size = font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
	var offset_x = (t - text_size.x) / 2.0
	var offset_y = t / 2.0 + fs * 0.35
	
	draw_string(font, Vector2(offset_x, offset_y), word, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
