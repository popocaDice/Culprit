extends ProgressBar

var prev_value: float
var fade: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (value == prev_value and not fade): 
		$BarAnim.play("fade_out")
		fade = true
	elif (value != prev_value and fade): 
		fade = false
		$BarAnim.play("fade_in")
	prev_value = value

func setValue(target):
	value = lerp(value, target, max_value/20)
