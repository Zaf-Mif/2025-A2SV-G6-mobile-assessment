// test/fixtures/fixture_reader.dart

import 'dart:io';

String fixture(String name) =>
    File('test/helpers/fixtures/$name').readAsStringSync();
