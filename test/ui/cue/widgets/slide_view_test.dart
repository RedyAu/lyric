import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofar/data/database.dart';
import 'package:sofar/ui/song/state.dart';

import '../../../harness/cue_widget_harness.dart';
import '../../../harness/test_harness.dart';

void main() {
  group('SlideView cue interactions', () {
    late LyricDatabase testDb;
    late TestHarness harness;

    setUp(() async {
      testDb = createTestDatabase();
      db = testDb;
      await db.customStatement('PRAGMA foreign_keys = OFF');
      harness = TestHarness();
    });

    tearDown(() async {
      harness.dispose();
      await testDb.close();
    });

    testWidgets(
      'successive swipes update the rest of the cue UI without recreating the controller',
      (tester) async {
        final cue = await insertCueHarnessCue(
          cueUuid: 'cue-swipe',
          fixtures: const [
            CueSongFixture(
              songUuid: 'song-1',
              slideUuid: 'slide-1',
              title: 'Song 1',
              lyrics: '[V1]\n Alpha line',
            ),
            CueSongFixture(
              songUuid: 'song-2',
              slideUuid: 'slide-2',
              title: 'Song 2',
              lyrics: '[V1]\n Beta line',
            ),
            CueSongFixture(
              songUuid: 'song-3',
              slideUuid: 'slide-3',
              title: 'Song 3',
              lyrics: '[V1]\n Gamma line',
            ),
          ],
        );

        final cueHarness = await pumpCueWidgetHarness(
          tester,
          testHarness: harness,
          cueUuid: cue.uuid,
        );

        expect(find.text('current:slide-1'), findsOneWidget);
        expect(find.text('Alpha line'), findsOneWidget);
        expect(cueHarness.createdControllerCount, 1);

        final pageWidth = tester.getSize(find.byType(PageView)).width;

        await tester.drag(find.byType(PageView), Offset(-(pageWidth * 0.6), 0));
        await tester.pumpAndSettle();

        expect(cueHarness.session.currentSlideUuid, 'slide-2');
        expect(find.text('Beta line'), findsOneWidget);
        expect(cueHarness.createdControllerCount, 1);

        await tester.drag(find.byType(PageView), Offset(-(pageWidth * 0.6), 0));
        await tester.pumpAndSettle();

        expect(cueHarness.session.currentSlideUuid, 'slide-3');
        expect(find.text('Gamma line'), findsOneWidget);
        expect(cueHarness.createdControllerCount, 1);
      },
    );

    testWidgets(
      'outside jump buttons move the tab view without recreating the controller',
      (tester) async {
        final cue = await insertCueHarnessCue(
          cueUuid: 'cue-jump',
          fixtures: const [
            CueSongFixture(
              songUuid: 'song-1',
              slideUuid: 'slide-1',
              title: 'Song 1',
              lyrics: '[V1]\n Alpha line',
            ),
            CueSongFixture(
              songUuid: 'song-2',
              slideUuid: 'slide-2',
              title: 'Song 2',
              lyrics: '[V1]\n Beta line',
            ),
            CueSongFixture(
              songUuid: 'song-3',
              slideUuid: 'slide-3',
              title: 'Song 3',
              lyrics: '[V1]\n Gamma line',
            ),
          ],
        );

        final cueHarness = await pumpCueWidgetHarness(
          tester,
          testHarness: harness,
          cueUuid: cue.uuid,
        );

        cueHarness.jumpToSlide('slide-3');
        await tester.pumpAndSettle();

        expect(cueHarness.session.currentSlideUuid, 'slide-3');
        expect(find.text('Gamma line'), findsOneWidget);
        expect(cueHarness.createdControllerCount, 1);
      },
    );

    testWidgets(
      'button navigation changes the active slide without recreating the controller',
      (tester) async {
        final cue = await insertCueHarnessCue(
          cueUuid: 'cue-buttons',
          fixtures: const [
            CueSongFixture(
              songUuid: 'song-1',
              slideUuid: 'slide-1',
              title: 'Song 1',
              lyrics: '[V1]\n Alpha line',
            ),
            CueSongFixture(
              songUuid: 'song-2',
              slideUuid: 'slide-2',
              title: 'Song 2',
              lyrics: '[V1]\n Beta line',
            ),
          ],
        );

        final cueHarness = await pumpCueWidgetHarness(
          tester,
          testHarness: harness,
          cueUuid: cue.uuid,
        );

        await tester.tap(find.byKey(cueHarnessNextButtonKey));
        await tester.pumpAndSettle();

        expect(cueHarness.session.currentSlideUuid, 'slide-2');
        expect(find.text('Beta line'), findsOneWidget);
        expect(cueHarness.createdControllerCount, 1);
      },
    );

    testWidgets(
      'view chooser mutates the current cue slide without recreating the controller',
      (tester) async {
        configureCueHarnessSvgResponse(harness, svgLabel: 'Cue SVG');

        final cue = await insertCueHarnessCue(
          cueUuid: 'cue-view-type',
          fixtures: const [
            CueSongFixture(
              songUuid: 'song-1',
              slideUuid: 'slide-1',
              title: 'Chord Song',
              lyrics: '[V1]\n. C\n Chord line',
              viewType: SongViewType.chords,
              hasSvg: true,
            ),
          ],
        );

        final cueHarness = await pumpCueWidgetHarness(
          tester,
          testHarness: harness,
          cueUuid: cue.uuid,
        );

        expect(find.text('TRANSZPONÁLÁS'), findsOneWidget);
        expect(cueHarness.currentSongSlide.viewType, SongViewType.chords);
        expect(cueHarness.createdControllerCount, 1);

        await tester.tap(find.byIcon(Icons.arrow_drop_down_rounded));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Kotta').last);
        await tester.pumpAndSettle();

        expect(cueHarness.currentSongSlide.viewType, SongViewType.svg);
        expect(find.text('TRANSZPONÁLÁS'), findsNothing);
        expect(cueHarness.createdControllerCount, 1);
      },
    );

    testWidgets(
      'transpose controls mutate the current cue slide without recreating the controller',
      (tester) async {
        final cue = await insertCueHarnessCue(
          cueUuid: 'cue-transpose',
          fixtures: const [
            CueSongFixture(
              songUuid: 'song-1',
              slideUuid: 'slide-1',
              title: 'Chord Song',
              lyrics: '[V1]\n. C\n Chord line',
              viewType: SongViewType.chords,
            ),
          ],
        );

        final cueHarness = await pumpCueWidgetHarness(
          tester,
          testHarness: harness,
          cueUuid: cue.uuid,
        );

        expect(cueHarness.currentSongSlide.transpose, isNull);
        expect(cueHarness.createdControllerCount, 1);

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(cueHarness.currentSongSlide.transpose?.capo, 1);
        expect(find.text('Capo: 1'), findsOneWidget);
        expect(cueHarness.createdControllerCount, 1);
      },
    );

    testWidgets('structural slide list changes recreate the controller once', (
      tester,
    ) async {
      final cue = await insertCueHarnessCue(
        cueUuid: 'cue-structure',
        fixtures: const [
          CueSongFixture(
            songUuid: 'song-1',
            slideUuid: 'slide-1',
            title: 'Song 1',
            lyrics: '[V1]\n Alpha line',
          ),
        ],
      );

      final cueHarness = await pumpCueWidgetHarness(
        tester,
        testHarness: harness,
        cueUuid: cue.uuid,
      );

      cueHarness.addUnknownSlide('slide-unknown');
      await cueHarness.flushWrites();
      await tester.pumpAndSettle();

      expect(cueHarness.session.slideCount, 2);
      expect(
        find.byKey(cueHarnessJumpButtonKey('slide-unknown')),
        findsOneWidget,
      );
      expect(cueHarness.createdControllerCount, 2);
    });
  });
}
