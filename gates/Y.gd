class_name Y extends OneGate


static func get_gate_scene() -> PackedScene:
	return load("res://nodes/Y.tscn")


func _on_each_qubit(state: State, idx1: int, idx2: int) -> void:
	var alpha: Complex = state.amplitudes.tensor[idx1]
	var beta: Complex = state.amplitudes.tensor[idx2]
	
	state.amplitudes.tensor[idx1] = beta.multiply(Complex.new(0, -1))
	state.amplitudes.tensor[idx2] = alpha.multiply(Complex.new(0, 1))