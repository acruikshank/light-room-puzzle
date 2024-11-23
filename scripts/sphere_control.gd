extends Node3D
        
const sphereScale = 1.25
const max_rotation_angle = 0.05
const rotation_angle_delta = 0.001
var rotating = false
var rotation_angle = 0
const curve_scale = 16

var transform0 = NumberCurveTransform.new(
  curve_scale*Vector3(8, 8, 1),
  Vector3(-160, 60, 0),
  Transform3D().rotated(Vector3(0,1,0), PI/2).rotated(Vector3(0,0,1), PI/2),
  Transform3D()
)

func make_transform(i: int):
  return NumberCurveTransform.new(
    curve_scale*Vector3(1, 2, 1.2),
    Vector3(-160, 15, 0),
    Transform3D().rotated(Vector3(0,1,0), PI/2),
    Transform3D().rotated(Vector3(0,1,0), -0.8 * (float(i)-1.5) / 3)
  )

var combination = [
  NumberCurve.new(Numbers.number3, transform0, make_transform(0), 75),
  NumberCurve.new(Numbers.number8, transform0, make_transform(1), 100),
  NumberCurve.new(Numbers.number6, transform0, make_transform(2), 100),
  NumberCurve.new(Numbers.number1, transform0, make_transform(3), 50),
]
var numSpheres = 0;
const numGroups = 25
var numCorrect = 0;

var theta = 0;
const baseDTheta = 1
var dTheta = baseDTheta

var spheres = []
var groups = []

const base_first_row_count = 30.0
const base_initial_radius = 20.0
const base_row_radius_delta = 6.0
const base_depth = -3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  for num_curve in combination:
    numSpheres += num_curve.allocation
  var sphere_scene = load("res://scenes/Orb.tscn")
  for i in range(0,numSpheres):
    var sphere = sphere_scene.instantiate()
    sphere.scale = Vector3(sphereScale, sphereScale, sphereScale)
    spheres.append(sphere)
    add_child(sphere)
  _set_sphere_bases()
  _group_spheres()


func _input(event: InputEvent) -> void:
  pass
  #if Input.is_action_just_pressed("RotateRight"):
    #if numCorrect < numGroups:
      #for sphere in groups[numCorrect]:
        #sphere.ascend()
      #numCorrect += 1
      #for curve in combination:
        #curve.transform_curve(float(numCorrect) / 25.0)
  #if Input.is_action_just_pressed("RotateLeft"):
    #if numCorrect > 0:
      #for sphere in groups[numCorrect - 1]:
        #sphere.descend()
      #numCorrect -= 1
      #for curve in combination:
        #curve.transform_curve(float(numCorrect) / 25.0)

func set_num_correct(num_correct: int):
  for i in range(len(groups)):
    if i < num_correct:
      for sphere in groups[i]:
        sphere.ascend()
    else:
      for sphere in groups[i]:
        sphere.descend()
  for curve in combination:
    curve.transform_curve(float(num_correct) / 25.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:    
  _position_spheres(theta)
  for number_curve in combination:
    number_curve.tick(delta)

func _position_spheres(theta):
  var base = 0

  for number_curve in combination:
    for i in range(number_curve.allocation):
      var frac = float(i) / number_curve.allocation
      spheres[base + i].visible = true
      spheres[base + i].setTarget(number_curve.position_at(frac))
    base += number_curve.allocation

func _set_sphere_bases():
  var remaining = spheres.duplicate()
  remaining.shuffle()
  var row_count = base_first_row_count
  var row_radius = base_initial_radius
  while remaining.size() > 0:
    var row = remaining.slice(0, row_count)
    remaining = remaining.slice(row_count)
    for i in range(row.size()):
      var theta = lerp(-PI/4, 5*PI/4, float(i)/(row.size()-1))
      var base = Vector3(-row_radius*sin(theta), base_depth, -row_radius*cos(theta))
      row[i].setBase(base)
    row_count = int(row_count * (row_radius + base_row_radius_delta) / row_radius)
    row_radius += base_row_radius_delta

func _group_spheres():
  var ungrouped = spheres.duplicate()
  var spheres_per_group = len(spheres) / numGroups
  for i in range(numGroups):
    var group = []
    for j in range(spheres_per_group):
      var pick = randi_range(0, len(ungrouped)-1)
      group.append(ungrouped[pick])
      ungrouped.remove_at(pick)
    groups.append(group)
