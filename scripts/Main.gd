extends Node2D

@onready var day_view: CanvasItem = $DayView
@onready var night_view: CanvasItem = $NightView

@export var level_scene: PackedScene

func _ready() -> void:
	RoomData.clear_room()
	
	# 动态加载关卡 (如果有配置，则加载配置好的；否则默认加载 Level_01)
	if level_scene == null:
		level_scene = load("res://scenes/Level_01.tscn")
		
	if level_scene:
		var level = level_scene.instantiate()
		add_child(level)
		# 将其移动到最底层，在 View 之下
		move_child(level, 0)
		
		# 给节点一点时间 _ready() 并注册自己
		await get_tree().process_frame
		
		var tm = level.get_node_or_null("WallsMap")
		if tm != null:
			RoomData.sync_with_tilemap(tm)
			tm.visible = false # 默认白天隐藏，由代码画 wall 单词
			day_view.queue_redraw()
			night_view.queue_redraw()
			
		# 更新玩家的初始位置（等待 PlayerSpawn 注册完成）
		var player = $Player
		if player:
			GameState.player_cell = RoomData.player_start
			player._snap(RoomData.player_start)
			
	GameState.phase_changed.connect(_on_phase)
	GameState.win_event.connect(func(): queue_redraw())
	_apply_phase(GameState.phase)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):   # 空格/回车切昼夜
		GameState.toggle_phase()

func _on_phase(p: GameState.Phase) -> void:
	_apply_phase(p)

func _apply_phase(p: GameState.Phase) -> void:
	if p == GameState.Phase.DAY:
		day_view.visible = true
		night_view.visible = false
	else:
		day_view.visible = false
		night_view.visible = true
		
	# 切换 TileMap 的可见性（如果存在）
	var level = get_child(0)
	if level:
		var tm = level.get_node_or_null("WallsMap")
		if tm != null:
			tm.visible = (p == GameState.Phase.NIGHT)
			
	queue_redraw()

func _draw() -> void:
	var font = ThemeDB.fallback_font
	var fs = 24
	var text = ""
	var col = Color.WHITE
	
	if GameState.is_win:
		text = "YOU WIN!"
		col = Color(0.9, 0.8, 0.2)
		fs = 48
	elif GameState.phase == GameState.Phase.DAY:
		text = "Press E to interact text.  Press SPACE to switch time."
		col = Color(0.8, 0.8, 0.8)
	else:
		text = "Press SPACE to switch time."
		col = Color(0.5, 0.5, 0.7)
		
	var size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
	var pos = Vector2(1920 / 2.0 - size.x / 2.0, 80)
	draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
