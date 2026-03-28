import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/centered_hint.dart';

import '../../../data/cue/slide.dart';
import '../slide_views/song.dart';
import '../slide_views/unknown.dart';
import '../session/session_provider.dart';

class SlideView extends ConsumerStatefulWidget {
  const SlideView({super.key, this.onTabControllerCreated});

  final VoidCallback? onTabControllerCreated;

  @override
  ConsumerState<SlideView> createState() => _SlideViewState();
}

class _SlideViewState extends ConsumerState<SlideView>
    with TickerProviderStateMixin {
  TabController? tabController;
  List<String> slideUuids = const [];
  String cueUuid = '';

  @override
  void initState() {
    super.initState();
    replaceSlideDeck(ref.read(slideDeckProvider));

    ref.listenManual(slideDeckProvider, (_, nextDeck) {
      if (!mounted) return;
      replaceSlideDeck(nextDeck, notify: true);
    });

    ref.listenManual(currentSlideUuidProvider, (_, nextSlideUuid) {
      animateToCurrentSlide(nextSlideUuid);
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  void replaceSlideDeck(CueSlideDeckState deck, {bool notify = false}) {
    final previousController = tabController;
    final nextController = createTabController(deck);

    void updateState() {
      slideUuids = deck.slideUuids;
      cueUuid = deck.cueUuid;
      tabController = nextController;
    }

    if (notify) {
      setState(updateState);
    } else {
      updateState();
    }

    previousController?.dispose();
  }

  TabController? createTabController(CueSlideDeckState deck) {
    if (deck.slideUuids.isEmpty) return null;

    final controller = TabController(
      length: deck.slideUuids.length,
      initialIndex: currentIndexFor(
        ref.read(currentSlideUuidProvider),
        inSlideUuids: deck.slideUuids,
      ),
      vsync: this,
    );
    controller.animation?.addListener(onTabAnimationChanged);
    widget.onTabControllerCreated?.call();
    return controller;
  }

  int currentIndexFor(
    String? currentSlideUuid, {
    required List<String> inSlideUuids,
  }) {
    if (inSlideUuids.isEmpty) return 0;

    final index = currentSlideUuid == null
        ? -1
        : inSlideUuids.indexOf(currentSlideUuid);
    return index < 0 ? 0 : index.clamp(0, inSlideUuids.length - 1);
  }

  void animateToCurrentSlide(String? currentSlideUuid) {
    final controller = tabController;
    if (controller == null || currentSlideUuid == null || slideUuids.isEmpty) {
      return;
    }

    final targetIndex = slideUuids.indexOf(currentSlideUuid);
    if (targetIndex == -1 || targetIndex == controller.index) return;

    controller.animateTo(targetIndex);
  }

  void syncCurrentSlideToController(int index) {
    final controller = tabController;
    if (controller == null || slideUuids.isEmpty) return;
    if (index < 0 || index >= slideUuids.length) return;

    final nextSlideUuid = slideUuids[index];
    final session = ref.read(activeCueSessionProvider).value;
    if (session == null || session.currentSlideUuid == nextSlideUuid) return;

    ref.read(activeCueSessionProvider.notifier).goToSlide(nextSlideUuid);
  }

  void onTabAnimationChanged() {
    final controller = tabController;
    final animationValue = controller?.animation?.value;
    if (controller == null || animationValue == null || slideUuids.isEmpty) {
      return;
    }
    if (controller.indexIsChanging) return;

    final settledIndex = animationValue.round();
    if ((animationValue - settledIndex).abs() > 0.0001) return;

    syncCurrentSlideToController(settledIndex);
  }

  @override
  Widget build(BuildContext context) {
    final controller = tabController;

    return Theme(
      data: Theme.of(context),
      child: Hero(
        tag: 'SlideView',
        child: slideUuids.isEmpty
            ? CenteredHint(
                'Keress és adj hozzá dalokat a listához a Daltár oldalon',
                iconData: Icons.library_music,
              )
            : controller == null
            ? const SizedBox.shrink()
            : TabBarView(
                controller: controller,
                children: slideUuids
                    .map(
                      (slideUuid) => _LiveSlidePage(
                        key: ValueKey('$cueUuid/$slideUuid'),
                        slideUuid: slideUuid,
                        cueUuid: cueUuid,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}

class _LiveSlidePage extends ConsumerWidget {
  const _LiveSlidePage({
    required this.slideUuid,
    required this.cueUuid,
    super.key,
  });

  final String slideUuid;
  final String cueUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slide = ref.watch(slideSnapshotProvider(slideUuid)).slide;

    if (slide == null) {
      return const SizedBox.shrink();
    }

    return switch (slide) {
      SongSlide songSlide => SongSlideView(songSlide, cueUuid),
      UnknownTypeSlide unknownSlide => UnknownTypeSlideView(unknownSlide),
    };
  }
}
