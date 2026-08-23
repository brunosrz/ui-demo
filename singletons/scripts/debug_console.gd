extends CanvasLayer

@onready var log_text: RichTextLabel = $Panel/MarginContainer/MainLayout/RightColumn/LogText
@onready
var debug_info_text: RichTextLabel = $Panel/MarginContainer/MainLayout/LeftColumn/DebugInfoText
@onready var log_label: Label = $Panel/MarginContainer/MainLayout/RightColumn/Label

var game_version = "0.5.0"


func _ready() -> void:
	log_text.clear()
	_log_message(tr("DEBUG_CONSOLE_READY"), "INFO")
	_connect_to_global_events()


func _process(_delta: float) -> void:
	if visible:
		_update_debug_info()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_console"):
		visible = not visible


func _update_debug_info() -> void:
	log_label.text = tr("DEBUG_LOG_TITLE")
	var godot_version_info = Engine.get_version_info()
	var godot_version = "{major}.{minor}.{patch}".format(godot_version_info)

	var os_name = OS.get_name()

	var monitor_str = "N/A"
	if SettingsManager and not SettingsManager.display_options.monitors.is_empty():
		var m = SettingsManager.display_options.monitors[0]
		monitor_str = tr("DEBUG_MONITOR_INFO").format(
			{"id": m.id, "size": str(m.size), "hz": m.refresh_rate}
		)

	var current_scene_str = "N/A"

	var game_state_str = "N/A"
	if GameManager:
		game_state_str = GameManager.GameState.keys()[GameManager.current_game_state]

	var info_string = ""
	info_string += tr("DEBUG_GAME_SECTION") + "\n"
	info_string += tr("DEBUG_GAME_VERSION") + game_version + "\n"
	info_string += tr("DEBUG_GAME_STATE").format({"state": game_state_str}) + "\n"
	info_string += tr("DEBUG_CURRENT_SCENE").format({"scene": current_scene_str}) + "\n"
	info_string += tr("DEBUG_LAST_SAVE") + "\n\n"

	info_string += tr("DEBUG_SYSTEM_SECTION") + "\n"
	info_string += "  FPS: {fps}\n".format({"fps": Engine.get_frames_per_second()})
	info_string += "  Godot: v{version}\n".format({"version": godot_version}) + "\n"
	info_string += tr("DEBUG_OS").format({"os": os_name}) + "\n"
	info_string += tr("DEBUG_PROCESSOR").format({"processor": OS.get_processor_name()}) + "\n"
	info_string += tr("DEBUG_CORES").format({"cores": OS.get_processor_count()}) + "\n"
	info_string += (
		tr("DEBUG_RAM").format(
			{"ram": str(round(OS.get_static_memory_usage() / (1024.0 * 1024.0))) + " MB"}
		)
		+ "\n"
	)
	info_string += (
		tr("DEBUG_VIDEO_RENDERER").format(
			{"renderer": ProjectSettings.get_setting("rendering/renderer/rendering_method")}
		)
		+ "\n\n"
	)

	info_string += tr("DEBUG_DISPLAY_SECTION") + "\n"
	info_string += tr("DEBUG_MONITOR").format({"monitor": monitor_str}) + "\n"
	debug_info_text.text = info_string


