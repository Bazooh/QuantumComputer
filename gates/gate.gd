class_name Gate extends Placable


@export var qubit_lines: Array[QubitLine]


static func get_gate_scene() -> PackedScene:
	assert(false, "get_gate_scene must be overridden")
	return load("res://gates/gate.tscn")


func _apply() -> void:
	pass


func apply() -> void:
	_apply()
	for qubit_line in qubit_lines:
		qubit_line.is_waiting = false
		qubit_line.current_gate_idx += 1


func is_waiting(qubit_line: QubitLine) -> bool:
	return qubit_line.get_waiting_gate() == self


func can_be_applied() -> bool:
	return qubit_lines.all(is_waiting)


func can_be_placed(pos: Vector2i) -> bool:
	if not editor.qubit_lines_pos.has(pos.y):
		return false
	
	if editor.qubit_lines_pos[pos.y] >= pos.x:
		return false

	return not editor.grid.has(pos)


func place_on_grid(pos: Vector2i) -> void:
	editor.grid[pos] = self

	var qubit_line: QubitLine = editor.get_qubit_line(pos.y)

	qubit_lines.append(qubit_line)
	var idx: int = qubit_line.gates.map(func(gate: Gate): return gate.grid_pos.x).bsearch(pos.x)
	qubit_line.gates.insert(idx, self)
