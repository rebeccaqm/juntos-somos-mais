extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name.to_lower().begins_with("menin"):
		get_tree().call_deferred("change_scene_to_file","res://Cenas/fase_2_biblioteca.tscn")
