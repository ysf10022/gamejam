extends Node

const TILE = 64
const ORIGIN = Vector2(320, 156)

var walls: Array = []
var wall_cells: Array = []
var fire_cells: Array = []
var water_cells: Array = []
var grass_cells: Array = []
var static_words: Array = []
var clauses: Dictionary = {}
var doors: Dictionary = {}

var player_start: Vector2i = Vector2i(2, 6)
var exit_cell: Vector2i = Vector2i(17, 6)

signal clause_changed(id)

func _ready() -> void:
	pass

func clear_room() -> void:
	walls.clear()
	wall_cells.clear()
	fire_cells.clear()
	water_cells.clear()
	grass_cells.clear()
	static_words.clear()
	clauses.clear()
	doors.clear()

func register_static_word(cell: Vector2i, word: String) -> void:
	static_words.append({"cell": cell, "word": word})

func register_clause(id: String, cell: Vector2i, value: String, options: Array) -> void:
	clauses[id] = {"cell": cell, "value": value, "options": options}
	clause_changed.emit(id)

func register_door(id: String, cells: Array, clause_id: String, open_val: String) -> void:
	doors[id] = {
		"cells": cells,
		"clause_id": clause_id,
		"open_value": open_val
	}

func set_exit_cell(cell: Vector2i) -> void:
	exit_cell = cell

func set_player_start(cell: Vector2i) -> void:
	player_start = cell

func sync_with_tilemap(tm: TileMapLayer) -> void:
	wall_cells.clear()
	fire_cells.clear()
	water_cells.clear()
	grass_cells.clear()
	
	for cell in tm.get_used_cells():
		var src = tm.get_cell_source_id(cell)
		if src == 0: wall_cells.append(cell)
		elif src == 1: fire_cells.append(cell)
		elif src == 2: water_cells.append(cell)
		elif src == 3: grass_cells.append(cell)

func update_clause(id: String, value: String) -> void:
	if clauses.has(id):
		clauses[id]["value"] = value
		clause_changed.emit(id)

func cycle_field(id: String) -> void:
	if clauses.has(id):
		var c = clauses[id]
		var opts = c.get("options", [])
		if opts.size() > 0:
			var idx = opts.find(c["value"])
			idx = (idx + 1) % opts.size()
			c["value"] = opts[idx]
			clause_changed.emit(id)

func is_blocked(cell: Vector2i) -> bool:
	var is_solid_terrain = (cell in wall_cells) or (cell in fire_cells) or (cell in water_cells)
	if GameState.phase == GameState.Phase.DAY:
		if is_solid_terrain: return true
		for w in static_words:
			if w["cell"] == cell: return true
		for id in clauses:
			if clauses[id]["cell"] == cell: return true
		for id in doors:
			if cell in doors[id]["cells"]: return true
		return false
	else:
		if is_solid_terrain: return true
		for id in doors:
			var d = doors[id]
			var cid = d["clause_id"]
			var is_open = false
			if clauses.has(cid) and clauses[cid]["value"] == d["open_value"]:
				is_open = true
			if not is_open and cell in d["cells"]:
				return true
		return false

func get_clause_id_near(cell: Vector2i) -> String:
	for id in clauses:
		var c = clauses[id]
		var d: Vector2i = c["cell"] - cell
		if abs(d.x) + abs(d.y) <= 1:
			return id
	return ""
