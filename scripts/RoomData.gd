extends Node

const TILE := 64
const ORIGIN := Vector2(320, 156)

signal clause_changed(id: String)

var grid_width: int = 20
var grid_height: int = 12
var wall_cells: Array[Vector2i] = []
var clauses: Dictionary = {}
var static_words: Array[Dictionary] = []
var doors: Dictionary = {}
var walls: Array[Vector2i] = []
var player_start: Vector2i = Vector2i.ZERO
var exit_cell: Vector2i = Vector2i.ZERO

func _ready() -> void:
	load_room()
	GameState.player_cell = player_start

func load_room() -> void:
	static_words = [
		{"cell": Vector2i(3, 6), "word": "the"},
		{"cell": Vector2i(4, 6), "word": "door"},
		{"cell": Vector2i(5, 6), "word": "is"}
	]
	
	clauses = {
		"door1_status": {
			"value": "locked",
			"options": ["locked", "open"],
			"cell": Vector2i(6, 6),
		}
	}
	
	doors = {
		"center_door": {
			"cells": [Vector2i(11, 6), Vector2i(12, 6)],
			"clause_id": "door1_status",
			"open_value": "open"
		}
	}
	
	# 构建两堵拦路的墙，除了 y=6 之外全堵死
	walls.clear()
	for y in range(grid_height):
		if y != 6:
			walls.append(Vector2i(11, y))
			walls.append(Vector2i(12, y))
			
	player_start = Vector2i(2, 6)
	exit_cell = Vector2i(17, 6)
	_build_border()

func _build_border() -> void:
	wall_cells.clear()
	for x in range(grid_width):
		wall_cells.append(Vector2i(x, 0))
		wall_cells.append(Vector2i(x, 1))
		wall_cells.append(Vector2i(x, grid_height - 1))
		wall_cells.append(Vector2i(x, grid_height - 2))
	for y in range(grid_height):
		wall_cells.append(Vector2i(0, y))
		wall_cells.append(Vector2i(1, y))
		wall_cells.append(Vector2i(grid_width - 1, y))
		wall_cells.append(Vector2i(grid_width - 2, y))
	
	
func sync_with_tilemap(tm: Node) -> void:
	if not tm.has_method("get_used_cells"):
		return
	var used: Array[Vector2i] = tm.get_used_cells()
	if used.size() > 0:
		wall_cells.clear()
		walls.clear()
		for cell in used:
			walls.append(cell)

func get_clause(id: String) -> Dictionary:
	return clauses.get(id, {})
	
func get_clause_id_near(cell: Vector2i) -> String:
	for id in clauses:
		var c = clauses[id]
		var d: Vector2i = c["cell"] - cell
		if abs(d.x) + abs(d.y) <= 1:   # 仅限贴脸（上下左右相邻）才可修改
			return id
	return ""

func cycle_field(id: String) -> void:
	if not clauses.has(id):
		return
	var c: Dictionary = clauses[id]
	var opts: Array = c["options"]
	var i: int = opts.find(c["value"])
	set_field(id, opts[(i + 1) % opts.size()])

func set_field(id: String, value: String) -> void:
	if not clauses.has(id):
		return
	var c: Dictionary = clauses[id]
	if value in c["options"]:
		c["value"] = value
		clause_changed.emit(id)

func is_blocked(cell: Vector2i) -> bool:
	if cell in wall_cells or cell in walls:
		return true
		
	# 任何文字都是物理障碍 (如同 Baba Is You)
	for w in static_words:
		if w["cell"] == cell:
			return true
	for id in clauses:
		var c = clauses[id]
		if c["cell"] == cell:
			return true
			
	# 门逻辑判断
	for id in doors:
		var d = doors[id]
		if cell in d["cells"]:
			if GameState.phase == GameState.Phase.DAY:
				return true # 白天总是关着的物理实体
			elif GameState.phase == GameState.Phase.NIGHT:
				var cid = d["clause_id"]
				if clauses.has(cid) and clauses[cid]["value"] != d["open_value"]:
					return true # 黑夜中，若对应文字法则未满足，则仍是死路
	return false
