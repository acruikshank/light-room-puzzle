class_name Util

static func enumerate(arr: Array) -> Array[Array]:
  var result: Array[Array] = []
  for idx in arr.size():
    result.append([idx, arr[idx]])
  return result
