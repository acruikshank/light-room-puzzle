extends Control

var texture_on: Resource
var texture_off: Resource

func _on_action_available(available: bool) -> void:
  if available:
    $Target.texture = texture_on
  else:
    $Target.texture = texture_off

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  texture_on = load("res://materials/target_on.png")
  texture_off = load("res://materials/target_off.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
