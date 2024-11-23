class_name NumberCurve

var shape: Array
var transform0: NumberCurveTransform
var transform1: NumberCurveTransform
var theta: float
var dTheta: float
var allocation: int
var baseDTheta: float = 5
var curve: Interpolation

func _init(shape, transform0: NumberCurveTransform, transform1: NumberCurveTransform, allocation) -> void:
  self.shape = shape
  self.transform0 = transform0
  self.transform1 = transform1
  self.allocation = allocation
  transform_curve(0)

func transform_curve(lambda: float):
  var rotation_lambda = pow(lambda, 8.0)
  var transform = Transform3D(Basis(transform0.external_rotation.slerp(transform1.external_rotation, rotation_lambda)), Vector3(0,0,0))
  transform *= Transform3D().translated(lerp(transform0.translation, transform1.translation, lambda))
  transform *= Transform3D(Basis(transform0.internal_rotation.slerp(transform1.internal_rotation, rotation_lambda)), Vector3(0,0,0))
  transform *= Transform3D().scaled(lerp(transform0.scale, transform1.scale, lambda))
  #print(transform)

  #var transform = Transform3D(Basis(transform1.external_rotation), Vector3(0,0,0))
  #transform *= Transform3D().translated(transform1.translation)
  #transform *= Transform3D(Basis(transform1.internal_rotation), Vector3(0,0,0))
  #transform *= Transform3D().scaled(transform1.scale)

  curve = Curves.points_to_spline(shape, transform)
  var length = curve.renormalize(Curves.standard_metric)
  dTheta = baseDTheta / length
  print(dTheta, " ", baseDTheta, " ", length)

func position_at(frac: float):
  var lambda = frac + theta
  lambda -= int(lambda)
  return curve.find(lambda)

func tick(delta: float):
  theta += dTheta * delta
