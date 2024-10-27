extends CSGBox3D

const BUTTON_SCALE = 1
const BUTTON_Y_SCALE = 1.5
const BUTTON_SPACING = .22
const BUTTON_Y = .248
const BUTTON_Z_OFFSET = .2

var buttons: Array[Array] = [[],[],[],[],[]]

const UPDATE_DELAY = 0.1
var countdown: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  for i in range(0, 5):
    for j in range(0, 5):
      var button_scene = load("res://scenes/button.tscn")
      var button = button_scene.instantiate()
      buttons[i].append(button)
      button.position = Vector3((i-2)*BUTTON_SPACING, BUTTON_Y, (j-2)*BUTTON_SPACING + BUTTON_Z_OFFSET)
      button.scale = Vector3(BUTTON_SCALE, BUTTON_Y_SCALE, BUTTON_SCALE)
      #button.illuminate(Vector3(randf(), randf(), randf()))
      add_child(button)
  countdown = UPDATE_DELAY


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  countdown -= delta
  if countdown < 0:
    #for i in range(0, 5):
      #for j in range(0, 5):
        #buttons[i][j].illuminate(Vector3(randf(), randf(), randf()))
    countdown = UPDATE_DELAY
