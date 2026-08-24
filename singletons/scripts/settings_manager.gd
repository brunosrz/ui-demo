extends Node

const SETTINGS_PATH = "user://settings.json"
const INPUT_BINDINGS_PATH = "user://input_bindings.json"

const DEFAULT_SETTINGS = {
	"audio":
	{
		"master_volume": 1.0,
		"sfx_volume": 1.0,
		"music_volume": 1.0,
	},
	"locale": "pt_br",
	"video":
	{
		"monitor_index": 0,
		"window_mode": DisplayServer.WINDOW_MODE_WINDOWED,
		"resolution": {"x": 1280, "y": 720},
		"field_of_view": 70.0,
		"aspect_ratio": 0,
		"dynamic_render_scale_mode": 0,
		"upscaling_mode": 0,
		"upscaling_quality": 2,
		"render_scale": 1.0,
		"frame_rate_limit_mode": 0,
		"max_frame_rate": 60,
		"vsync_mode": DisplayServer.VSYNC_ENABLED,
		"triple_buffering": false,
		"reduce_buffering": false,
		"low_latency_mode": 0,
		"gamma_correction": 2.2,
		"contrast": 1.0,
		"brightness": 1.0,
		"hdr_mode": 0,
		"shaders_quality": 2,
		"effects_quality": 2,
		"colorblind_mode": 0,
		"reduce_screen_shake": false,
	},
	"ui_scale_preset": "medium",
}

var settings: Dictionary = {}
var display_options: Dictionary = {"monitors": []}

@onready var scene_manager: SceneManager = get_node("/root/SceneManager")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	settings = DEFAULT_SETTINGS.duplicate(true)

	print("SettingsManager: Conectando request_loading_settings_changed...")
	GlobalEvents.request_loading_settings_changed.connect(load_settings)
	print("SettingsManager: Conectando request_saving_settings_changed...")
	GlobalEvents.request_saving_settings_changed.connect(save_settings)
	print("SettingsManager: Conectando request_reset_settings_changed...")
	GlobalEvents.request_reset_settings_changed.connect(reset_settings)
	print("SettingsManager: Conectando request_loading_input_map_changed...")
	GlobalEvents.request_loading_input_map_changed.connect(load_input_map)
	print("SettingsManager: Conectando request_reset_input_map...")
	GlobalEvents.request_reset_input_map.connect(reset_input_map)
	print("SettingsManager: Conectando setting_changed...")
	GlobalEvents.setting_changed.connect(_on_setting_changed_live)
	print("SettingsManager: Conectando language_changed...")
	GlobalEvents.language_changed.connect(_on_language_changed_live)

	_detect_display_options()
	load_settings()
	_load_input_bindings()


func get_display_options() -> Dictionary:
	return display_options


func _on_setting_changed_live(change_data: Dictionary) -> void:
	for category_key in change_data:
		if (
			settings.has(category_key)
			and typeof(settings[category_key]) == TYPE_DICTIONARY
			and typeof(change_data[category_key]) == TYPE_DICTIONARY
		):
			for setting_key in change_data[category_key]:
				if settings[category_key].has(setting_key):
					settings[category_key][setting_key] = change_data[category_key][setting_key]
				else:
					push_warning(
						(
							"SettingsManager: Tentativa de alterar configuração desconhecida dentro da categoria '"
							+ category_key
							+ "': "
							+ setting_key
						)
					)
		elif settings.has(category_key):
			settings[category_key] = change_data[category_key]
		else:
			push_warning(
				(
					"SettingsManager: Tentativa de alterar categoria de configuração desconhecida: "
					+ category_key
				)
			)
	_apply_all_settings()


func _on_language_changed_live(change_data: Dictionary) -> void:
	var locale_code = change_data.get("language", {}).get("locale", "pt_br")
	settings["locale"] = locale_code
	TranslationServer.set_locale(locale_code)
	_apply_all_settings()


func _on_request_live_settings_data() -> void:
	GlobalEvents.live_settings_data_provided.emit(settings)


