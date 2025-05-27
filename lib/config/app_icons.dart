abstract final class AppIcons {
  static final icons = _FolderIcons();
}

abstract class _Folder {
  String get(String file) => '${_path()}/$file';

  String _path();
}

final class _FolderIcons extends _Folder {
  @override
  String _path() => 'assets/icons';

  late String logo = get('logo.svg');
  late String github = get('github.svg');
}
