class_name Interpolation

func segment_length(interpolator: Callable, metric: Callable, test_points: int) -> float:
  var length: float = 0.0
  var last_value: Variant = interpolator.call(0)
  for i in range(1, test_points):
    var lambda = float(i)/(test_points-1)
    var current_value = interpolator.call(lambda)
    length += metric.call(last_value, current_value)
    last_value = current_value
  return length
  
var points: Array
var max_t: float

# points are an array of tuples (arrays) containing a max_t and interpoloator
# max_t: float is the parameter distance along the spline where the current segment
#     should start. The max_t of the first segment must be 0, and all values must be
#     strictly increasing. Parameters between this value and the max_t of the next
#     point (or the overall max_t for the end segment) will be generated from this
#     segment. Distance between this value and the next will be converted to an
#     interval between 0 and 1 and passed to the interpolator to find the value.
# interpolator: Callable(t: float -> variant): Takes a value between 0 and 1 and
#     returns an interpolated value for this segment.
func _init(points: Array, max_t: float):
  self.points = points
  self.max_t = max_t

func find(t: float):
  var index = self.points.bsearch_custom(t, func (a, val): return a[0] < val)
  if index >= len(points) or t < points[index][0]:
    index -= 1

  var point = self.points[index][0]

  var next_point: float
  if index < len(self.points) - 1:
    next_point = self.points[index+1][0]
  else:
    next_point = self.max_t

  var lambda = (t - point) / (next_point - point)
  return self.points[index][1].call(lambda)

# Recomputes the max_t of each point so that the difference of any two
# consecutive max_ts is proportional to the length of the segment and the
# parameter space of the entire spline is between 0 and 1.
# metric: Callable[Variant, Variant -> float] - computes a real distance between
#   two interpolated valuee.
# test_points: The number of samples to take from the interpolation to approximate
#   the length of each segment (higher = better but more expensive approximation)
# returns total length
func renormalize(metric: Callable, test_points: int = 100) -> float:
  var max_ts = [0]
  var total_length: float = 0.0
  for segment in points:
    var length = segment_length(segment[1], metric, test_points)
    total_length += length
    max_ts.append(total_length)

  var new_points = []
  for i in range(points.size()):
    var segment = points[i]
    var max_t = max_ts[i] / total_length
    new_points.append([max_t, segment[1]])

  points = new_points
  max_t = 1.0
  
  return total_length
