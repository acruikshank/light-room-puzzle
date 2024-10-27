extends Node3D

const flip_probability = 0.002
const on_color = Vector3(.8, .5, .1)
const off_color = Vector3(0.001,0,0)

var buttons = []
var on_button = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  buttons.append($Button1)
  buttons.append($Button3)
  buttons.append($Button4)
  buttons.append($Button2)
  buttons[on_button].illuminate(on_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if (randf() < flip_probability):
    buttons[on_button].illuminate(off_color)
    on_button = (on_button + 1) % 4
    buttons[on_button].illuminate(on_color)
