extends Node3D

var _color: Vector3
var _material: Material

func illuminate(color: Vector3):
  _color = color
  if _color and _material:
    _material.set("shader_parameter/color", color)
  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  _material = $Mesh.material.duplicate()
  $Mesh.material = _material
  illuminate(_color)  

func _process(delta: float) -> void:
  pass
    
