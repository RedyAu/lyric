import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/song/song.dart';

part 'from_uuid.g.dart';

@riverpod
Future<Song> songFromUuid(Ref ref, String uuid) async {
  Song? songOrNull = await dbSongFromUuid(uuid);
  if (songOrNull == null) {
    throw Exception("Úgy tűnik, ez a dal nincs a táradban: $uuid");
  } else {
    return songOrNull;
  }
}

Future<Song?> dbSongFromUuid(String uuid) async {
  return (await (db.songs.select()..where((s) => s.uuid.equals(uuid)))
      .getSingleOrNull());
}

Future<String> resolveSongUuidFromPrefix(String prefix) async {
  final matches =
      await (db.songs.select()..where((s) => s.uuid.like('$prefix-%'))).get();

  if (matches.isEmpty) {
    throw Exception('Nincs dal ilyen rövidített UUID előtaggal: $prefix');
  }

  if (matches.length > 1) {
    throw Exception('Több dal illeszkedik erre a UUID előtagra: $prefix');
  }

  return matches.single.uuid;
}
