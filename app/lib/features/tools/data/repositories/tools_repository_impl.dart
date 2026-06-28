import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/tool_entry.dart';
import '../../domain/repositories/tools_repository.dart';

@LazySingleton(as: ToolsRepository)
class ToolsRepositoryImpl implements ToolsRepository {
  static const _entries = <ToolEntry>[
    ToolEntry(
      id: 'phrases',
      title: 'Phrase book',
      subtitle: 'Border · Transport · Dining · Medical',
      icon: Icons.translate,
    ),
    ToolEntry(
      id: 'emergency',
      title: 'Emergency contacts',
      subtitle: 'Police · Hospital · Embassy',
      icon: Icons.phone_in_talk,
    ),
    ToolEntry(
      id: 'units',
      title: 'Unit converter',
      subtitle: 'Length · Weight · Temperature',
      icon: Icons.swap_horiz,
    ),
    ToolEntry(
      id: 'timezone',
      title: 'Time zone',
      subtitle: 'US ET vs Shanghai CN',
      icon: Icons.public,
    ),
    ToolEntry(
      id: 'offline',
      title: 'Offline pack',
      subtitle: 'Maps + phrases, ready offline',
      icon: Icons.cloud_off,
    ),
    ToolEntry(
      id: 'translate',
      title: 'Translate assistant',
      subtitle: 'Camera + voice translate',
      icon: Icons.camera_alt,
    ),
  ];

  @override
  List<ToolEntry> entries() => List.unmodifiable(_entries);
}