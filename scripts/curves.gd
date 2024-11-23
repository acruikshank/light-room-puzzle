class_name Curves

static func cubic_bezier_3d(a: Vector3, b: Vector3, c: Vector3, d: Vector3) -> Callable:
  return func(t: float) -> Vector3:
    var tsq = t*t
    var ti = 1 - t
    var tisq = ti*ti
    return tisq*ti * a + 3*tisq*t * b + 3*ti*tsq * c + tsq*t * d

static func quartic_bezier_3d(a: Vector3, b: Vector3, c: Vector3, d: Vector3, e: Vector3) -> Callable:
  return func(t: float) -> Vector3:
    var tsq = t*t
    var tcub = tsq * t
    var ti = 1 - t
    var tisq = ti*ti
    var ticub = tisq * ti
    return ticub*ti * a + 4*ticub*t * b + 6*tisq*tsq * c + 4*ti*tcub * d + tcub*t * e

static func standard_metric(a: Vector3, b: Vector3) -> float:
  return a.distance_to(b)

static func gen_points(segments: Array, reverse: bool):
  var vec_segments = []
  for curve in segments:
    var vec_curve = []
    for p in curve:
      vec_curve.append(Vector3(p[0], p[1], p[2]))
    vec_segments.append(vec_curve)
  
  # add trailing vectors to curves and drop last segment
  for index in range(0, len(vec_segments)-1):
    var segment = vec_segments[index]
    var end = vec_segments[index+1]
    var end_point = end[0]
    var end_ctl = end[1]
    segment.append(2*end_point - end_ctl)
    segment.append(end_point)
  vec_segments = vec_segments.slice(0,-1)
  
  if !reverse:
    return vec_segments
  
  # add reverse inverted on z axis
  var reversed = vec_segments.map(func(segment):
    var inverted = segment.map(func(point):
      return Vector3(point.x, point.y, -point.z)
    )
    inverted.reverse()
    return inverted
  )
  reversed.reverse()
  
  return vec_segments + reversed
  
static func points_to_spline(segments: Array, transform: Transform3D) -> Interpolation:
  var enumerated = Util.enumerate(segments)
  return Interpolation.new(enumerated.map(func(segment_tuple):
      var index = segment_tuple[0]
      var curve = segment_tuple[1]
      var parameter = float(index) / len(segments)
      if len(curve) == 5:
        return [parameter, quartic_bezier_3d(
          transform * curve[0], 
          transform * curve[1], 
          transform * curve[2], 
          transform * curve[3], 
          transform * curve[4]
        )]
      else:
        return [parameter, cubic_bezier_3d(
          transform * curve[0],
          transform * curve[1],
          transform * curve[2],
          transform * curve[3]
        )]
  ), 1.0)
