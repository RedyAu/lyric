import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final root = Directory.current;
  final packageConfigFile = File('${root.path}/.dart_tool/package_config.json');

  if (!await packageConfigFile.exists()) {
    stderr.writeln(
      'Missing .dart_tool/package_config.json. Run `flutter pub get` first.',
    );
    exitCode = 1;
    return;
  }

  final packageConfig =
      jsonDecode(await packageConfigFile.readAsString())
          as Map<String, dynamic>;
  final packages = packageConfig['packages'] as List<dynamic>;

  final driftPackage = packages.cast<Map<String, dynamic>>().firstWhere(
    (package) => package['name'] == 'drift',
    orElse: () => throw StateError('The `drift` package is not available.'),
  );

  final driftRoot = Directory.fromUri(
    Uri.parse(driftPackage['rootUri'] as String),
  );
  final sqlite3Wasm = File(
    '${driftRoot.path}/extension/devtools/build/sqlite3.wasm',
  );
  final webDir = Directory('${root.path}/web');
  final targetWasm = File('${webDir.path}/sqlite3.wasm');
  final targetWorker = File('${webDir.path}/drift_worker.js');

  if (!await sqlite3Wasm.exists()) {
    stderr.writeln('Could not find sqlite3.wasm in ${sqlite3Wasm.path}.');
    exitCode = 1;
    return;
  }

  await targetWasm.parent.create(recursive: true);
  await sqlite3Wasm.copy(targetWasm.path);

  final compileResult = await Process.run(Platform.resolvedExecutable, [
    'compile',
    'js',
    '${webDir.path}/drift_worker.dart',
    '-o',
    targetWorker.path,
  ]);

  stdout.write(compileResult.stdout);
  stderr.write(compileResult.stderr);

  if (compileResult.exitCode != 0) {
    exitCode = compileResult.exitCode;
    return;
  }

  stdout.writeln('Prepared web drift assets in ${webDir.path}.');
}
