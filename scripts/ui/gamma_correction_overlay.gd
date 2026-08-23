extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect


func _ready():
	GlobalEvents.settings_changed.connect(_on_settings_changed)
	GlobalEvents.request_loading_settings_changed.emit()


func _on_settings_changed(change_data: Dictionary) -> void:
	if change_data.has("video") and change_data["video"].has("gamma_correction"):
		var gamma_value: float = change_data["video"]["gamma_correction"]
		if color_rect and color_rect.material is ShaderMaterial:
			var shader_material: ShaderMaterial = color_rect.material
			shader_material.set_shader_parameter("gamma", gamma_value)
			print("Gamma definido para: ", gamma_value)
