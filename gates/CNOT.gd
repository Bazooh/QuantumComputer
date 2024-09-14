class_name CNOT extends Gate


const extension_node: PackedScene = preload("res://gates/CNOT_extension.tscn")
const control_node: PackedScene = preload("res://gates/CNOT_control.tscn")


var target: Qubit:
	get: return qubit_lines[0].qubit
var control: Qubit:
	get: return qubit_lines[1].qubit


var conditions: Array[Dictionary] = [{"height": -1, "inverted": false}] # {height: int = 0, inverted: bool = false}


static func get_gate_scene() -> PackedScene:
	return load("res://gates/CNOT.tscn")


func _apply() -> void:
	var state: State = control.state.merge(target.state)

	for i in range(1 << (state.qubits.size() - 1 - control.idx)):
		for j in range(1 << control.idx):
			var idx1: int = i * (1 << (control.idx + 1)) + (1 << control.idx) + j
			if idx1 & (1 << target.idx) == 0:
				var idx2: int = idx1 + (1 << target.idx)
				var alpha: Complex = state.amplitudes[idx1]
				var beta: Complex = state.amplitudes[idx2]

				state.amplitudes[idx1] = beta
				state.amplitudes[idx2] = alpha
	
	# TODO: Separate the qubits again (if possible) to save computation


func can_be_placed(pos: Vector2i) -> bool:
	return super.can_be_placed(pos) and conditions.all(func(c: Dictionary): return super.can_be_placed(pos + Vector2i(0, c.height)))


func place_on_grid(pos: Vector2i) -> void:
	super.place_on_grid(pos)
	for c in conditions:
		super.place_on_grid(pos + Vector2i(0, c.height))


func update() -> void:
	for child: Node2D in sprite.get_children():
		child.queue_free()

	var heights: Array = conditions.map(func(c: Dictionary): return c.height) + [0]
	var height_min: int = heights.min()
	var height_max: int = heights.max()

	for i in range(height_min, height_max + 1):
		if i == 0:
			continue

		if i in heights:
			var control_sprite: Sprite2D = control_node.instantiate()
			sprite.add_child(control_sprite)

			control_sprite.position.y = -50*sign(i) + 300*i
			control_sprite.scale.y = -sign(i)
		
		if i == height_max or i == height_min:
			continue

		var extension_sprite: Sprite2D = extension_node.instantiate()
		sprite.add_child(extension_sprite)

		extension_sprite.position.y = -39*sign(i) + 300*i
		extension_sprite.scale.y = -sign(i)


func _input(event: InputEvent) -> void:
	super._input(event)

	if not ghost:
		return

	if event.is_action_pressed("add_condition"):
		conditions.append({"height": conditions.map(func(c: Dictionary): return c.height).min() - 1, "inverted": false})
		update()
	elif event.is_action_pressed("remove_condition"):
		conditions.remove_at(List.argmin(conditions, func(c: Dictionary): return c.height))
		update()