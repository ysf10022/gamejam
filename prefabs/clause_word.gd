@tool
extends Node2D

@export var clause_id: String = "door1_status"
@export var options: Array[String] = ["locked", "open"]:
	set(v):
		options = v
		if not current_value in options and options.size() > 0:
			current_value = options[0]
		queue_redraw()
		
@export var current_value: String = "locked":
	set(v):
		current_value = v
		queue_redraw()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	var cell = Vector2i(((global_position - RoomData.ORIGIN) / float(RoomData.TILE)).round())
	global_position = RoomData.ORIGIN + Vector2(cell) * float(RoomData.TILE)
	RoomData.register_clause(clause_id, cell, current_value, options)
	
	RoomData.clause_changed.connect(_on_clause_changed)
	GameState.phase_changed.connect(func(_p): queue_redraw())

func _on_clause_changed(id: String) -> void:
	if id == clause_id:
		if RoomData.clauses.has(id):
			current_value = RoomData.clauses[id]["value"]
			queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint():
		if GameState.phase == GameState.Phase.NIGHT:
			return
		
	var font = ThemeDB.fallback_font
	var fs = 24
	var col = Color(0.8, 0.53, 0.26) # 金色
	var t = 64
	
	var text_size = font.get_string_size(current_value, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
	var offset_x = (t - text_size.x) / 2.0
	var offset_y = t / 2.0 + fs * 0.35
	
	draw_string(font, Vector2(offset_x, offset_y), current_value, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
