extends Node2D



func _ready() -> void:
	_snap(GameState.player_cell)


func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("interact"): #交互逻辑
		if GameState.phase == GameState.Phase.DAY:
			# 白天：修改文字法则
			var id: String = RoomData.get_clause_id_near(GameState.player_cell)
			if id != "":
				RoomData.cycle_field(id)
		elif GameState.phase == GameState.Phase.NIGHT:
			# 黑夜：与实体/怪物互动（待扩展）
			print("黑夜无法修改文字，这里将来写攻击怪物或开门的逻辑！")
		return

	var dir: Vector2i = Vector2i.ZERO
	if event.is_action_pressed("ui_up"): dir = Vector2i(0, -1) #移动逻辑
	elif event.is_action_pressed("ui_down"): dir = Vector2i(0, 1)
	elif event.is_action_pressed("ui_left"): dir = Vector2i(-1, 0)
	elif event.is_action_pressed("ui_right"): dir = Vector2i(1, 0)
	else: return
	var target: Vector2i = GameState.player_cell + dir
	if RoomData.is_blocked(target):
		return
	GameState.player_cell = target   # 坐标存全局 → 昼夜一致
	_snap(target)
	
	# 黑夜碰触胜利方块
	if target == RoomData.exit_cell and GameState.phase == GameState.Phase.NIGHT:
		GameState.set_win()


func _snap(cell: Vector2i) -> void:
	position = RoomData.ORIGIN + Vector2(cell) * RoomData.TILE
	queue_redraw()


func _draw() -> void:
	var t = float(RoomData.TILE)
	draw_rect(Rect2(Vector2.ZERO, Vector2(t, t)), Color(0.2, 0.2, 0.2)) # 背景暗色光标
	
	var font: Font = ThemeDB.fallback_font
	var fs := 28
	var col := Color(0.9, 0.8, 0.3)
	var text_size = font.get_string_size("you", HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
	var offset_x = (t - text_size.x) / 2.0
	var offset_y = t / 2.0 + fs * 0.35
	draw_string(font, Vector2(offset_x, offset_y), "you", HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
