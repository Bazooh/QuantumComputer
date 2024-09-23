class_name Z extends OneGate


static func get_gate_scene() -> PackedScene:
	return load("res://nodes/Z.tscn")


func _on_each_qubit(state: State, idx1: int, idx2: int) -> void:
	var alpha: Complex = state.amplitudes.tensor[idx1]
	var beta: Complex = state.amplitudes.tensor[idx2]
	
	state.amplitudes.tensor[idx1] = alpha
	state.amplitudes.tensor[idx2] = beta.multiply_scalar(-1)