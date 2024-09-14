class_name Information extends OneGate


@export var alpha: Label
@export var beta: Label


static func get_gate_scene() -> PackedScene:
	return load("res://gates/Information.tscn")


func _apply() -> void:
	if qubit.state.amplitudes.size() > 2:
		alpha.text = "..."
		beta.text = "..."
		return
	
	alpha.text = qubit.state.amplitudes[0].to_string()
	beta.text = qubit.state.amplitudes[1].to_string()