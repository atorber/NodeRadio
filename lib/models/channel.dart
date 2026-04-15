import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Channel {
  final String id;
  final String name;
  final String url;
  final ChannelType type;
  final DateTime createdAt;

  Channel({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Detect channel type from URL
  static ChannelType detectType(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('meetings.feishu.cn') || lower.contains('feishu.cn')) {
      return ChannelType.feishu;
    } else if (lower.contains('.m3u8')) {
      return ChannelType.hls;
    } else if (lower.startsWith('rtmp://')) {
      return ChannelType.rtmp;
    } else if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return ChannelType.web;
    }
    return ChannelType.unknown;
  }

  /// Whether this channel should be opened in a WebView
  bool get isWebPlayable =>
      type == ChannelType.feishu || type == ChannelType.web;

  String get typeLabel {
    switch (type) {
      case ChannelType.feishu:
        return '飞书直播';
      case ChannelType.hls:
        return 'HLS 流';
      case ChannelType.rtmp:
        return 'RTMP 流';
      case ChannelType.web:
        return 'Web 播放';
      case ChannelType.unknown:
        return '未知';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'type': type.index,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json['id'],
        name: json['name'],
        url: json['url'],
        type: ChannelType.values[json['type']],
        createdAt: DateTime.parse(json['createdAt']),
      );
}

enum ChannelType { feishu, hls, rtmp, web, unknown }

/// Simple persistence for channels
class ChannelStore {
  static const _key = 'channels';

  static Future<List<Channel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Channel.fromJson(e)).toList();
  }

  static Future<void> save(List<Channel> channels) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode(channels.map((e) => e.toJson()).toList()));
  }

  static Future<void> add(Channel channel) async {
    final channels = await load();
    channels.add(channel);
    await save(channels);
  }

  static Future<void> remove(String id) async {
    final channels = await load();
    channels.removeWhere((c) => c.id == id);
    await save(channels);
  }
}
