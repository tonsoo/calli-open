import 'package:calliopen/components/buttons/default_button.dart';
import 'package:calliopen/components/generic/github_project.dart';
import 'package:calliopen/config/app_colors.dart';
import 'package:calliopen/config/app_icons.dart';
import 'package:calliopen/models/track.dart';
import 'package:calliopen/notifiers/preferences_notifier.dart';
import 'package:calliopen/notifiers/track_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SongsDashboardScreen extends StatelessWidget {
  const SongsDashboardScreen({super.key});

  static const path = '/songs';

  static const animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final tracks = context.watch<TrackNotifier>();
    return Scaffold(
      backgroundColor: context.themed(
        light: AppColors.white,
        dark: AppColors.black,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: RefreshIndicator(
                onRefresh: context.read<TrackNotifier>().loadFromDirectories,
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(),
                        SizedBox(height: 26),
                        _TitleWithItems(
                          title: 'Most listened',
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 17,
                                children: [
                                  for (final track in tracks.tracks)
                                    _SongItem(track: track),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: context.themed(
                        light: AppColors.orangeMid,
                        dark: AppColors.main,
                      ),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (tracks.currentTrack != null) CurrentTrack(),
                    Menu(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.themed(
          light: AppColors.orangeWeak,
          dark: AppColors.black100,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 21,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 109,
        children: [
          _MenuItem(
            icon: AppIcons.icons.home,
            onPressed: () async =>
                context.read<TrackNotifier>().loadLocalTracks(context),
            selected: true,
          ),
          _MenuItem(
            icon: AppIcons.icons.search,
            onPressed: () async => {},
          ),
          _MenuItem(
            icon: AppIcons.icons.menu,
            onPressed: () async => {},
          ),
        ],
      ),
    );
  }
}

class CurrentTrack extends StatelessWidget {
  const CurrentTrack({super.key});

  @override
  Widget build(BuildContext context) {
    final tracks = context.read<TrackNotifier>();
    final size = MediaQuery.of(context).size;
    final percentageSize = (size.width * tracks.currentTrackProgress)
        .clamp(0, size.width)
        .toDouble();
    return DefaultButton(
      onPressed: () async => {},
      buttonStyle: TextButton.styleFrom(
        backgroundColor: context.themed(
          light: AppColors.orangeWeak,
          dark: AppColors.black100,
        ),
        foregroundColor: context.themed(
          light: AppColors.black,
          dark: AppColors.white,
        ),
        padding: EdgeInsets.all(0),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 9,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.themed(
                      light: AppColors.black,
                      dark: AppColors.white,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: tracks.currentTrack?.picture != null
                        ? Image.memory(
                            tracks.currentTrack!.picture!.data,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 4,
                    children: [
                      Text(
                        tracks.currentTrack?.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.themed(
                            light: AppColors.black,
                            dark: AppColors.white,
                          ),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        tracks.currentTrack?.author ?? '-',
                        style: TextStyle(
                          color: context.themed(
                            light: AppColors.orangeMid,
                            dark: AppColors.main,
                          ),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8)
                    ],
                  ),
                ),
                IntrinsicWidth(
                  child: DefaultButton(
                    onPressed: () async => tracks.toggle(),
                    buttonStyle: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        vertical: 11,
                        horizontal: 15,
                      ),
                    ),
                    child: SvgPicture.asset(
                      tracks.playing
                          ? AppIcons.icons.buttons.pause
                          : AppIcons.icons.buttons.play,
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                      color: context.themed(
                        light: AppColors.main,
                        dark: AppColors.orangeMid,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.themed(
                light: AppColors.whiteMid,
                dark: AppColors.white,
              ),
            ),
            height: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: SongsDashboardScreen.animationDuration,
                decoration: BoxDecoration(
                  color: context.themed(
                    light: AppColors.orangeMid,
                    dark: AppColors.orangeMid,
                  ),
                ),
                width: percentageSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.onPressed,
    this.selected = false,
  });

  final String icon;
  final Future<void> Function() onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: DefaultButton(
        onPressed: onPressed,
        buttonStyle: TextButton.styleFrom(
          backgroundColor: context.themed(
            light: AppColors.orangeWeak,
            dark: AppColors.black100,
          ),
          foregroundColor: context.themed(
            light: AppColors.orangeWeak,
            dark: AppColors.main,
          ),
          padding: EdgeInsets.all(0),
        ),
        child: SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
          color: selected
              ? context.themed(
                  light: AppColors.main,
                  dark: AppColors.orangeMid,
                )
              : context.themed(
                  light: AppColors.orangeMid,
                  dark: AppColors.main,
                ),
        ),
      ),
    );
  }
}

class _SongItem extends StatelessWidget {
  const _SongItem({required this.track});

  final Track track;

  @override
  Widget build(BuildContext context) {
    final tracks = context.read<TrackNotifier>();
    final playing = tracks.currentTrack == track;

    String time = '';
    if (playing) {
      final totalSeconds = tracks.currentTrackDuration.inSeconds;
      int minutes = (totalSeconds / 60).round();
      int seconds = (totalSeconds % 60).round();
      time = '$minutes:${seconds.toString().padLeft(2, '0')}';
    }

    return IntrinsicWidth(
      child: DefaultButton(
        onPressed: () async {
          if (!playing) {
            tracks.play(track);
          } else {
            tracks.toggle();
          }
        },
        buttonStyle: TextButton.styleFrom(
          backgroundColor: context.themed(
            light: AppColors.white,
            dark: AppColors.black,
          ),
          foregroundColor: context.themed(
            light: AppColors.black,
            dark: AppColors.white,
          ),
          padding: EdgeInsets.all(0),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: playing
                  ? BorderSide(
                      width: 1,
                      color: context.themed(
                        light: AppColors.main,
                        dark: AppColors.orangeMid,
                      ),
                    )
                  : BorderSide.none,
            ),
          ),
          padding: EdgeInsets.only(bottom: 11),
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.themed(
                      light: AppColors.whiteMid,
                      dark: AppColors.black100,
                    ),
                  ),
                  child: track.picture != null
                      ? Image.memory(
                          track.picture!.data,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 7,
                children: [
                  Expanded(
                    child: Text(
                      track.author,
                      style: TextStyle(
                        color: context.themed(
                          light: AppColors.whiteMid,
                          dark: AppColors.main,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IntrinsicWidth(
                    child: Text(
                      track.formattedDuration,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.themed(
                          light: AppColors.black,
                          dark: AppColors.white,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                track.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.themed(
                    light: playing ? AppColors.main : AppColors.black,
                    dark: playing ? AppColors.orangeWeak : AppColors.white,
                  ),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (playing) SizedBox(height: 6),
              if (playing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 6,
                  children: [
                    IntrinsicWidth(
                      child: Text(
                        time,
                        style: TextStyle(
                          color: context.themed(
                            light: AppColors.main,
                            dark: AppColors.orangeMid,
                          ),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      tracks.playing
                          ? AppIcons.icons.buttons.pause
                          : AppIcons.icons.buttons.play,
                      width: 12,
                      height: 12,
                      fit: BoxFit.contain,
                      color: context.themed(
                        light: AppColors.main,
                        dark: AppColors.orangeMid,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                      ),
                      height: 2,
                      width: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: SongsDashboardScreen.animationDuration,
                          decoration: BoxDecoration(
                            color: AppColors.orangeMid,
                          ),
                          width:
                              (30 * tracks.currentTrackProgress).clamp(0, 30),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleWithItems extends StatelessWidget {
  const _TitleWithItems({
    required this.title,
    this.children = const [],
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 11,
      children: [
        Text(
          title,
          style: TextStyle(
            color: context.themed(
              light: AppColors.black,
              dark: AppColors.white,
            ),
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        for (final child in children) child,
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: context.themed(
              light: AppColors.main,
              dark: AppColors.main,
            ),
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          _HeaderLogo(),
          Container(
            decoration: BoxDecoration(
              color: context.themed(
                light: AppColors.black,
                dark: AppColors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(180)),
            ),
            padding: EdgeInsets.all(8),
            child: SvgPicture.asset(
              AppIcons.icons.user,
              width: 20,
              height: 20,
              color: context.themed(
                light: AppColors.white,
                dark: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        spacing: 14,
        children: [
          SvgPicture.asset(
            AppIcons.icons.logo,
            width: 39,
            height: 37,
            fit: BoxFit.contain,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calli Open',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IntrinsicWidth(
                child: GitHubProject(
                  buttonStyle: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 0,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
