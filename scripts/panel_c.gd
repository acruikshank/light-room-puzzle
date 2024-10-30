extends Node3D
class_name PanelC

const light_color = Color(0.227, 0.715, 0.931)

const flip_probability = 0.002
const on_color = PuzzleColor.STD_BUTTON_ILLUMINATION
const off_color = Vector3(0.001,0,0)

var a_buttons = []
var a_buttons_on = false
var b_buttons = []
var b_buttons_on = false

var light_on = false
signal light_switch(on: bool)

func _on_light_switch_pressed(i: int, j: int) -> void:
  light_on = !light_on
  light_switch.emit(light_on)
  if light_on:
    $LightSwitch.illuminate(PuzzleColor.color2vec(light_color))
  else:
    $LightSwitch.illuminate(Vector3(0,0,0))

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
  assign($Button8)
  assign($Button9)

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