func _on_request_live_language_data() -> void:
	GlobalEvents.live_language_data_provided.emit({"locale": settings.get("locale", "pt_br")})


func save_settings() -> void:
	_save_settings_to_file(settings)
	_apply_all_settings()
	print("Configurações salvas com sucesso em: %s" % SETTINGS_PATH)
	GlobalEvents.settings_data_save_requested.emit(settings)


func load_settings() -> void:
	settings = _load_settings_from_file()
	_apply_all_settings()
	GlobalEvents.loading_settings_changed.emit(settings)


func reset_settings() -> void:
	settings = DEFAULT_SETTINGS.duplicate(true)
	save_settings()
	print("Configurações resetadas para o padrão.")


func load_input_map() -> void:
	GlobalEvents.loading_input_map_changed.emit(_build_input_map_data())


func reset_input_map() -> void:
	InputMap.load_from_project_settings()
	if FileAccess.file_exists(INPUT_BINDINGS_PATH):
		DirAccess.remove_absolute(INPUT_BINDINGS_PATH)
	load_input_map()
	print("Mapeamento de teclas resetado para o padrão.")


func rebind_action(action: String, input_type: String, event: InputEvent) -> void:
	if not InputMap.has_action(action):
		push_warning("SettingsManager: Ação de input desconhecida: " + action)
		return

	for existing_event in InputMap.action_get_events(action):
		if _event_matches_type(existing_event, input_type):
			InputMap.action_erase_event(action, existing_event)

	InputMap.action_add_event(action, event)

	_save_input_bindings()
	load_input_map()
	print("SettingsManager: Ação '%s' remapeada (%s)." % [action, input_type])


func _event_matches_type(event: InputEvent, input_type: String) -> bool:
	match input_type:
		"keyboard":
			return event is InputEventKey
		"controller":
			return event is InputEventJoypadButton
		"mouse":
			return event is InputEventMouseButton
	return false


func _build_input_map_data() -> Dictionary:
	var actions: Dictionary = {}

	for action in InputMap.get_actions():
		var action_name: String = action
		if action_name.begins_with("ui_"):
			continue

		var bindings: Array = []
		for event in InputMap.action_get_events(action_name):
			var serialized_event = _serialize_input_event(event)
			if not serialized_event.is_empty():
				bindings.append(serialized_event)

		actions[action_name] = bindings

	return {"general": actions}


func _serialize_input_event(event: InputEvent) -> Dictionary:
	if event is InputEventKey:
		return {
			"type": "InputEventKey",
			"keycode": event.physical_keycode if event.physical_keycode != 0 else event.keycode,
		}
	if event is InputEventJoypadButton:
		return {"type": "InputEventJoypadButton", "button_index": event.button_index}
	if event is InputEventMouseButton:
		return {"type": "InputEventMouseButton", "button_index": event.button_index}
	return {}


func _deserialize_input_event(event_data: Dictionary) -> InputEvent:
	match event_data.get("type", ""):
		"InputEventKey":
			var key_event = InputEventKey.new()
			key_event.physical_keycode = event_data.get("keycode", 0)
			return key_event
		"InputEventJoypadButton":
			var joypad_event = InputEventJoypadButton.new()
			joypad_event.button_index = event_data.get("button_index", 0)
			return joypad_event
		"InputEventMouseButton":
			var mouse_event = InputEventMouseButton.new()
			mouse_event.button_index = event_data.get("button_index", 0)
			return mouse_event
	return null


func _save_input_bindings() -> void:
	var data: Dictionary = _build_input_map_data()["general"]
	var file = FileAccess.open(INPUT_BINDINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "  "))
	else:
		printerr(
			"SettingsManager: Falha ao salvar mapeamento de teclas em: %s" % INPUT_BINDINGS_PATH
		)


