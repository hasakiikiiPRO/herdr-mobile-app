import 'package:flutter_test/flutter_test.dart';
import 'package:client/models/relay_agent.dart';
import 'package:client/widgets/ansi_terminal.dart';

void main() {
  test('rule-only lines are dropped, text lines kept', () {
    const t = 'hello\n\x1B[31m────────────\x1B[0m\n──────\n── Working ──\nbye';
    final out = dropTerminalRuleLines(t);
    expect(out.replaceAll(RegExp(r'\x1B\[[0-9;]*m'), ''),
        'hello\n── Working ──\nbye');
    expect(out.contains('\x1B[31m'), isTrue);
  });

  RelayAgent a(String title, {String agent = 'pi'}) => RelayAgent.fromJson({
        'pane_id': 'w4:p27', 'agent': agent, 'cwd': '/home/u/cc',
        'terminal_title': title,
      });

  test('generic titles fall back to cwd + prompt / pane id', () {
    expect(a('π - cc').primaryLabel(), 'cc · p27');
    expect(a('π - cc').primaryLabel(lastPrompt: 'fix bug\nmore'), 'cc · fix bug');
    expect(a('u@host: ~/cc').primaryLabel(), 'cc · p27');
    expect(a('✳ GNOME 顶栏消失', agent: 'claude').primaryLabel(), 'GNOME 顶栏消失');
  });
}
