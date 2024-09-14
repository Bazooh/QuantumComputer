class_name Computer extends Node2D


@export var qubit_lines: Node2D
@export var gates: Node2D


func get_first_non_waiting_qubit_line(lines: Array) -> QubitLine:
	for qubit_line: QubitLine in lines:
		if not qubit_line.is_waiting:
			return qubit_line
	return null


func compute() -> void:
	print("Computing")

	var active_qubit_lines: Array = qubit_lines.get_children()

	while not active_qubit_lines.is_empty():
		var qubit_line: QubitLine = get_first_non_waiting_qubit_line(active_qubit_lines)

		assert(qubit_line != null, "All qubits are waiting")
		
		qubit_line.active_next_gate()
		if not qubit_line.is_active:
			active_qubit_lines.erase(qubit_line)
	
	for qubit_line: QubitLine in qubit_lines.get_children():
		qubit_line.current_gate_idx = 0
		qubit_line.is_active = true
		qubit_line.is_waiting = false
		qubit_line.qubit = Qubit.from_type(qubit_line.type)
