class_name State


var qubits: Array[Qubit] = []
var amplitudes: Array[Complex] = []


func merge(other: State) -> State:
    if other == self:
        return self

    var new_state := State.new()

    for qubit: Qubit in other.qubits:
        qubit.idx += qubits.size()
    
    new_state.qubits = qubits + other.qubits

    for qubit: Qubit in new_state.qubits:
        qubit.state = new_state

    new_state.amplitudes = []
    for beta: Complex in other.amplitudes:
        for alpha: Complex in amplitudes:
            new_state.amplitudes.append(alpha.multiply(beta))
    
    return new_state


func get_probability(qubit: Qubit, state_idx: bool) -> float:
    var probability: float = 0
    # TODO: only iterate over the amplitudes that have the qubit in the state_idx
    for i in range(amplitudes.size()):
        if bool(i & (1 << qubit.idx)) == state_idx:
            probability += amplitudes[i].length_squared()
    return probability


func observe(qubit: Qubit) -> bool:
    var state_idx: bool = randf() > get_probability(qubit, 0)

    var new_amplitudes: Array[Complex] = []
    var amplitude_sum: float = 0
    # TODO: only iterate over the amplitudes that have the qubit in the state_idx
    for i in range(amplitudes.size()):
        if bool(i & (1 << qubit.idx)) == state_idx:
            new_amplitudes.append(amplitudes[i])
            amplitude_sum += amplitudes[i].length_squared()
    
    var inv_amplidtude: float = 1 / sqrt(amplitude_sum)
    for i in range(new_amplitudes.size()):
        new_amplitudes[i].multiply_scalar_(inv_amplidtude)
    
    amplitudes = new_amplitudes

    for other_qubit: Qubit in qubits.slice(qubit.idx + 1):
        other_qubit.idx -= 1
    qubits.remove_at(qubit.idx)

    return state_idx


func _to_string() -> String:
    var string := "["
    for amplitude: Complex in amplitudes:
        string += str(amplitude) + ", "
    return string.rstrip(", ") + "]"