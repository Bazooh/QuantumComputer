class_name X extends OneGate


static func get_gate_scene() -> PackedScene:
	return load("res://gates/X.tscn")


func _on_each_qubit(state: State, idx1: int, idx2: int) -> void:
	var alpha: Complex = state.amplitudes[idx1]
	var beta: Complex = state.amplitudes[idx2]
	
	state.amplitudes[idx1] = beta
	state.amplitudes[idx2] = alpha
