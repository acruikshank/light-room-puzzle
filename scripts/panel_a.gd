extends Node3D

const flip_probability = 0.002
const on_color = Vector3(.8, .5, .1)
const off_color = Vector3(0.001,0,0)

var a_buttons = []
var a_buttons_on = false
var b_buttons = []
var b_buttons_on = false

func assign(button: Node3D) -> void:
  if (randf() >= .5):
    a_buttons.append(button)
  else:
    b_buttons.append(button)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  assign($Button1)
  assign($Button2)
  assign($Button3)
  assign($Button4)
  assign($Button5)
  assign($Button6)
  assign($Button7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if (randf() < flip_probability):
    var color: Vector3
    if a_buttons_on:
      color = off_color
      a_buttons_on = false
    else:
      color = on_color
      a_buttons_on = true
    for button in a_buttons:
      button.illuminate(color)

  if (randf() < flip_probability):
    var color: Vector3
    if b_buttons_on:
      color = off_color
      b_buttons_on = false
    else:
      color = on_color
      b_buttons_on = true
    for button in b_buttons:
      button.illuminate(color)
