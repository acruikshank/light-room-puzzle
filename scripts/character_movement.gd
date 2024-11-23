extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const PAN_SPEED = .002
const HALF_PI = PI/2

var last_click = Time.get_ticks_msec()

func _physics_process(delta: float) -> void:
  ## Add the gravity.
  #if not is_on_floor():
    #velocity += get_gravity() * delta
  move_and_slide()

func _input(event: InputEvent) -> void:
  if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
    var elapsed_time = Time.get_ticks_msec() - last_click
    if elapsed_time < 200 and elapsed_time > 0:
      #if event.double_click:
      #var movement_scale: float = SPEED / get_viewport().get_visible_rect().size.x
      #var relative_motion = movement_scale * Vector3(event.relative.y, 0, -event.relative.x)
      #position += relative_motion.rotated(Vector3(0,1,0), rotation.y - HALF_PI)
      #print("translate ", Vector3(-.5, 0, 0) * rotation)
      position += Vector3.BACK * quaternion * Quaternion(Vector3(1,0,0), PI)
    last_click = Time.get_ticks_msec()
  if event is InputEventMouseMotion:
    rotation += PAN_SPEED * Vector3(0, -event.relative.x, 0)
