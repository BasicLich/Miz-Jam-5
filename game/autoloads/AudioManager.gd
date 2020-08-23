extends Node


#
export var sound_effect_scene: PackedScene

#
onready var music_player: AudioStreamPlayer = $MusicPlayer
onready var tween: Tween = $Tween
#onready var animation_player = $AnimationPlayer

const game_music = preload("res://assets/audio/music/song21.ogg")
const game_two_music = preload("res://assets/audio/music/andrewkn_road-in-the-forest.wav")
const game_one_music = preload("res://assets/audio/music/andrewkn_horizon.wav")
const title_music = preload("res://assets/audio/music/song21.ogg")
#const title_music = preload("res://Assets/audio/Juhani Junkala [Retro Game Music Pack] Title Screen.ogg")

const MASTER_BUS_NAME = "Master"
const MUSIC_BUS_NAME = "Music"
const SOUND_EFFECT_BUS_NAME = "SoundEffects"


var current_music_stream = null
var is_changing_music

var master_bus_id = AudioServer.get_bus_index(MASTER_BUS_NAME)
var music_bus_id = AudioServer.get_bus_index(MUSIC_BUS_NAME)
var sound_effect_bus_id = AudioServer.get_bus_index(SOUND_EFFECT_BUS_NAME)

var bus_dictionary: Dictionary = { MASTER_BUS_NAME : master_bus_id, MUSIC_BUS_NAME : music_bus_id, SOUND_EFFECT_BUS_NAME : sound_effect_bus_id }


signal music_changed


func change_music_to(music_path, fade_length = 1, start_again = true):
	
	if is_changing_music or music_path == null: return
	
	if music_player.is_playing() and music_player.get_stream() == music_path and not start_again:
		return
	
	is_changing_music = true
	if music_player.is_playing():
		tween.interpolate_method(self, "_set_music_player_volume", 1, 0, fade_length/2.0, Tween.TRANS_LINEAR)
		tween.start()
		yield(tween, "tween_completed")
		music_player.stop()
	
	#
	#_set_music_player_volume(0)
	tween.interpolate_method(self, "_set_music_player_volume", 0, 1, fade_length/2.0, Tween.TRANS_LINEAR)
	tween.start()
	
	music_player.set_stream(music_path)
	music_player.play()
	emit_signal("music_changed")
	current_music_stream = music_player.get_stream()
	
	yield(tween, "tween_completed")
	
	#
	#animation_player.play("music_fade_in")
	#yield(animation_player, "finished")
		
	is_changing_music = false
	

func _set_music_player_volume(volume: float) -> void:
	music_player.volume_db = linear2db(volume)

func set_master_bus_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_id, linear2db(volume))

func set_music_bus_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_id, linear2db(volume))

func set_sound_effect_bus_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(sound_effect_bus_id, linear2db(volume))

func SetBusVolume(bus: String, volume: float) -> void:
	AudioServer.set_bus_volume_db(bus_dictionary[bus], linear2db(volume))
