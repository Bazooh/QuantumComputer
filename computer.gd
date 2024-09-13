class_name Computer extends Node


@export var qubit_lines: Array[QubitLine]


func get_first_non_waiting_qubit_line(lines: Array[QubitLine]) -> QubitLine:
    for qubit_line in lines:
        if not qubit_line.is_waiting:
            return qubit_line
    return null


func compute() -> void:
    var active_qubit_lines: Array[QubitLine] = qubit_lines.duplicate()

    while not active_qubit_lines.is_empty():
        var qubit_line: QubitLine = get_first_non_waiting_qubit_line(active_qubit_lines)

        assert(qubit_line != null, "All qubits are waiting")
        
        qubit_line.active_next_gate()
        if not qubit_line.is_active:
            active_qubit_lines.erase(qubit_line)


func _ready() -> void:
    print(qubit_lines[0].qubit.state)
    print(qubit_lines[1].qubit.state)
    compute()
    print(qubit_lines[0].qubit.state)
    print(qubit_lines[1].qubit.state)