func _connect_to_global_events() -> void:
	GlobalEvents.debug_log_requested.connect(_on_debug_log_requested)

	GlobalEvents.setting_changed.connect(_on_settings_data_updated)
	GlobalEvents.request_loading_settings_changed.connect(_on_request_loading_settings_changed)
	GlobalEvents.loading_settings_changed.connect(_on_settings_data_updated)
	GlobalEvents.request_saving_settings_changed.connect(_on_request_saving_settings_changed)
	GlobalEvents.request_reset_settings_changed.connect(_on_request_reset_settings_changed)
	GlobalEvents.settings_data_save_requested.connect(_on_settings_data_save_requested)

	GlobalEvents.game_state_updated.connect(_on_game_state_updated)
	GlobalEvents.request_game_state_change.connect(_on_request_game_state_change)
	GlobalEvents.return_to_previous_state_requested.connect(_on_return_to_previous_state_requested)

	GlobalEvents.request_save_game.connect(_on_request_save_game)
	GlobalEvents.game_saved.connect(_on_game_saved)
	GlobalEvents.request_load_game.connect(_on_request_load_game)
	GlobalEvents.game_loaded.connect(_on_game_loaded)
	GlobalEvents.live_settings_data_provided.connect(_on_live_settings_data_provided)
	GlobalEvents.request_live_language_data.connect(_on_request_live_language_data)
	GlobalEvents.live_language_data_provided.connect(_on_live_language_data_provided)

	GlobalEvents.show_ui_requested.connect(_on_show_ui_requested)
	GlobalEvents.hide_ui_requested.connect(_on_on_hide_ui_requested)
	GlobalEvents.show_quit_confirmation_requested.connect(_on_show_quit_confirmation_requested)
	GlobalEvents.hide_quit_confirmation_requested.connect(_on_hide_quit_confirmation_requested)
	GlobalEvents.quit_confirmed.connect(_on_quit_confirmed)
	GlobalEvents.quit_cancelled.connect(_on_quit_cancelled)
	GlobalEvents.save_settings_requested.connect(_on_save_settings_requested)
	GlobalEvents.show_tooltip_requested.connect(_on_show_tooltip_requested)
	GlobalEvents.hide_tooltip_requested.connect(_on_hide_tooltip_requested)
	GlobalEvents.show_popover_requested.connect(_on_show_popover_requested)
	GlobalEvents.hide_popover_requested.connect(_on_hide_popover_requested)
	GlobalEvents.popover_button_pressed.connect(_on_popover_button_pressed)
	GlobalEvents.show_toast_requested.connect(_on_show_toast_requested)
	GlobalEvents.start_tutorial_requested.connect(_on_start_tutorial_requested)
	GlobalEvents.coach_mark_next_requested.connect(_on_coach_mark_next_requested)
	GlobalEvents.coach_mark_skip_requested.connect(_on_coach_mark_skip_requested)
	GlobalEvents.tutorial_finished.connect(_on_tutorial_finished)

	GlobalEvents.item_added.connect(_on_item_added)
	GlobalEvents.item_removed.connect(_on_item_removed)
	GlobalEvents.item_used.connect(_on_item_used)

	GlobalEvents.character_defeated.connect(_on_character_defeated)
	GlobalEvents.item_spawned.connect(_on_item_spawned)

	GlobalEvents.show_floating_text_requested.connect(_on_show_floating_text_requested)

	GlobalEvents.quest_updated.connect(_on_quest_updated)

	GlobalEvents.input_action_triggered.connect(_on_input_action_triggered)

	if SoundSys:
		SoundSys.music_track_changed.connect(_on_sound_sys_music_track_changed)
		SoundSys.volume_changed.connect(_on_sound_sys_volume_changed)


func _log_signal(signal_name: String, args: Dictionary = {}) -> void:
	var message = tr("DEBUG_SIGNAL_RECEIVED").format({"signal": signal_name})
	if not args.is_empty():
		var args_list = []
		for key in args:
			args_list.append("'" + key + "': " + str(args[key]))
		message += tr("DEBUG_WITH_ARGS").format({"args": ", ".join(args_list)})
	_log_message(message, "SIGNAL")


func _log_message(text: String, level: String = "DEBUG") -> void:
	var timestamp = Time.get_time_string_from_system()
	var color = "white"
	match level:
		"INFO":
			color = "lightgreen"
		"SIGNAL":
			color = "lightblue"
		"ERROR":
			color = "red"

	var formatted_log = "[%s] [color=%s]%s[/color]: %s\n" % [timestamp, color, level, text]
	log_text.append_text(formatted_log)


func _on_debug_log_requested(log_data: Dictionary) -> void:
	_log_message(log_data.get("message", ""), log_data.get("level", "DEBUG"))


func _on_settings_data_updated(settings_data: Dictionary) -> void:
	_log_signal("settings_data_updated", {"data": settings_data})


func _on_request_loading_settings_changed() -> void:
	_log_signal("request_loading_settings_changed")


func _on_request_saving_settings_changed() -> void:
	_log_signal("request_saving_settings_changed")


func _on_request_reset_settings_changed() -> void:
	_log_signal("request_reset_settings_changed")


func _on_settings_data_save_requested(settings_data: Dictionary) -> void:
	_log_signal("settings_data_save_requested", {"settings": settings_data})


func _on_game_state_updated(state_data: Dictionary) -> void:
	_log_signal("game_state_updated", {"data": state_data})


func _on_request_game_state_change(state_request_data: Dictionary) -> void:
	_log_signal("request_game_state_change", {"data": state_request_data})


func _on_return_to_previous_state_requested() -> void:
	_log_signal("return_to_previous_state_requested")


func _on_request_save_game(session_id: int, game_mode: String, game_data: Dictionary) -> void:
	_log_signal(
		"request_save_game",
		{"session_id": session_id, "game_mode": game_mode, "game_data": game_data}
	)


func _on_game_saved(session_id: int) -> void:
	_log_signal("game_saved", {"session_id": session_id})


func _on_request_load_game(session_id: int, game_mode: String) -> void:
	_log_signal("request_load_game", {"session_id": session_id, "game_mode": game_mode})


