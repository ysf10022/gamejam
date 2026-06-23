@tool
extends Node2D

@export var door_id: String = "door1"
@export var clause_id: String = "door1_status"
@export var open_value: String = "open"
@export var sprite: Texture2D:
	set(v):
		sprite = v
		queue_redraw()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	var cell = Vector2i(((global_position - RoomData.ORIGIN) / float(RoomData.TILE)).round())
	global_position = RoomData.ORIGIN + Vector2(cell) * float(RoomData.TILE)
	
	if RoomData.doors.has(door_id):
		RoomData.doors[door_id]["cells"].append(cell)
	else:
		RoomData.register_door(door_id, [cell], clause_id, open_value)
		
	GameState.phase_changed.connect(func(_p): queue_redraw())
	RoomData.clause_changed.connect(func(id):
		if id == clause_id:
			queue_redraw()
	)

func _draw() -> void:
	var t = 64
	
	var is_day = true
	if not Engine.is_editor_hint():
		if GameState.phase == GameState.Phase.NIGHT:
			is_day = false
			
	if is_day:
		# 昼间：显示文字
		var font = ThemeDB.fallback_font
		var fs = 28
		var col = Color(0.55, 0.35, 0.15)
		for row in range(2):
			var y = (row * 32) + 26
			draw_string(font, Vector2(8, y), "door", HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
	else:
		# 夜间：显示实体
		var is_open = false
		if RoomData.clauses.has(clause_id) and RoomData.clauses[clause_id]["value"] == open_value:
			is_open = true
			
		if not is_open:
			if sprite != null:
				draw_texture_rect(sprite, Rect2(0, 0, t, t), false)
			else:
				draw_rect(Rect2(0, 0, t, t), Color(0.4, 0.2, 0.2))
