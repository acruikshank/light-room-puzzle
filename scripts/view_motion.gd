extends Node3D

const PAN_SPEED = .02

func _input(event: InputEvent) -> void:
  if event is InputEventPanGesture:
    rotation += PAN_SPEED * Vector3(event.delta.y, 0, 0)
  
