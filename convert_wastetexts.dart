import 'dart:io';

void main() {
  final root = Directory('c:/Users/HP/Documents/ewastecare');
  final textsFile = File('c:/Users/HP/Documents/ewastecare/lib/utils/constants/texts.dart');
  final exclude = {
    textsFile.path,
    File('c:/Users/HP/Documents/ewastecare/lib/translations/app_translations.dart').path,
  };
  const textImport = "import 'package:get/get.dart';";
  final keyPattern = RegExp(r'static const String\s+([A-Za-z0-9_]+)\s*=');
  final keys = <String>[];
  for (final line in textsFile.readAsLinesSync()) {
    final match = keyPattern.firstMatch(line);
    if (match != null) {
      keys.add(match.group(1)!);
    }
  }
  if (keys.isEmpty) {
    print('No keys found in texts.dart');
    return;
  }
  var changedFiles = <String>[];
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (exclude.contains(entity.path)) continue;
    var content = entity.readAsStringSync();
    if (!content.contains('WasteTexts.')) continue;
    var newContent = content;
    for (final key in keys) {
      final pattern = RegExp(r'WasteTexts\.' + RegExp.escape(key) + r'(?!\.tr)(?![A-Za-z0-9_])');
      newContent = newContent.replaceAll(pattern, 'WasteTexts.$key.tr');
    }
    newContent = newContent.replaceAllMapped(
      RegExp(r'WasteTexts\.[A-Za-z0-9_]+\.tr\.tr'),
      (match) => match.group(0)!.replaceAll('.tr.tr', '.tr'),
    );
    if (newContent == content) continue;
    newContent = newContent.replaceAllMapped(
      RegExp(r'const\s+Text\(\s*(WasteTexts\.[A-Za-z0-9_]+\.tr)'),
      (match) => 'Text(${match.group(1)}',
    );
    newContent = newContent.replaceAllMapped(
      RegExp(r'const\s+TextSpan\(\s*text:\s*(WasteTexts\.[A-Za-z0-9_]+\.tr)'),
      (match) => 'TextSpan(text: ${match.group(1)}',
    );
    if (newContent.contains('.tr') && !newContent.contains(textImport)) {
      final lines = newContent.split('\n');
      final importIndices = [for (var i = 0; i < lines.length; i++) if (lines[i].startsWith('import ')) i];
      if (importIndices.isNotEmpty) {
        lines.insert(importIndices.last + 1, textImport);
        newContent = lines.join('\n');
      } else {
        newContent = '$textImport\n$newContent';
      }
    }
    if (newContent != content) {
      entity.writeAsStringSync(newContent);
      changedFiles.add(entity.path);
    }
  }
  print('changed_files_count= ${changedFiles.length}');
  for (final file in changedFiles) print(file);
}
