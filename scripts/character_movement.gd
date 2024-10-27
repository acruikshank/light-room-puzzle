extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const PAN_SPEED = .02
const HALF_PI = PI/2

func _physics_process(delta: float) -> void:
  ## Add the gravity.
  #if not is_on_floor():
    #velocity += get_gravity() * delta
  
  move_and_slide()

func _input(event: InputEvent) -> void:
  if event is InputEventMouseMotion and Input.is_mouse_button_pressed(1):
    var movement_scale: float = SPEED / get_viewport().get_visible_rect().size.x
    var relative_motion = movement_scale * Vector3(event.relative.y, 0, -event.relative.x)
    position += relative_motion.rotated(Vector3(0,1,0), rotation.y - HALF_PI)
  if event is InputEventPanGesture:
    rotation += PAN_SPEED * Vector3(0, event.delta.x, 0)
