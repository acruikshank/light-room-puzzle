extends Node3D

# add method to set target position, which is a vector representing the point
# on the sphere's trajectory where it should currently be.
# The sphere also has a velocity (initially 0).
# Subtract the current position from the target to get the acceleration vector
# The accelleration is in the direction of that vector and is a function of its length.
# A longer vector means higher accelleration, but there should be a max.
# The velocity is added to the vector and then it is multiplied by a drag factor.
# The velocity * delta is then added to the position.

const RESTING_STATE = 0 # inert at base position
const ASCENDING_STATE = 1 # rising and luminating above base
const POSITIONING_STATE = 2 # traveling to target
const ORBITING_STATE = 3 # following target
const RETURNING_STATE = 4 # repositining from target to base
const DESCENDING_STATE = 5 # descending to base position.

const ASCENT_RATE = 0.2
const POSITION_RATE = 0.1
const ASCENT_HEIGHT = Vector3(0,30, 0)
const BRIGHTEN_RATE = 0.2
const DARKEN_RATE = 1.0

var target: Vector3 = Vector3(0,0,0)
var base: Vector3 = Vector3(0,-5,0)
var ascent: Vector3 = ASCENT_HEIGHT

const darkAlbedo = Color(0,0,0)
const lightAlbedo = Color(0.852, 0.718, 0.317)

const darkEmission = Color(0,0,0)
const lightEmission = Color(0.65, 0.507, 0.221)
var _material: Material

var state = RESTING_STATE
var state_delta = 0.0

const DARK_STATE = 0
const BRIGHTENING_STATE = 1
const ILLUMINATED_STATE = 2
const DIMMING_STATE = 3

var illumination_state = DARK_STATE
var illuminaton_state_delta: float = 0.0

const max_velocity = 10
#const max_velocity = .5

func setTarget(_target: Vector3):
  target = _target

func setBase(_base: Vector3):
  base = _base
  position = base
  ascent = _base + ASCENT_HEIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass

func setIllumination(frac: float):
  if !_material && $Mesh.material:
      _material = $Mesh.material.duplicate()
      $Mesh.material = _material
  
  if _material:
    var tweened = pow(frac, .8)
    _material.albedo_color = lerp(darkAlbedo, lightAlbedo, tweened)
    _material.emission = lerp(darkEmission, lightEmission, tweened)
    
func ascend():
  #setIllumination(1)
  #state = ORBITING_STATE
  #return
#
  match state:
    RESTING_STATE:
      state_delta = 0.0
      state = ASCENDING_STATE
    RETURNING_STATE:
      state = POSITIONING_STATE
    DESCENDING_STATE:
      state = ASCENDING_STATE
  
  match illumination_state:
    DARK_STATE:
      illuminaton_state_delta = 0.0
      illumination_state = BRIGHTENING_STATE
    DIMMING_STATE:
      illumination_state = BRIGHTENING_STATE
    

func descend():  
  #setIllumination(0)
  #state = RESTING_STATE
  #return

  match state:
    ASCENDING_STATE:
      state = DESCENDING_STATE
    POSITIONING_STATE:
      state = RETURNING_STATE
    ORBITING_STATE:
      state_delta = 1.0
      state = RETURNING_STATE

  match illumination_state:
    ILLUMINATED_STATE:
      illuminaton_state_delta = 1.0
      illumination_state = DIMMING_STATE
    BRIGHTENING_STATE:
      illumination_state = DIMMING_STATE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  var next_position = position
  match state:
    RESTING_STATE:
      next_position = base
    ASCENDING_STATE:
      next_position = lerp(base, ascent, state_delta)
      state_delta += ASCENT_RATE * delta
      if state_delta > 1:
        state_delta = 0.0
        state = POSITIONING_STATE
    POSITIONING_STATE:
      next_position = lerp(ascent, target, state_delta)
      state_delta += POSITION_RATE * delta
      if state_delta > 1:
        state_delta = 0.0
        state = ORBITING_STATE
    ORBITING_STATE:
      next_position = target
    RETURNING_STATE:
      next_position = lerp(ascent, target, state_delta)
      state_delta -= POSITION_RATE * delta
      if state_delta <= 0:
        state_delta = 1.0
        state = DESCENDING_STATE
    DESCENDING_STATE:
      next_position = lerp(base, ascent, state_delta)
      state_delta -= ASCENT_RATE * delta
      if state_delta <= 0:
        state_delta = 0.0
        state = RESTING_STATE

  match illumination_state:
    BRIGHTENING_STATE:
      illuminaton_state_delta += BRIGHTEN_RATE * delta
      if illuminaton_state_delta > 1.0:        
        illumination_state = ILLUMINATED_STATE
        illuminaton_state_delta = 1.0
      setIllumination(illuminaton_state_delta)
    DIMMING_STATE:
      illuminaton_state_delta -= DARKEN_RATE * delta
      if illuminaton_state_delta < 0.0:
        illumination_state = DARK_STATE
        illuminaton_state_delta = 0.0
      setIllumination(illuminaton_state_delta)

  var difference = next_position - position
  var length = difference.length()
  if length > max_velocity:
    position = position + difference.normalized() * max_velocity * delta
  else:
    position = next_position
      
