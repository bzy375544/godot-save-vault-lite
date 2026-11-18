class_name SaveLiteHelper
extends Node
## Autoload `SaveSettingsLite`: Free starter edition providing single-slot atomic JSON save/load
## plus Master audio volume & fullscreen toggle persistence.

signal game_saved(path: String)
signal game_loaded(data: Dictionary)

@export var save_path: String = "user://save_lite.json"
@export var settings_path: String = "user://settings_lite.cfg"

var master_volume: float = 0.85
var fullscreen: bool = false


func _ready() -> void:
	load_settings()


func save_game(data: Dictionary) -> bool:
	var tmp: String = save_path + ".tmp"
	var text: String = JSON.stringify(data, "\t")
	var f := FileAccess.open(tmp, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(text)
	f.flush()
	f = null

	var verify := FileAccess.open(tmp, FileAccess.READ)
	if verify == null or verify.get_length() == 0:
		return false
	var verified_bytes: PackedByteArray = verify.get_buffer(verify.get_length())
	verify = null

	var out := FileAccess.open(save_path, FileAccess.WRITE)
	if out == null:
		return false
	out.store_buffer(verified_bytes)
	out.flush()
	out = null
	DirAccess.remove_absolute(tmp)
	game_saved.emit(save_path)
	return true


func load_game() -> Dictionary:
	if not FileAccess.file_exists(save_path):
		return {}
	var raw: String = FileAccess.get_file_as_string(save_path)
	var j := JSON.new()
	if j.parse(raw) != OK or typeof(j.data) != TYPE_DICTIONARY:
		return {}
	var parsed: Dictionary = j.data
	game_loaded.emit(parsed)
	return parsed


func set_master_volume(linear_val: float) -> void:
	master_volume = clampf(linear_val, 0.0, 1.0)
	var bus_idx: int = AudioServer.get_bus_index("Master")
	if bus_idx >= 0:
		AudioServer.set_bus_volume_db(bus_idx, -80.0 if master_volume <= 0.001 else linear_to_db(master_volume))
	save_settings()


func set_fullscreen(enabled: bool) -> void:
	fullscreen = enabled
	if not OS.has_feature("web") and DisplayServer.get_name() != "headless":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	save_settings()


func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "master_volume", master_volume)
	cfg.set_value("display", "fullscreen", fullscreen)
	cfg.save(settings_path)


func load_settings() -> void:
	if not FileAccess.file_exists(settings_path):
		return
	var cfg := ConfigFile.new()
	if cfg.load(settings_path) != OK:
		return
	set_master_volume(float(cfg.get_value("audio", "master_volume", 0.85)))
	fullscreen = bool(cfg.get_value("display", "fullscreen", false))
	if not OS.has_feature("web") and DisplayServer.get_name() != "headless":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
