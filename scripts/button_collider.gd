class_name ButtonCollider extends RigidBody3D

signal interaction

func interact() -> void:
  interaction.emit()
