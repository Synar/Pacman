extends Node


func create_audio_stream_player(bus, stream, volume_db):
    var audio_stream_player = AudioStreamPlayer.new()
    self.add_child(audio_stream_player)
    audio_stream_player.bus = bus
    audio_stream_player.stream = stream
    audio_stream_player.volume_db = volume_db
    audio_stream_player.play()
    return audio_stream_player


func play_sfx(stream, volume_db = 0.0):
    var audio_stream_player = create_audio_stream_player("SFX", stream, volume_db)
    audio_stream_player.connect("finished", audio_stream_player, "queue_free")


func play_sfx_queue(stream_list, volume_db = 0.0):
    var audio_stream_player
    for stream in stream_list:
        audio_stream_player = create_audio_stream_player("SFX", stream, volume_db)
        yield(audio_stream_player, "finished")
    audio_stream_player.queue_free()

var music_stream_player = AudioStreamPlayer.new()

#func _ready():
#    add_child(music_stream_player)


func play_music_once(stream, volume_db = 0.0):
    if music_stream_player.stream == stream and music_stream_player.playing:
        return
    music_stream_player = create_audio_stream_player("Music", stream, volume_db)


func play_music_loop(stream, volume_db = 0.0):
    if music_stream_player.playing and music_stream_player.stream == stream:
        return
    music_stream_player = create_audio_stream_player("Music", stream, volume_db)
    music_stream_player.connect("finished", self, "play_music_loop", [stream, volume_db])