func _load_input_bindings() -> void:
	if not FileAccess.file_exists(INPUT_BINDINGS_PATH):
		return

	var file = FileAccess.open(INPUT_BINDINGS_PATH, FileAccess.READ)
	if not file:
		return

	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return

	for action_name in parsed:
		if not InputMap.has_action(action_name):
			continue

		for existing_event in InputMap.action_get_events(action_name):
			InputMap.action_erase_event(action_name, existing_event)

		for event_data in parsed[action_name]:
			var event = _deserialize_input_event(event_data)
			if event:
				InputMap.action_add_event(action_name, event)


func _detect_display_options() -> void:
	display_options.monitors.clear()
	var screen_count = DisplayServer.get_screen_count()
	print("SettingsManager: Detectados %d monitores." % screen_count)

	var common_resolutions = [
		Vector2i(568, 320),
		Vector2i(640, 480),
		Vector2i(960, 540),
		Vector2i(1280, 720),
		Vector2i(1366, 768),
		Vector2i(1600, 900),
		Vector2i(1920, 1080),
		Vector2i(2560, 1440),
		Vector2i(3840, 2160),
		Vector2i(7680, 4320)
	]

	for i in range(screen_count):
		var monitor_info = {
			"id": i,
			"size": DisplayServer.screen_get_size(i),
			"refresh_rate": DisplayServer.screen_get_refresh_rate(i),
			"resolutions": common_resolutions
		}
		display_options.monitors.append(monitor_info)
		print("  - Monitor %d: %s, %f Hz" % [i, str(monitor_info.size), monitor_info.refresh_rate])


func _apply_all_settings() -> void:
	var master_volume = settings.get("audio", {}).get(
		"master_volume", DEFAULT_SETTINGS["audio"]["master_volume"]
	)
	var music_volume = settings.get("audio", {}).get(
		"music_volume", DEFAULT_SETTINGS["audio"]["music_volume"]
	)
	var sfx_volume = settings.get("audio", {}).get(
		"sfx_volume", DEFAULT_SETTINGS["audio"]["sfx_volume"]
	)

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))

	TranslationServer.set_locale(settings.get("locale", DEFAULT_SETTINGS["locale"]))

	var video_settings = settings.get("video", {})
	var window_mode = video_settings.get("window_mode", DEFAULT_SETTINGS["video"]["window_mode"])
	DisplayServer.window_set_mode(window_mode)
	print("Window Mode: ", DisplayServer.window_get_mode())

	var monitor_idx = video_settings.get(
		"monitor_index", DEFAULT_SETTINGS["video"]["monitor_index"]
	)
	if window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_current_screen(monitor_idx)
	elif window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		_center_window_on_monitor(monitor_idx)

	var res_dict = video_settings.get("resolution", DEFAULT_SETTINGS["video"]["resolution"])
	var resolution = Vector2i(res_dict.x, res_dict.y)
	if window_mode != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(resolution)

	_apply_field_of_view(
		video_settings.get("field_of_view", DEFAULT_SETTINGS["video"]["field_of_view"])
	)
	_apply_aspect_ratio(
		video_settings.get("aspect_ratio", DEFAULT_SETTINGS["video"]["aspect_ratio"])
	)
	_apply_dynamic_render_scale_mode(
		video_settings.get(
			"dynamic_render_scale_mode", DEFAULT_SETTINGS["video"]["dynamic_render_scale_mode"]
		)
	)
	_apply_render_scale_to_viewport(
		video_settings.get("render_scale", DEFAULT_SETTINGS["video"]["render_scale"])
	)
	_apply_frame_rate_limit_mode(
		video_settings.get(
			"frame_rate_limit_mode", DEFAULT_SETTINGS["video"]["frame_rate_limit_mode"]
		)
	)
	_apply_max_frame_rate(
		video_settings.get("max_frame_rate", DEFAULT_SETTINGS["video"]["max_frame_rate"])
	)
	_apply_vsync_mode(video_settings.get("vsync_mode", DEFAULT_SETTINGS["video"]["vsync_mode"]))
	_apply_triple_buffering(
		video_settings.get("triple_buffering", DEFAULT_SETTINGS["video"]["triple_buffering"])
	)
	_apply_reduce_buffering(
		video_settings.get("reduce_buffering", DEFAULT_SETTINGS["video"]["reduce_buffering"])
	)
	_apply_low_latency_mode(
		video_settings.get("low_latency_mode", DEFAULT_SETTINGS["video"]["low_latency_mode"])
	)
	_apply_gamma_correction(
		video_settings.get("gamma_correction", DEFAULT_SETTINGS["video"]["gamma_correction"])
	)
	_apply_contrast(video_settings.get("contrast", DEFAULT_SETTINGS["video"]["contrast"]))
	_apply_brightness(video_settings.get("brightness", DEFAULT_SETTINGS["video"]["brightness"]))
	_apply_hdr_mode(video_settings.get("hdr_mode", DEFAULT_SETTINGS["video"]["hdr_mode"]))
	_apply_shaders_quality(
		video_settings.get("shaders_quality", DEFAULT_SETTINGS["video"]["shaders_quality"])
	)
	_apply_effects_quality(
		video_settings.get("effects_quality", DEFAULT_SETTINGS["video"]["effects_quality"])
	)
	_apply_colorblind_mode(
		video_settings.get("colorblind_mode", DEFAULT_SETTINGS["video"]["colorblind_mode"])
	)
	_apply_reduce_screen_shake(
		video_settings.get("reduce_screen_shake", DEFAULT_SETTINGS["video"]["reduce_screen_shake"])
	)
	_apply_ui_scale_preset(settings.get("ui_scale_preset", DEFAULT_SETTINGS["ui_scale_preset"]))

	print("Configurações aplicadas.")
	print("DEBUG: _apply_all_settings - settings: ", settings)


