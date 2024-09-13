class_name CNOT extends Gate


var qubit1: Qubit:
	get: return qubit_lines[0].qubit
var qubit2: Qubit:
	get: return qubit_lines[1].qubit


func _apply() -> void:
	var state: State = qubit1.state.merge(qubit2.state)

	for i in range(1 << (state.qubits.size() - 1 - qubit1.idx)):
		for j in range(1 << qubit1.idx):
			var idx1: int = i * (1 << (qubit1.idx + 1)) + (1 << qubit1.idx) + j
			if idx1 & (1 << qubit2.idx) == 0:
				var idx2: int = idx1 + (1 << qubit2.idx)
				var alpha: Complex = state.amplitudes[idx1]
				var beta: Complex = state.amplitudes[idx2]

				state.amplitudes[idx1] = beta
				state.amplitudes[idx2] = alpha
	
	# TODO: Separate the qubits again (if possible) to save computation
