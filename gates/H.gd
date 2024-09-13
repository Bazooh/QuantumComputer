class_name H extends OneGate


const INV_SQRT2 := 1 / sqrt(2)


func _on_each_qubit(state: State, idx1: int, idx2: int) -> void:
    var alpha: Complex = state.amplitudes[idx1]
    var beta: Complex = state.amplitudes[idx2]
    
    state.amplitudes[idx1] = alpha.add(beta).multiply_scalar(INV_SQRT2)
    state.amplitudes[idx2] = alpha.sub(beta).multiply_scalar(INV_SQRT2)