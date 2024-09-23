class_name Editor extends Node2D


const choose_file_name_scene: PackedScene = preload("res://GUI/choose_file_name.tscn")
const gate_button_scene: PackedScene = preload("res://GUI/gate_button.tscn")

@export var computer: Computer


var placable: Placable
var linking_wire := false
var placing_placable := false


func can_edit() -> bool:
	return (not linking_wire) and (not placing_placable)


func _ready() -> void:
	for file: String in DirAccess.get_files_at("res://components"):
		var gate_button: GateButton = gate_button_scene.instantiate()

		gate_button.gate_name = file
		gate_button.create_gate = Component.create_from_computer.bind(load("res://components/" + file))
		gate_button.editor = self

		%Gates.add_child(gate_button)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("compute"):
		computer.reset()
		computer.compute()
	
	if event.is_action_pressed("save"):
		var choose_file_name: Control = choose_file_name_scene.instantiate()
		add_child(choose_file_name)
		choose_file_name.get_node("%Confirm").pressed.connect(func(): computer.save(choose_file_name.get_node("%FileName").text); choose_file_name.queue_free())
		choose_file_name.get_node("%Cancel").pressed.connect(func(): choose_file_name.queue_free())
