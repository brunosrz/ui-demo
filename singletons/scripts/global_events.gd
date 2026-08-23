extends Node

@warning_ignore("unused_signal")
signal setting_changed(change_data: Dictionary)
@warning_ignore("unused_signal")
signal request_loading_settings_changed
@warning_ignore("unused_signal")
signal loading_settings_changed(settings_data: Dictionary)
@warning_ignore("unused_signal")
signal request_saving_settings_changed
@warning_ignore("unused_signal")
signal request_reset_settings_changed
@warning_ignore("unused_signal")
signal settings_data_save_requested(settings_data: Dictionary)

@warning_ignore("unused_signal")
signal language_changed(change_data: Dictionary)
@warning_ignore("unused_signal")
signal request_loading_language_changed
@warning_ignore("unused_signal")
signal loading_language_changed(language_data: Dictionary)
@warning_ignore("unused_signal")
signal request_saving_language_changed
@warning_ignore("unused_signal")
signal request_reset_language_changed
@warning_ignore("unused_signal")
signal language_data_save_requested(language_data: Dictionary)

@warning_ignore("unused_signal")
signal game_state_updated(state_data: Dictionary)
@warning_ignore("unused_signal")
signal request_game_state_change(state_request_data: Dictionary)
@warning_ignore("unused_signal")
signal return_to_previous_state_requested

@warning_ignore("unused_signal")
signal scene_updated(scene_data: Dictionary)
@warning_ignore("unused_signal")
signal scene_push_requested(scene_request_data: Dictionary)
@warning_ignore("unused_signal")
signal scene_pop_requested
@warning_ignore("unused_signal")
signal request_game_selection_scene

@warning_ignore("unused_signal")
signal show_ui_requested(ui_data: Dictionary)
@warning_ignore("unused_signal")
signal hide_ui_requested(ui_data: Dictionary)
@warning_ignore("unused_signal")
signal show_quit_confirmation_requested
@warning_ignore("unused_signal")
signal hide_quit_confirmation_requested
@warning_ignore("unused_signal")
signal quit_confirmed
@warning_ignore("unused_signal")
signal quit_cancelled
@warning_ignore("unused_signal")
signal save_settings_requested
@warning_ignore("unused_signal")
signal show_tooltip_requested(tooltip_data: Dictionary)
@warning_ignore("unused_signal")
signal hide_tooltip_requested

@warning_ignore("unused_signal")
signal show_popover_requested(content_data: Dictionary, parent_node: Node)
@warning_ignore("unused_signal")
signal hide_popover_requested
@warning_ignore("unused_signal")
signal popover_button_pressed(action: String)

@warning_ignore("unused_signal")
signal show_toast_requested(toast_data: Dictionary)

@warning_ignore("unused_signal")
signal start_tutorial_requested(tutorial_data: Dictionary)
@warning_ignore("unused_signal")
signal coach_mark_next_requested
@warning_ignore("unused_signal")
signal coach_mark_skip_requested
@warning_ignore("unused_signal")
signal tutorial_finished

@warning_ignore("unused_signal")
signal debug_log_requested(log_data: Dictionary)

@warning_ignore("unused_signal")
signal request_save_game(session_id: int, game_mode: String, game_data: Dictionary)
@warning_ignore("unused_signal")
signal game_saved(session_id: int)
@warning_ignore("unused_signal")
signal request_load_game(session_id: int, game_mode: String)
@warning_ignore("unused_signal")
signal game_loaded(session_id: int, game_data: Dictionary)

@warning_ignore("unused_signal")
signal live_settings_data_provided(settings_data: Dictionary)
@warning_ignore("unused_signal")
signal request_live_language_data
@warning_ignore("unused_signal")
signal live_language_data_provided(language_data: Dictionary)

@warning_ignore("unused_signal")
signal item_added(item_data: Dictionary)
@warning_ignore("unused_signal")
signal item_removed(item_data: Dictionary)
@warning_ignore("unused_signal")
signal item_used(item_data: Dictionary)

@warning_ignore("unused_signal")
signal character_defeated(character_data: Dictionary)
@warning_ignore("unused_signal")
signal item_spawned(item_data: Dictionary, position: Vector3)

@warning_ignore("unused_signal")
signal show_floating_text_requested(text_data: Dictionary)

@warning_ignore("unused_signal")
signal quest_updated(quest_data: Dictionary)

@warning_ignore("unused_signal")
signal input_action_triggered(action_data: Dictionary)


func _ready() -> void:
	print("GlobalEvents: Inicializado.")
