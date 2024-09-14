class_name GateButton extends Button


@export var gate: Script
@onready var editor: Editor = owner


func _on_pressed() -> void:
	if not editor.can_edit():
		return

	var gate_instance: Gate = gate.get_gate_scene().instantiate()
	editor.computer.gates.add_child(gate_instance)
	gate_instance.init_ghost(editor, get_viewport().get_mouse_position())
	editor.placing_placable = true
	editor.placable = gate_instance
