class_name Complex

static var ZERO := Complex.new(0, 0)
static var ONE := Complex.new(1, 0)
static var i := Complex.new(0, 1)


var re: float
var im: float


func _init(re_: float, im_: float) -> void:
	re = re_
	im = im_


func length_squared() -> float:
	return re * re + im * im


func length() -> float:
	return sqrt(length_squared())


func add(other: Complex) -> Complex:
	return Complex.new(re + other.re, im + other.im)


func add_(other: Complex) -> void:
	re += other.re
	im += other.im


func sub(other: Complex) -> Complex:
	return Complex.new(re - other.re, im - other.im)


func sub_(other: Complex) -> void:
	re -= other.re
	im -= other.im


func multiply(other: Complex) -> Complex:
	return Complex.new(re * other.re - im * other.im, re * other.im + im * other.re)


func multiply_(other: Complex) -> void:
	var new_re = re * other.re - im * other.im
	var new_im = re * other.im + im * other.re
	re = new_re
	im = new_im


func multiply_scalar(scalar: float) -> Complex:
	return Complex.new(re * scalar, im * scalar)


func multiply_scalar_(scalar: float) -> void:
	re *= scalar
	im *= scalar


func divide(other: Complex) -> Complex:
	var denominator = other.re * other.re + other.im * other.im
	return Complex.new((re * other.re + im * other.im) / denominator, (im * other.re - re * other.im) / denominator)


func divide_(other: Complex) -> void:
	var denominator = other.re * other.re + other.im * other.im
	var new_re = (re * other.re + im * other.im) / denominator
	var new_im = (im * other.re - re * other.im) / denominator
	re = new_re
	im = new_im


func conjugate() -> Complex:
	return Complex.new(re, -im)


func conjugate_() -> void:
	im = -im


func divide_scalar(scalar: float) -> Complex:
	return Complex.new(re / scalar, im / scalar)


func divide_scalar_(scalar: float) -> void:
	re /= scalar
	im /= scalar


func copy() -> Complex:
	return Complex.new(re, im)


func equals(other: Complex) -> bool:
	return re == other.re and im == other.im


func is_zero() -> bool:
	return re == 0 and im == 0


func is_zero_approx() -> bool:
	return is_zero_approx(re) and is_zero_approx(im)


func is_equal_approx(other: Complex) -> bool:
	return is_equal_approx(re, other.re) and is_equal_approx(im, other.im)


static func new_random(length_: float = -1.0) -> Complex:
	if length_ < 0:
		length_ = randf()
	
	var angle: float = TAU * randf()

	return Complex.new(length_* cos(angle), length_ * sin(angle))


func _to_string() -> String:
	var im_: float = roundf(im * 100.0) / 100.0
	var re_: float = roundf(re * 100.0) / 100.0

	if im == 0:
		return str(re_)
	
	if re == 0:
		return str(im_) + "i"
	
	if im_ < 0:
		return str(re_) + " - " + str(-im_) + "i"

	return str(re_) + " + " + str(im_) + "i"