class_name Z extends OneGate


func _on_each_qubit(state: State, idx1: int, idx2: int) -> void:
    var alpha: Complex = state.amplitudes[idx1]
    var beta: Complex = state.amplitudes[idx2]
    
    state.amplitudes[idx1] = alpha
    state.amplitudes[idx2] = beta.multiply_scalar(-1)