func _on_game_loaded(session_id: int, game_data: Dictionary) -> void:
	_log_signal("game_loaded", {"session_id": session_id, "game_data": game_data})


func _on_request_live_settings_data() -> void:
	_log_signal("request_live_settings_data")


func _on_live_settings_data_provided(settings_data: Dictionary, input_map_data: Dictionary) -> void:
	_log_signal(
		"live_settings_data_provided", {"settings": settings_data, "input_map": input_map_data}
	)


func _on_request_live_language_data() -> void:
	_log_signal("request_live_language_data")


func _on_live_language_data_provided(language_data: Dictionary) -> void:
	_log_signal("live_language_data_provided", {"language_data": language_data})


func _on_show_ui_requested(ui_data: Dictionary) -> void:
	_log_signal("show_ui_requested", {"data": ui_data})


func _on_on_hide_ui_requested(ui_data: Dictionary) -> void:
	_log_signal("hide_ui_requested", {"data": ui_data})


func _on_show_quit_confirmation_requested() -> void:
	_log_signal("show_quit_confirmation_requested")


func _on_hide_quit_confirmation_requested() -> void:
	_log_signal("hide_quit_confirmation_requested")


func _on_quit_confirmed() -> void:
	_log_signal("quit_confirmed")


func _on_quit_cancelled() -> void:
	_log_signal("quit_cancelled")


func _on_save_settings_requested() -> void:
	_log_signal("save_settings_requested")


func _on_show_tooltip_requested(tooltip_data: Dictionary) -> void:
	_log_signal("show_tooltip_requested", {"data": tooltip_data})


func _on_hide_tooltip_requested() -> void:
	_log_signal("hide_tooltip_requested")


func _on_show_popover_requested(content_data: Dictionary, parent_node: Node) -> void:
	_log_signal(
		"show_popover_requested", {"content_data": content_data, "parent_node": parent_node.name}
	)


func _on_hide_popover_requested() -> void:
	_log_signal("hide_popover_requested")


func _on_popover_button_pressed(action: String) -> void:
	_log_signal("popover_button_pressed", {"action": action})


func _on_show_toast_requested(toast_data: Dictionary) -> void:
	_log_signal("show_toast_requested", {"data": toast_data})


func _on_start_tutorial_requested(tutorial_data: Dictionary) -> void:
	_log_signal("start_tutorial_requested", {"data": tutorial_data})


func _on_coach_mark_next_requested() -> void:
	_log_signal("coach_mark_next_requested")


func _on_coach_mark_skip_requested() -> void:
	_log_signal("coach_mark_skip_requested")


func _on_tutorial_finished() -> void:
	_log_signal("tutorial_finished")


func _on_input_map_changed(input_map_data: Dictionary) -> void:
	_log_signal("input_map_changed", {"data": input_map_data})


func _on_loading_input_map_changed(input_map_data: Dictionary) -> void:
	_log_signal("loading_input_map_changed", {"data": input_map_data})


func _on_request_reset_input_map() -> void:
	_log_signal("request_reset_input_map")


func _on_item_added(item_data: Dictionary) -> void:
	_log_signal("item_added", {"data": item_data})


func _on_item_removed(item_data: Dictionary) -> void:
	_log_signal("item_removed", {"data": item_data})


func _on_item_used(item_data: Dictionary) -> void:
	_log_signal("item_used", {"data": item_data})


func _on_character_defeated(character_data: Dictionary) -> void:
	_log_signal("character_defeated", {"data": character_data})


func _on_item_spawned(item_data: Dictionary, position: Vector3) -> void:
	_log_signal("item_spawned", {"data": item_data, "position": position})


func _on_show_floating_text_requested(text_data: Dictionary) -> void:
	_log_signal("show_floating_text_requested", {"data": text_data})


func _on_quest_updated(quest_data: Dictionary) -> void:
	_log_signal("quest_updated", {"data": quest_data})


func _on_input_action_triggered(action_data: Dictionary) -> void:
	_log_signal("input_action_triggered", {"data": action_data})


func _on_sound_sys_play_sfx_requested(sfx_key: String, bus: String) -> void:
	_log_signal("SoundSys.play_sfx_requested", {"key": sfx_key, "bus": bus})


func _on_sound_sys_play_music_requested(music_key: String) -> void:
	_log_signal("SoundSys.play_music_requested", {"key": music_key})


func _on_sound_sys_music_track_changed(music_key: String) -> void:
	_log_signal("SoundSys.music_track_changed", {"track": music_key})


func _on_sound_sys_volume_changed(bus_name: String, linear_volume: float) -> void:
	_log_signal("SoundSys.volume_changed", {"bus": bus_name, "volume": linear_volume})
