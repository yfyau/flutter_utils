import 'dart:async';
import 'dart:io';
import 'dart:convert';

main() async {
  // Already print out in build.command
  // print("Enter stage DEV (D) / UAT (U) / PROD (P) :");

  String newStage = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));

  switch (newStage) {
    case 'd':
    case 'D':
      newStage = 'DEV';
      break;

    case 'u':
    case 'U':
      newStage = 'UAT';
      break;

    case 'p':
    case 'P':
      newStage = 'PROD';
      break;
  }

  const JsonEncoder prettier = JsonEncoder.withIndent('  ');

  String projectPath = Directory.current.parent.path;
  String buildEnvPath = projectPath + '/lib/buildEnv';

  File commonEnv = File(buildEnvPath + '/common.json');
  String commonStr = await commonEnv.readAsString();

  Map commonJson = json.decode(commonStr);

  String originalStage = commonJson['stage'];
  commonJson['stage'] = newStage;

  commonStr = prettier.convert(commonJson);

  commonEnv.writeAsStringSync(commonStr);
}
