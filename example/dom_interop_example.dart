library dom_interop.example;

import 'dart:html';

import 'package:dom_interop/dom_interop.dart';

main() {
  document.querySelector('#text').onClick.listen((event) {
    final position = caretPositionFromPoint(event.client);
    document.querySelector('#content').innerHtml =
        '{offsetNode: ${position.offsetNode}, offset: ${position.offset}}';
  });
}
