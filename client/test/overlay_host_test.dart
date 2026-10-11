import 'package:flutter_test/flutter_test.dart';
import 'package:client/models/pair_config.dart';

void main() {
  test('overlay hosts are remote-capable', () {
    expect(PairConfig.isOverlayHost('10.126.126.3'), isTrue);
    expect(PairConfig.isOverlayHost('100.64.0.1'), isTrue);
    expect(PairConfig.isOverlayHost('100.127.255.1'), isTrue);
    expect(PairConfig.isOverlayHost('100.128.0.1'), isFalse);
    expect(PairConfig.isOverlayHost('192.168.1.5'), isFalse);
    expect(PairConfig.isOverlayHost('10.0.0.5'), isFalse);
    expect(PairConfig.isOverlayHost('172.16.0.1'), isFalse);
  });
}
