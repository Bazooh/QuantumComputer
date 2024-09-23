class_name Tensor


var tensor: Array[Complex]

var _idx: int = 0


func _init(values: Array[Complex] = []) -> void:
	if values.size() > 0:
		tensor = values
	else:
		tensor = []


func size() -> int:
	return tensor.size()


func get_first_non_zero_coef() -> int:
	for i in size():
		if not tensor[i].is_zero_approx():
			return i
	return -1


static func verify_product(a_times_b: Tensor, a: Tensor, b: Tensor) -> bool:
	if a_times_b.size() != a.size() * b.size():
		return false
	
	for i in a.size():
		for j in b.size():
			if not a_times_b.tensor[i*b.size() + j].is_equal_approx(a.tensor[i].multiply(b.tensor[j])):
				return false
	return true


@warning_ignore("integer_division")
func decompose(n: int, m: int) -> Array[Tensor]:
	assert(size() == n*m << 2, "The tensor size is incorrect")

	var tensor_n := Tensor.new()
	var tensor_m := Tensor.new()

	var first_non_zero_coef: int = get_first_non_zero_coef()
	
	assert(first_non_zero_coef != -1, "The state is zero")

	var coef := Complex.new(1, 0).divide(tensor[first_non_zero_coef])

	for i in n:
		tensor_n.tensor.append(Complex.new(1, 0) if i == first_non_zero_coef / m else (tensor[i*m + (first_non_zero_coef % m)].multiply(coef)))
	
	for i in m:
		tensor_m.tensor.append(tensor[m*(first_non_zero_coef / m) + i])
	
	if not verify_product(self, tensor_n, tensor_m):
		print("The decomposition is incorrect")
		return []
	
	return [tensor_n, tensor_m]


static func swap_idxs(idxs_size: int, starting_idxs: Array[int], ending_idxs: Array[int] = []) -> Array:
	if ending_idxs.size() == 0:
		ending_idxs = range(starting_idxs.size())
	
	assert(starting_idxs.size() == ending_idxs.size(), "The starting and ending indexes must have the same size")
	
	var untouched_idxs: Array = range(idxs_size)
	for i in starting_idxs.size():
		untouched_idxs.remove_at(starting_idxs[i] - i)

	var untouched_idx: int = 0
	var new_idxs := []
	for i in idxs_size:
		var idx: int = ending_idxs.find(i)
		if idx >= 0:
			new_idxs.append(idx)
		else:
			new_idxs.append(untouched_idxs[untouched_idx])
			untouched_idx += 1
	
	return new_idxs


static func left_bit_shift(a: int, shift: int) -> int:
	if shift >= 0:
		return a << shift
	return a >> -shift


func reorganize(dims: Array[int], starting_idxs: Array[int], ending_idxs: Array[int] = []) -> Tensor:
	assert(dims.reduce(func(accum: int, x: int): return accum * x) << dims.size() == size(), "The tensor size is incorrect")
	
	var new_dims_idxs: Array = swap_idxs(dims.size(), starting_idxs, ending_idxs)

	var dims_sum: Array[int] = [0]
	for dim in dims:
		dims_sum.append(dim + dims_sum[-1])
	var new_dims_sum: Array[int] = [0]
	for dim_idx in new_dims_idxs:
		new_dims_sum.append(dims[dim_idx] + new_dims_sum[-1])
	
	var end_idxs: Array[int] = []
	end_idxs.resize(dims.size())
	for i in dims.size():
		end_idxs[new_dims_idxs[i]] = i
	
	var i_mask: Array[int] = []
	for i in dims.size():
		i_mask.append(((1 << dims[i]) - 1) << dims_sum[i])
	var i_bit_shift: Array[int] = []
	for i in dims.size():
		i_bit_shift.append(new_dims_sum[end_idxs[i]] - dims_sum[i])
	
	var new_tensor := Tensor.new()
	new_tensor.tensor.resize(size())
	for i in size():
		var idx: int = 0
		for j in dims.size():
			idx |= left_bit_shift(i_mask[j] & i, i_bit_shift[j])
		new_tensor.tensor[idx] = tensor[i]
	
	return new_tensor


func multiply(other: Tensor) -> Tensor:
	var result := Tensor.new()
	for i in size():
		for j in other.size():
			result.tensor.append(tensor[i].multiply(other.tensor[j]))
	return result


func equals(other: Tensor) -> bool:
	if size() != other.size():
		return false
	
	for i in size():
		if not tensor[i].is_equal_approx(other.tensor[i]):
			return false
	return true


func append(elem: Complex) -> void:
	tensor.append(elem)


func _to_string() -> String:
	return str(tensor)


func _iter_init(_arg) -> bool:
	_idx = 0
	return not tensor.is_empty()


func _iter_next(_arg) -> bool:
	_idx += 1
	return _idx < tensor.size()


func _iter_get(_arg) -> Variant:
	return tensor[_idx]