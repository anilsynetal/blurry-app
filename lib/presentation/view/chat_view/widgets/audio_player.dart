
// widgets/audio_player_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/typography.dart';


class AudioPlayerWidget extends StatefulWidget {
  final String? audioPath;
  final String? audioUrl;
  final bool isCurrentUser;
  final Duration duration;

  const AudioPlayerWidget({
    Key? key,
    this.audioPath,
    this.audioUrl,
    this.isCurrentUser = false,
    this.duration = Duration.zero,
  }) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
    if(mounted){
      setState(() {
        _isPlaying = state == PlayerState.playing;
        // _isLoading = state == PlayerState.loading || state == PlayerState.buffering;
      });
    }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      try {
        if (widget.audioPath != null && File(widget.audioPath!).existsSync()) {
          await _audioPlayer.play(DeviceFileSource(widget.audioPath!));
        } else if (widget.audioUrl != null) {
          await _audioPlayer.play(UrlSource(widget.audioUrl!));
        }
      } catch (e) {
        print('Error playing audio: $e');
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: widget.isCurrentUser
            ? AppThemeNotifier.background
            : Color(0xFFFFE7E0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(
            widget.isCurrentUser ? 18 : 4,
          ),
          bottomRight: Radius.circular(
            widget.isCurrentUser ? 4 : 18,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color:
                     AppThemeNotifier.primarySet2
                   ,
                shape: BoxShape.circle,
              ),
              child: _isLoading
                  ? Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
                  : Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 12),
          // Waveform visualization (simplified)
          Container(
            width: 120,
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                15,
                    (index) => Container(
                  width: 2,
                  height: _isPlaying
                      ? (10.0 + (index % 3) * 5.0 +
                      (index % 2 == 0 ? 5.0 : 0.0))
                      : (10.0 + (index % 3) * 3.0),
                  margin: EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color:AppThemeNotifier.primarySet2,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          // Duration text
          Text(
            _formatDuration(widget.duration),
            style: TextStyles.labelSmall.copyWith(
              color: widget.isCurrentUser
                  ? Color(0xFF1F2937)
                  : Color(0xFF6B1F17),
            ),
          ),
        ],
      ),
    );
  }
}