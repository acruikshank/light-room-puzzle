class_name PuzzleColor

const STD_BUTTON_ILLUMINATION = Vector3(.8, .5, .1)

static func color2vec(c: Color) -> Vector3:
  return Vector3(c.r, c.g, c.b)

static func vec2color(v: Vector3) -> Color:
  return Color(v.x, v.y, v.z)
