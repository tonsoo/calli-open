abstract final class AppIcons {
  static final icons = _Icons();
}

abstract class _Folder {
  String get(String file) => '${_path()}/$file';

  String _path();
}

final class _Icons extends _Folder {
  @override
  String _path() => 'assets/icons';

  late String logo = get('logo.svg');
  late String github = get('github.svg');
  late String user = get('user.svg');
  late String home = get('home.svg');
  late String search = get('search.svg');
  late String menu = get('menu.svg');

  final arrows = _IconsArrows();
  final buttons = _IconsButton();
}

final class _IconsArrows extends _Folder {
  @override
  String _path() => 'assets/icons/arrows';

  late String back = get('back.svg');
  late String down = get('down.svg');
}

final class _IconsButton extends _Folder {
  @override
  String _path() => 'assets/icons/buttons';

  late String play = get('play.svg');
}
