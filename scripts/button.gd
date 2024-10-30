class_name IlluminatedButton extends Node3D

var _color: Vector3
var _material: Material
var i: int = 0
var j: int = 0

signal pressed(i: int, j: int)

func illuminate(color: Vector3):
  _color = color
  if _material:
    _material.set("shader_parameter/color", color)

func identify(_i: int, _j: int) -> void:
  i = _i
  j = _j

func interact():
  pressed.emit(i,j)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  _material = $Mesh.material.duplicate()
  $Mesh.material = _material
  illuminate(_color)  

func _process(delta: float) -> void:
  pass
    
