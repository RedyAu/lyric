import 'package:flutter_test/flutter_test.dart';
import 'package:sofar/data/song/song.dart';
import 'package:sofar/services/songs/filter.dart';
import 'package:sofar/ui/base/songs/widgets/filter/types/field_type.dart';

void main() {
  group('existingFilterableFields', () {
    Song buildSong({
      required String uuid,
      required String title,
      String? key,
      Map<String, dynamic> extra = const {},
    }) {
      return Song.fromBankApiJson({
        'uuid': uuid,
        'title': title,
        'lyrics': '<song><lyrics>$title</lyrics></song>',
        'key': key,
        ...extra,
      });
    }

    test('does not add a key filter when no songs have a key', () async {
      final songs = [
        buildSong(uuid: 'song-1', title: 'Song 1'),
        buildSong(uuid: 'song-2', title: 'Song 2'),
      ];

      final fields = buildExistingFilterableFields(songs);

      expect(fields.containsKey('key'), isFalse);
    });

    test(
      'adds a key filter from Song.keyField and counts populated songs',
      () async {
        final songs = [
          buildSong(uuid: 'song-1', title: 'Song 1', key: 'C-major'),
          buildSong(uuid: 'song-2', title: 'Song 2'),
          buildSong(uuid: 'song-3', title: 'Song 3', key: 'C-major'),
        ];

        final fields = buildExistingFilterableFields(songs);

        expect(fields.containsKey('key'), isTrue);
        expect(fields['key']?.type, equals(FieldType.key));
        expect(fields['key']?.count, equals(2));
      },
    );
  });
}
