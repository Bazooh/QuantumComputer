class_name State


var qubits: Array[Qubit] = []
var amplitudes := Tensor.new()


func merge(other: State) -> State:
    if other == self:
        return self

    var new_state := State.new()

    for qubit: Qubit in other.qubits:
        qubit.idx += qubits.size()
    
    new_state.qubits = qubits + other.qubits

    for qubit: Qubit in new_state.qubits:
        qubit.state = new_state

    for beta: Complex in other.amplitudes:
        for alpha: Complex in amplitudes:
            new_state.amplitudes.append(alpha.multiply(beta))
    
    return new_state


func split_following(start: int, count: int) -> void:
    if count == 0 or count == qubits.size():
        return
    
    var result: Array[Tensor] = []
    var result_qubits: Array[Array] = []

    if start == 0:
        result = amplitudes.decompose(count, qubits.size() - count)
        result_qubits = [range(count), range(count, qubits.size())]
    elif start + count == qubits.size():
        result = amplitudes.decompose(start, count)
        result_qubits = [range(start), range(start, qubits.size())]
    else:
        amplitudes.reorganize([start, count, qubits.size() - start - count], [0, 1, 2], [1, 0, 2])
        result = amplitudes.decompose(count, qubits.size() - count)
        result_qubits = [range(start), range(count), range(qubits.size() - start - count)]

    for i in result.size():
        var state := State.new()
        state.amplitudes = result[i]
        for qubit_idx: int in result_qubits[i]:
            var qubit: Qubit = qubits[qubit_idx]
            qubit.idx = qubit_idx
            qubit.state = state
            state.qubits.append(qubit)
        
        if i == result.size() - 1:
            qubits = state.qubits
            amplitudes = state.amplitudes


func get_sequence(idxs: Array[int]) -> Array[int]:
    assert(not idxs.is_empty(), "The idxs array must not be empty")

    for i in idxs.size() - 1:
        if idxs[i + 1] != idxs[i] + 1:
            return [idxs[0], i + 1]
    
    return [idxs[0], idxs.size()]


func split(idxs: Array[int]) -> void:
    while not idxs.is_empty():
        var sequence: Array[int] = get_sequence(idxs)
        split_following(sequence[0], sequence[1])
        idxs = idxs.slice(sequence[1]).map(func(idx: int): return idx - sequence[0] - sequence[1])


func get_probability(qubit: Qubit, state_idx: bool) -> float:
    var probability: float = 0
    # TODO: only iterate over the amplitudes that have the qubit in the state_idx
    for i in range(amplitudes.size()):
        if bool(i & (1 << qubit.idx)) == state_idx:
            probability += amplitudes.tensor[i].length_squared()
    return probability


func observe(qubit: Qubit) -> bool:
    var state_idx: bool = randf() > get_probability(qubit, 0)

    var new_amplitudes := Tensor.new()
    var amplitude_sum: float = 0
    # TODO: only iterate over the amplitudes that have the qubit in the state_idx
    for i in range(amplitudes.size()):
        if bool(i & (1 << qubit.idx)) == state_idx:
            new_amplitudes.append(amplitudes.tensor[i])
            amplitude_sum += amplitudes.tensor[i].length_squared()
    
    var inv_amplidtude: float = 1 / sqrt(amplitude_sum)
    for i in range(new_amplitudes.size()):
        new_amplitudes.tensor[i].multiply_scalar_(inv_amplidtude)
    
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