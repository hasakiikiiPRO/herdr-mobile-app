import 'package:flutter_test/flutter_test.dart';
import 'package:client/utils/terminal_history.dart';

void main() {
  List<String> rows(int from, int to) =>
      [for (var i = from; i < to; i++) 'row $i'];

  test('split drops trailing newline only', () {
    expect(splitTerminalLines(''), isEmpty);
    expect(splitTerminalLines('a\nb\n'), ['a', 'b']);
    expect(splitTerminalLines('a\n\nb'), ['a', '', 'b']);
  });

  test('tail stitched onto history keeps rows above the overlap', () {
    final old = [...rows(0, 1000), 'spinner ⠋', '> input'];
    final tail = [...rows(900, 1010), 'spinner ⠙', '> input'];
    final merged = mergeTerminalTail(old, tail)!;
    expect(merged.first, 'row 0');
    expect(merged.length, 1012);
    expect(merged.sublist(merged.length - 2), ['spinner ⠙', '> input']);
  });

  test('anchor skips leading blank rows', () {
    final old = ['top', 'a', '', 'b', 'c', 'd', 'e', 'f', 'g', 'x'];
    final tail = ['', '\x1B[0m', 'b', 'c', 'd', 'e', 'f', 'g', 'y', 'z'];
    final merged = mergeTerminalTail(old, tail)!;
    // The two leading blank tail rows line up with 'a', '' above 'b'.
    expect(merged, ['top', ...tail]);
  });

  test('no overlap returns null so caller does a full read', () {
    expect(mergeTerminalTail(rows(0, 50), rows(200, 260)), isNull);
  });

  test('empty history takes the read; result trimmed to max', () {
    expect(mergeTerminalTail(const [], rows(0, 3)), rows(0, 3));
    final merged =
        mergeTerminalTail(rows(0, 100), rows(90, 120), maxLines: 50)!;
    expect(merged.length, 50);
    expect(merged.last, 'row 119');
  });
}