func _apply_field_of_view(_fov_value: float) -> void:
	pass


func _apply_aspect_ratio(_aspect_ratio_index: int) -> void:
	pass


func _apply_dynamic_render_scale_mode(_mode: int) -> void:
	pass


func _apply_render_scale_to_viewport(scale_value: float) -> void:
	if not scene_manager or not scene_manager.game_viewport:
		return

	var base_width = DisplayServer.window_get_size().x
	var base_height = DisplayServer.window_get_size().y

	var new_viewport_width = int(base_width * scale_value)
	var new_viewport_height = int(base_height * scale_value)

	new_viewport_width = max(1, new_viewport_width)
	new_viewport_height = max(1, new_viewport_height)

	scene_manager.game_viewport.size = Vector2i(new_viewport_width, new_viewport_height)
	print(
		"Resolução de renderização do GameViewport ajustada para: ",
		scene_manager.game_viewport.size
	)


func _apply_frame_rate_limit_mode(_mode: int) -> void:
	pass


func _apply_max_frame_rate(fps_value: int) -> void:
	if settings.has("frame_rate_limit_mode") and settings["frame_rate_limit_mode"] == 0:
		Engine.set_max_fps(fps_value)


func _apply_vsync_mode(mode: int) -> void:
	DisplayServer.window_set_vsync_mode(mode)


func _apply_triple_buffering(_enabled: bool) -> void:
	pass


func _apply_reduce_buffering(_enabled: bool) -> void:
	pass


func _apply_low_latency_mode(_mode: int) -> void:
	pass


func _apply_gamma_correction(_gamma_value: float) -> void:
	pass


func _apply_contrast(_contrast_value: float) -> void:
	pass


func _apply_brightness(_brightness_value: float) -> void:
	pass


func _apply_hdr_mode(_mode: int) -> void:
	pass


func _apply_shaders_quality(_quality_level: int) -> void:
	pass


func _apply_effects_quality(_quality_level: int) -> void:
	pass


func _apply_colorblind_mode(_mode: int) -> void:
	pass


func _apply_reduce_screen_shake(_enabled: bool) -> void:
	pass


