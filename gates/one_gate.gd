class_name OneGate extends Gate


var qubit: Qubit:
	get: return qubit_lines[0].qubit

var condition: Observer


func _on_each_qubit(_state: State, _idx1: int, _idx2: int) -> void:
	pass


func can_be_applied() -> bool:
	return super.can_be_applied() and (condition == null or condition.has_observed())


func unplace(pos: Vector2i) -> void:
	if condition != null:
		condition.gates.erase(self)
	
	super.unplace(pos)


func _apply() -> void:
	if condition != null and not condition.result:
		return

	@warning_ignore("integer_division")
	for i in range(1 << (qubit.state.qubits.size() - 1 - qubit.idx)):
		for j in range(1 << qubit.idx):
			var idx1: int = i * (1 << (qubit.idx + 1)) + j
			var idx2: int = idx1 + (1 << qubit.idx)
			
			_on_each_qubit(qubit.state, idx1, idx2)


func _input(event: InputEvent) -> void:
	if click_inside(event) and editor.linking_wire:
		condition = editor.placable
		editor.placable.gates.append(self)
		editor.placable = null
		editor.linking_wire = false

		print("connecting : ", self, " to ", condition)
	
	super._input(event)
