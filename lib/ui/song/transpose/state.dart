import 'package:flutter_riverpod/legacy.dart';

import '../../../data/song/song.dart';
import '../../../data/song/transpose.dart';

final transposeStateForProvider = StateProvider.family<SongTranspose, Song>((
  ref,
  song,
) {
  return SongTranspose();
});
