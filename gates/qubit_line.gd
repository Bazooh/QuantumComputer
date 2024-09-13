class_name QubitLine extends Node2D


@export var type: Qubit.Type
var qubit: Qubit

@export var gates: Array[Gate]
var current_gate_idx: int = 0

var is_waiting: bool = false
var is_active: bool = true


func _ready() -> void:
    qubit = Qubit.from_type(type)


func get_waiting_gate() -> Gate:
    assert(is_active, "Trying to get waiting gate when qubit line is not active")

    if current_gate_idx >= gates.size():
        return null

    return gates[current_gate_idx]


static func is_waiting_on(qubit_line: QubitLine, gate: Gate) -> bool:
    return qubit_line.get_waiting_gate() == gate


func active_next_gate() -> void:
    assert(is_active, "Trying to activate next gate when qubit line is not active")

    if current_gate_idx >= gates.size():
        is_active = false
        return
    
    var gate: Gate = gates[current_gate_idx]

    if gate.qubit_lines.all(is_waiting_on.bind(gate)):
        gate.apply()
    else:
        is_waiting = true