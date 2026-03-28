import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';

/// Session wrapper around the single live Cue object currently being edited.
class CueSession {
  final Cue cue;
  final String? currentSlideUuid;

  const CueSession({required this.cue, this.currentSlideUuid});

  List<Slide> get slides => cue.slides;

  /// Get the currently selected slide, if any
  Slide? get currentSlide {
    if (currentSlideUuid == null) return null;
    return cue.slideByUuid(currentSlideUuid!);
  }

  /// Get the index of the current slide (null if none selected or not found)
  int? get currentIndex {
    if (currentSlideUuid == null) return null;
    final index = slides.indexWhere((s) => s.uuid == currentSlideUuid);
    return index == -1 ? null : index;
  }

  /// Whether there's a next slide to navigate to
  bool get hasNext => (currentIndex ?? -1) < slides.length - 1;

  /// Whether there's a previous slide to navigate to
  bool get hasPrevious => (currentIndex ?? 0) > 0;

  /// Total number of slides
  int get slideCount => cue.slideCount;

  /// Create copy with different current slide
  CueSession withCurrentSlide(String? uuid) =>
      CueSession(cue: cue, currentSlideUuid: uuid);

  /// Create a new session wrapper after mutating the live cue object.
  CueSession refreshed() =>
      CueSession(cue: cue, currentSlideUuid: currentSlideUuid);
}
