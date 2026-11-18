@tool
extends EditorPlugin

const AUTOLOAD_NAME := "SaveSettingsLite"
const AUTOLOAD_PATH := "res://addons/save_settings_lite/core/save_settings_lite.gd"


func _enter_tree() -> void:
	if not ProjectSettings.has_setting("autoload/" + AUTOLOAD_NAME):
		add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)


func _exit_tree() -> void:
	pass


func _disable_plugin() -> void:
	if ProjectSettings.has_setting("autoload/" + AUTOLOAD_NAME):
		remove_autoload_singleton(AUTOLOAD_NAME)
