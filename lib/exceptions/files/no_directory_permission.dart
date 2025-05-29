class NoDirectoryPermission implements Exception {
  @override
  String toString() => 'Dont have enough permission to pick directories';
}
