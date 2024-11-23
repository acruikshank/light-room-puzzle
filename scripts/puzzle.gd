extends Node3D

const BUTTON_SCALE = 1
const BUTTON_Y_SCALE = 1.1
const BUTTON_SPACING = .22
const BUTTON_Y = .248
const BUTTON_Z_OFFSET = .22

const COUNTDOWN_SCALE = Vector3(.8, 1, 2)
const COUNTDOWN_OFFSET = -0.59

const DARK_FACTOR = 0.75

const PUZZLE_COLORS = [
  Color(1.0, 0.0, 0.0),
  Color(1.0, 0.3, 0.15),
  Color(0, 1.0, 0),
  Color(0 ,0, 1.0),
  Color(0.4, 0.0, 1.0),
  #Color(0.827, 0.132, 0.222),
  #Color(0.97, 0.388, 0.194),
  #Color(0.164, 0.642, 0.217),
  #Color(0, 0.437, 0.747),
  #Color(0.57, 0.288, 1),
]

var BRIGHT_COLORS = [
  Vector3(0,0,0),
  PuzzleColor.color2vec(PUZZLE_COLORS[0]),
  PuzzleColor.color2vec(PUZZLE_COLORS[1]),
  PuzzleColor.color2vec(PUZZLE_COLORS[2]),
  PuzzleColor.color2vec(PUZZLE_COLORS[3]),
  PuzzleColor.color2vec(PUZZLE_COLORS[4])
]

var DARK_COLORS = [
  Vector3(0,0,0),
  PuzzleColor.color2vec(PUZZLE_COLORS[0].darkened(DARK_FACTOR)),
  PuzzleColor.color2vec(PUZZLE_COLORS[1].darkened(DARK_FACTOR)),
  PuzzleColor.color2vec(PUZZLE_COLORS[2].darkened(DARK_FACTOR)),
  PuzzleColor.color2vec(PUZZLE_COLORS[3].darkened(DARK_FACTOR)),
  PuzzleColor.color2vec(PUZZLE_COLORS[4].darkened(DARK_FACTOR))
]

var buttons: Array[Array] = [[],[],[],[],[]]
var countdown_buttons: Array[IlluminatedButton] = []
signal num_correct_signal(correct: int)

const FLASH_DELAY = .25
var timer = FLASH_DELAY

const SOLUTION = [
  [2,3,5,4,1],
  [5,4,1,2,3],
  [3,1,4,5,2],
  [4,2,3,1,5],
  [1,5,2,3,4],
]

var current_state = [
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0],
]

var countdown = 0
var puzzle_delta = 0
var num_correct = 0

const NOT_CHECKING = 0
const CHECK_START = 1
const CHECK_FIRST_FLASH = 2
const CHECK_SECOND_FLASH = 3
const CHECK_DONE = 4

var check_state = NOT_CHECKING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var button_scene = load("res://scenes/interactive_button.tscn")

  for i in range(0, 5):
    var countdown_button = button_scene.instantiate()
    countdown_buttons.append(countdown_button)
    countdown_button.position = Vector3((i-2)*BUTTON_SPACING, BUTTON_Y, COUNTDOWN_OFFSET)
    countdown_button.pressed.connect(_on_countdown_button_pressed)
    countdown_button.scale = COUNTDOWN_SCALE
    add_child(countdown_button)

    for j in range(0, 5):
      var button = button_scene.instantiate()
      button.identify(i,j)
      button.pressed.connect(_on_button_pressed)
      buttons[i].append(button)
      button.position = Vector3((i-2)*BUTTON_SPACING, BUTTON_Y, (2-j)*BUTTON_SPACING + BUTTON_Z_OFFSET)
      button.scale = Vector3(BUTTON_SCALE, BUTTON_Y_SCALE, BUTTON_SCALE)
      add_child(button)

  countdown_buttons[0].illuminate(PuzzleColor.STD_BUTTON_ILLUMINATION)
  

func _on_button_pressed(i: int, j: int) -> void:
  if check_state != NOT_CHECKING:
    return

  current_state[i][j] = (current_state[i][j] + 1) % 6
  buttons[i][j].illuminate(BRIGHT_COLORS[current_state[i][j]])
  _on_countdown_button_pressed(0,0)

func _check_puzzle_state():
  var next_num_correct = 0
  for i in range(0, 5):
    for j in range(0, 5):
      if current_state[i][j] == SOLUTION[i][j]:
        next_num_correct += 1
  puzzle_delta = next_num_correct - num_correct
  num_correct = next_num_correct
  num_correct_signal.emit(num_correct)

func _on_countdown_button_pressed(i: int, j: int) -> void:
  if check_state != NOT_CHECKING:
    return

  countdown = countdown + 1
  
  if countdown > 4:
    for k in range(0, 5):
      countdown_buttons[k].illuminate(Vector3(0,0,0))
    _check_puzzle_state()
    timer = FLASH_DELAY
    check_state = 1
    return
  
  for k in range(0, 5):
    if k <= countdown:
      countdown_buttons[k].illuminate(PuzzleColor.STD_BUTTON_ILLUMINATION)
    else:
      countdown_buttons[k].illuminate(Vector3(0,0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if check_state == NOT_CHECKING:
    return
  elif check_state == CHECK_START:
    timer = FLASH_DELAY
    check_state += 1
    return
  elif check_state == CHECK_FIRST_FLASH or check_state == CHECK_SECOND_FLASH:
    timer -= delta
    if timer < 0:
      timer = FLASH_DELAY
      check_state += 1
      return
    var base_color: Color
    if puzzle_delta < 0:
      base_color = Color.RED
    elif puzzle_delta > 0:
      base_color = Color.GREEN
    else:
      base_color = PuzzleColor.vec2color(PuzzleColor.STD_BUTTON_ILLUMINATION)

    var color = PuzzleColor.color2vec(base_color
      .darkened(1-(timer/FLASH_DELAY)**2))
    for i in range(0, 5):
      for j in range(0, 5):
        buttons[i][j].illuminate(color)
  elif check_state == CHECK_DONE:
    var num_correct = 0
    for i in range(0, 5):
      for j in range(0, 5):
        buttons[i][j].illuminate(BRIGHT_COLORS[current_state[i][j]])
    countdown_buttons[0].illuminate(PuzzleColor.STD_BUTTON_ILLUMINATION)
    countdown = 0
    check_state = 0
