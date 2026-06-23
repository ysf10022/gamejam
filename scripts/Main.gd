extends Node2D

@onready var day_view: CanvasItem = $DayView
@onready var night_view: CanvasItem = $NightView

func _ready() -> void:
	if has_node("WallsMap"):
		var tm = $WallsMap
		if tm.has_method("get_used_cells") and tm.get_used_cells().size() > 0:
			RoomData.sync_with_tilemap(tm)
			
	GameState.phase_changed.connect(_on_phase)
	GameState.win_event.connect(func(): queue_redraw())
	_apply_phase(GameState.phase)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):   # 空格/回车切昼夜
		GameState.toggle_phase()

func _on_phase(p) -> void:
	_apply_phase(p)
	queue_redraw()

func _apply_phase(p) -> void:
	day_view.visible = (p == GameState.Phase.DAY)
	night_view.visible = (p == GameState.Phase.NIGHT)

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
