import 'package:drift/drift.dart';

import '../../../data/cue/cue.dart';
import '../../../data/database.dart';
import '../write_cue.dart';
import 'cue_source.dart';

/// Local database-backed cue source
class LocalCueSource implements CueSource {
  final String cueUuid;

  LocalCueSource(this.cueUuid);

  @override
  Future<Cue> fetchCue() async {
    final cue = await (db.cues.select()..where((c) => c.uuid.equals(cueUuid)))
        .getSingleOrNull();

    if (cue == null) {
      throw Exception('Nem található lista az azonosítóval: $cueUuid');
    }
    return cue;
  }

  @override
  Future<void> persistCue(Cue cue) async {
    await writeCue(cue);
  }

  @override
  Stream<CueSourceEvent> get externalChanges => const Stream.empty();
  // Local source doesn't have external changes - we control all writes

  @override
  void dispose() {
    // No resources to clean up for local source
  }
}
