extends Node3D

const PAN_SPEED = .001
const RAY_LENGTH = 1000

signal collision_result(available: bool)

func _ready() -> void:
  Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event: InputEvent) -> void:
  if event.is_released() and event is InputEventMouseButton:
    var collider = active_collider()
    if collider is ButtonCollider:
      collider.interact()
  if event is InputEventMouseMotion:
    rotation += PAN_SPEED * Vector3(-event.relative.y, 0, 0)

func active_collider() -> RigidBody3D:
  var camera = $Camera
  var space_state = get_world_3d().direct_space_state
  var mousepos = get_viewport().get_visible_rect().size / 2

  var end = global_position + camera.project_ray_normal(mousepos) * RAY_LENGTH
  var query = PhysicsRayQueryParameters3D.create(global_position, end, 2)
  query.collide_with_areas = true
  var result = space_state.intersect_ray(query)

  if len(result) > 0:
    return result['collider']
  else:
    return null

func _process(delta: float) -> void:
  var collider = active_collider()
  collision_result.emit(collider != null)
  
