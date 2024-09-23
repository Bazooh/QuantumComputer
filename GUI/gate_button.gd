class_name GateButton extends Button


@export var gate_script: Script
@export var gate_name: String

@export var editor: Editor


var create_gate := func() -> Gate:
	return gate_script.get_gate_scene().instantiate()


func _on_pressed() -> void:
	if not editor.can_edit():
		return

	var gate: Gate = create_gate.call()
	editor.computer.gates_scene.add_child(gate)
	gate.owner = editor.computer
	gate.init_ghost(editor, get_viewport().get_mouse_position())
	editor.placing_placable = true
	editor.placable = gate
