import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';

/// Events that can come from external sources (e.g., remote collaborators)
sealed class CueSourceEvent {
  const CueSourceEvent();
}

/// Slides were changed externally
class SlidesChangedEvent extends CueSourceEvent {
  final List<Slide> slides;
  const SlidesChangedEvent(this.slides);
}

/// Current slide selection changed externally
class CurrentSlideChangedEvent extends CueSourceEvent {
  final String slideUuid;
  const CurrentSlideChangedEvent(this.slideUuid);
}

/// Cue metadata changed externally
class CueMetadataChangedEvent extends CueSourceEvent {
  final Cue cue;
  const CueMetadataChangedEvent(this.cue);
}

/// Abstract source for cue data - can be local DB or remote connection
abstract class CueSource {
  /// Fetch cue metadata
  Future<Cue> fetchCue();

  /// Persist the current in-memory cue state to the source.
  Future<void> persistCue(Cue cue);

  /// Stream of external changes (for remote: other devices' edits)
  /// Local source returns empty stream since we control all writes
  Stream<CueSourceEvent> get externalChanges;

  /// Cleanup resources
  void dispose();
}
