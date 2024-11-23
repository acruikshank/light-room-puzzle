class_name NumberCurveTransform

var scale: Vector3
var translation: Vector3
var internal_rotation: Quaternion
var external_rotation: Quaternion

func _init(scale: Vector3, translation: Vector3, int_rotation: Transform3D, ext_rotation: Transform3D) -> void:
  self.scale = scale
  self.translation = translation
  self.internal_rotation = Quaternion(int_rotation.basis)
  self.external_rotation = Quaternion(ext_rotation.basis)
