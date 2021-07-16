import 'dart:async';
import 'dart:io';
import 'dart:convert';

main() async {
  String projectPath = Directory.current.parent.path;

  var pResult = await Process.run('git', ['tag', '-l']);
  String pOut = pResult.stdout;

  List<String> tags = pOut.split('\n');
  List<String> versions = [];

  for (String t in tags) {
    List<String> tagSplit = t.split('_');

    if (tagSplit.length != 2) continue;

    versions.add(tagSplit[1]);
  }

  versions.sort((a, b) => b.compareTo(a));

  String latest = versions[0] ?? 'v1.0.0+1';
  String latestVersion = latest.split('+')[0].replaceFirst('v', '');
  String latestBuild = (int.parse(latest.split('+')[1]) + 1).toString();

  latest = latestVersion + '+' + latestBuild;

  RegExp regExp = RegExp(r"^(version:\s+\d+\.\d+\.\d+\+)(\d+)$", multiLine: true);

  File pubspecFile = File(projectPath + '/pubspec.yaml');
  String pubspecStr = pubspecFile.readAsStringSync();

  pubspecStr = pubspecStr.replaceFirstMapped(regExp, (match) => 'version: $latest');

  pubspecFile.writeAsStringSync(pubspecStr);

  print(latest);
}
