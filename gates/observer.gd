class_name Observer extends Gate


var qubit: Qubit
var result: bool


func _apply() -> void:
    result = qubit.observe()