func _apply_ui_scale_preset(preset_name: String) -> void:
	var scale_factor: float = 1.0
	match preset_name:
		"small":
			scale_factor = 0.75
		"medium":
			scale_factor = 1.0
		"large":
			scale_factor = 1.25
		_:
			push_warning("Preset de ui desconhecido: " + preset_name)
			return

	get_window().content_scale_factor = scale_factor
	print("Escala da ui ajustada para: ", preset_name, " (", scale_factor, ")")


func _center_window_on_monitor(monitor_idx: int) -> void:
	var monitor_position = DisplayServer.screen_get_position(monitor_idx)
	var monitor_size = DisplayServer.screen_get_size(monitor_idx)
	var window_size = DisplayServer.window_get_size()
	var new_position = monitor_position + (monitor_size / 2) - (window_size / 2)
	DisplayServer.window_set_position(new_position)


func _load_settings_from_file() -> Dictionary:
	var loaded_settings: Dictionary = DEFAULT_SETTINGS.duplicate(true)

	if not FileAccess.file_exists(SETTINGS_PATH):
		print(
			(
				"SettingsManager: Nenhum arquivo de configurações encontrado em %s. Usando padrões e salvando."
				% SETTINGS_PATH
			)
		)
		_save_settings_to_file(loaded_settings)
		return loaded_settings

	print("SettingsManager: Tentando carregar configurações de: %s" % SETTINGS_PATH)
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		print("SettingsManager: Conteúdo lido: ", json_string)
		var parse_result = JSON.parse_string(json_string)
		if parse_result is Dictionary:
			for key in loaded_settings:
				if parse_result.has(key):
					if (
						typeof(loaded_settings[key]) == TYPE_DICTIONARY
						and typeof(parse_result[key]) == TYPE_DICTIONARY
					):
						for sub_key in loaded_settings[key]:
							if parse_result[key].has(sub_key):
								loaded_settings[key][sub_key] = parse_result[key][sub_key]

						if key == "video" and loaded_settings[key].has("resolution"):
							var loaded_res = loaded_settings[key]["resolution"]
							if typeof(loaded_res) == TYPE_STRING:
								var clean_res = (
									loaded_res.replace("(", "").replace(")", "").replace(" ", "")
								)
								var parts = clean_res.split(",")
								if (
									parts.size() == 2
									and parts[0].is_valid_int()
									and parts[1].is_valid_int()
								):
									loaded_settings[key]["resolution"] = {
										"x": int(parts[0]), "y": int(parts[1])
									}
								else:
									push_warning(
										(
											"SettingsManager: Resolução inválida carregada como string: "
											+ loaded_res
											+ ". Usando padrão."
										)
									)
									loaded_settings[key]["resolution"] = DEFAULT_SETTINGS["video"]["resolution"]
							elif (
								typeof(loaded_res) != TYPE_DICTIONARY
								or not loaded_res.has("x")
								or not loaded_res.has("y")
							):
								push_warning(
									"SettingsManager: Resolução carregada com formato inválido. Usando padrão."
								)
								loaded_settings[key]["resolution"] = DEFAULT_SETTINGS["video"]["resolution"]
					else:
						loaded_settings[key] = parse_result[key]
			print("SettingsManager: Configurações finais após mesclagem: ", loaded_settings)
			return loaded_settings

	printerr(
		(
			"SettingsManager: Arquivo de configurações corrompido em %s. Usando padrões e salvando."
			% SETTINGS_PATH
		)
	)
	_save_settings_to_file(loaded_settings)
	print("DEBUG: _load_settings_from_file - loaded_settings: ", loaded_settings)
	return loaded_settings


func _save_settings_to_file(data_to_save: Dictionary) -> void:
	print("SettingsManager: Tentando salvar configurações em: %s" % SETTINGS_PATH)
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(data_to_save, "  ")
		file.store_string(json_string)
		print("SettingsManager: Conteúdo salvo: ", json_string)
	else:
		printerr("SettingsManager: Falha ao salvar as configurações em: %s" % SETTINGS_PATH)
	print("DEBUG: _save_settings_to_file - data_to_save: ", data_to_save)
