class_name CNOT extends Gate


const extension_node: PackedScene = preload("res://nodes/CNOT Extensions/CNOT_extension.tscn")
const control_node: PackedScene = preload("res://nodes/CNOT Extensions/CNOT_control.tscn")


var target: Qubit:
	get: return qubit_lines[0].qubit
var control: Qubit:
	get: return qubit_lines[1].qubit


@export var conditions: Array[Dictionary] = [{"height": -1, "inverted": false, "line_idx": 1}] # {height: int = 0, inverted: bool = false, idx: int = 1}


func _ready() -> void:
	update()


static func get_gate_scene() -> PackedScene:
	return load("res://nodes/CNOT.tscn")


func separate_conditions_state() -> void:
	var states_used := {}
	for condition: Dictionary in conditions:
		var qubit: Qubit = qubit_lines[condition.line_idx].qubit
		states_used.get_or_add(qubit.state, []).append(qubit.idx)

	for state: State in states_used:
		state.split(states_used[state])


func merge_conditions_state() -> State:
	var state: State = target.state
	for condition: Dictionary in conditions:
		state = state.merge(qubit_lines[condition.line_idx].qubit.state)
	
	return state


func _apply() -> void:
	# separate_conditions_state()
	var state: State = merge_conditions_state()

	var unused_qubits_idx_dict := {}
	for i in range(state.qubits.size()):
		unused_qubits_idx_dict[i] = true
	for condition: Dictionary in conditions:
		unused_qubits_idx_dict.erase(qubit_lines[condition.line_idx].qubit.idx)
	unused_qubits_idx_dict.erase(target.idx)
	
	var idx: int = 0
	for condition: Dictionary in conditions:
		idx |= int(not condition.inverted) << qubit_lines[condition.line_idx].qubit.idx
	
	var unused_qubits_idx: Array = unused_qubits_idx_dict.keys()
	for i in range(1 << unused_qubits_idx.size()):
		var idx1: int = idx
		for j in range(unused_qubits_idx.size()):
			idx1 |= int(bool((i & (1 << j)))) << unused_qubits_idx[j]
		var idx2: int = idx1 | (1 << target.idx)

		var alpha: Complex = state.amplitudes.tensor[idx1]
		var beta: Complex = state.amplitudes.tensor[idx2]

		state.amplitudes.tensor[idx1] = beta
		state.amplitudes.tensor[idx2] = alpha


func can_be_placed(pos: Vector2i) -> bool:
	return super.can_be_placed(pos) and conditions.all(func(c: Dictionary): return super.can_be_placed(pos + Vector2i(0, c.height)))


func place_on_grid(pos: Vector2i) -> void:
	super.place_on_grid(pos)
	for c in conditions:
		super.place_on_grid(pos + Vector2i(0, c.height))


func unplace(pos: Vector2i) -> void:
	super.unplace(pos)
	for c in conditions:
		super.unplace(pos + Vector2i(0, c.height))


func update() -> void:
	for child: Node2D in sprite.get_children():
		child.queue_free()

	var heights: Array = conditions.map(func(c: Dictionary): return c.height) + [0]
	var height_min: int = heights.min()
	var height_max: int = heights.max()

	for height in range(height_min, height_max + 1):
		if height == 0:
			continue

		var extension_sprite: Sprite2D = extension_node.instantiate()
		sprite.add_child(extension_sprite)

		extension_sprite.position.y = -85*sign(height) + 320*height
		extension_sprite.scale.y = -sign(height)

		if height in heights:
			var control_sprite: CNOTControl = control_node.instantiate()
			sprite.add_child(control_sprite)

			control_sprite.height = height
			control_sprite.owner = self
			control_sprite.position.y = -50*sign(height) + 320*height
			control_sprite.scale.y = -sign(height)
			control_sprite.update_texture()


func default_int(value: Variant, default: int = 0) -> int:
	return value if value is int else default


func _input(event: InputEvent) -> void:
	super._input(event)

	if not ghost:
		return

	if event.is_action_pressed("add_condition_back"):
		conditions.append({"height": max(0, default_int(conditions.map(func(c: Dictionary): return c.height).max())) + 1, "inverted": false, "line_idx": conditions.size() + 1})
		update()
	elif event.is_action_pressed("add_condition"):
		conditions.append({"height": min(0, default_int(conditions.map(func(c: Dictionary): return c.height).min())) - 1, "inverted": false, "line_idx": conditions.size() + 1})
		update()
	elif event.is_action_pressed("remove_condition"):
		conditions.remove_at(List.argmin(conditions, func(c: Dictionary): return c.height))
		update()
