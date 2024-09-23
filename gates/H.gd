class_name H extends OneGate


const INV_SQRT2 := 1 / sqrt(2)


static func get_gate_scene() -> PackedScene:
	return load("res://nodes/H.tscn")


func _on_each_qubit(state: State, idx1: int, idx2: int) -> void:
	var alpha: Complex = state.amplitudes.tensor[idx1]
	var beta: Complex = state.amplitudes.tensor[idx2]
	
	state.amplitudes.tensor[idx1] = alpha.add(beta).multiply_scalar(INV_SQRT2)
	state.amplitudes.tensor[idx2] = alpha.sub(beta).multiply_scalar(INV_SQRT2)