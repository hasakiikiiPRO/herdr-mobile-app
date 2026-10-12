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

  RelayAgent a(String title, {String agent = 'pi', String? cwd, String? tabLabel}) =>
      RelayAgent.fromJson({
        'pane_id': 'w4:p27',
        'agent': agent,
        'cwd': cwd ?? '/home/u/cc',
        'terminal_title': title,
        if (tabLabel != null) 'tab_label': tabLabel,
      });

  test('tab_label wins over folder·paneId and generic titles', () {
    expect(a('π - cc', tabLabel: 'test').primaryLabel(), 'test');
    expect(a('π - cc', tabLabel: '8').primaryLabel(lastPrompt: 'fix'), '8');
    expect(a('π - cc', tabLabel: '18').primaryLabel(), '18');
  });

  test('generic titles fall back to cwd + prompt / pane id', () {
    expect(a('π - cc').primaryLabel(), 'cc · p27');
    expect(a('π - cc').primaryLabel(lastPrompt: 'fix bug\nmore'), 'cc · fix bug');
    expect(a('u@host: ~/cc').primaryLabel(), 'cc · p27');
    expect(a('✳ GNOME 顶栏消失', agent: 'claude').primaryLabel(), 'GNOME 顶栏消失');
  });

  test('folderHint used when cwd missing; never bare agent name', () {
    final noCwd = RelayAgent.fromJson({
      'pane_id': 'w4:p27',
      'agent': 'pi',
      'terminal_title': 'π - cc',
    });
    // Folder taken from `π - cc` title when cwd is missing.
    expect(noCwd.primaryLabel(), 'cc · p27');
    expect(noCwd.primaryLabel(folderHint: 'CC'), 'cc · p27');
    expect(noCwd.secondaryLabel('idle'), 'pi · idle');
  });

  test('primary is never just the agent name', () {
    // Even if somehow title collapses, primary stays distinct.
    final bare = RelayAgent.fromJson({
      'pane_id': 'w4:p2C',
      'agent': 'claude',
    });
    expect(bare.primaryLabel(), isNot('claude'));
    expect(bare.primaryLabel(folderHint: 'CC'), 'CC · p2C');
  });

  test('plain terminal uses tab_label when present', () {
    final pane = RelayAgent(
      id: 'w4:p10',
      agent: 'w4:p10',
      status: 'unknown',
      isPlainTerminal: true,
      tabLabel: '10',
    );
    expect(pane.primaryLabel(), '10');
  });
}
