class_name Observer extends Gate


var result: bool
var gates: Array[OneGate] = []

var qubit: Qubit:
	get: return qubit_lines[0].qubit


static func get_gate_scene() -> PackedScene:
	return load("res://gates/Observer.tscn")


func _apply() -> void:
	result = qubit.observe()
	print(int(result))


func apply() -> void:
	super.apply()
	for gate: OneGate in gates:
		if gate.can_be_applied():
			gate.apply()


func has_observed() -> bool:
	return not qubit_lines[0].is_active


func _input(event: InputEvent) -> void:
	if click_inside(event) and editor.can_edit():
		editor.linking_wire = true
		editor.placable = self
		print("linking : ", self)
	
	super._input(event)