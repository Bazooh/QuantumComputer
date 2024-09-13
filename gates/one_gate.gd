class_name OneGate extends Gate


var qubit: Qubit:
    get: return qubit_lines[0].qubit


func _on_each_qubit(_state: State, _idx1: int, _idx2: int) -> void:
    pass


func _apply() -> void:
    @warning_ignore("integer_division")
    for i in range(1 << (qubit.state.qubits.size() - 1 - qubit.idx)):
        for j in range(1 << qubit.idx):
            var idx1: int = i * (1 << (qubit.idx + 1)) + j
            var idx2: int = idx1 + (1 << qubit.idx)
            
            _on_each_qubit(qubit.state, idx1, idx2)