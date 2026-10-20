// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Herdr Mobile';

  @override
  String get tabSpaces => '工作区';

  @override
  String get tabAgents => '助手';

  @override
  String get tabRun => '运行';

  @override
  String get tabSettings => '设置';

  @override
  String get online => '在线';

  @override
  String get connecting => '连接中…';

  @override
  String get offline => '离线';

  @override
  String get refresh => '刷新';

  @override
  String get addDevice => '添加设备…';

  @override
  String get forgetDevice => '忘记设备';

  @override
  String get forgetThisDevice => '忘记此设备？';

  @override
  String get forgetThisDeviceBody => '已保存的配对将被移除。你可以再次扫描二维码重新连接。';

  @override
  String forgetThisDeviceBodyNamed(String displayName, String host, int port) {
    return '$displayName（$host:$port）将被移除，应用将返回扫码界面。';
  }

  @override
  String get cancel => '取消';

  @override
  String get forget => '忘记';

  @override
  String get retry => '重试';

  @override
  String get cannotReachRelay => '无法连接中转';

  @override
  String get gateBody => '中转已有一段时间未能连接。请重试，或切换到其他模式——例如不在本地网络时使用 Tailscale。';

  @override
  String get tryAgain => '再试一次';

  @override
  String get changeMode => '更换模式…';

  @override
  String get connectionSettings => '连接设置';

  @override
  String get openAppAnyway => '仍然打开应用';

  @override
  String get tapToSwitchMode => '点按以切换连接模式';

  @override
  String get noAgentsFound => '未找到助手';

  @override
  String get noAgentsHint => '在电脑上启动助手（例如 `herdr codex`），或点按刷新。';

  @override
  String get connectToRelay => '连接到中转';

  @override
  String get pairScanHint => '扫描电脑上中转显示的二维码（命令 `relay pair --qr`），或手动粘贴链接。';

  @override
  String get pairLink => '配对链接';

  @override
  String get pairLinkHint => 'herdrelay://pair?host=...&token=...';

  @override
  String get connect => '连接';

  @override
  String cameraUnavailable(String code) {
    return '相机不可用（$code）。请手动粘贴链接。';
  }

  @override
  String get selectConnectionMode => '选择连接模式';

  @override
  String get selectConnectionModeBody => '中转可通过多个网络访问。请选择当前要用的模式——其他模式也会一并保存。';

  @override
  String connectionError(String error) {
    return '连接错误：$error';
  }

  @override
  String get help => '帮助';

  @override
  String get connectionIssues => '连接问题';

  @override
  String get helpAwayQuestion => '出门在外连不上？';

  @override
  String get helpAwayAnswer =>
      '中转很可能只能在本地 WiFi（LAN 模式）下访问。请在中转机器和本机都安装 Tailscale，然后重新扫描二维码——所有可用模式会自动保存，LAN 不可用时应用会切换到 Tailscale。';

  @override
  String get connectionModes => '连接模式';

  @override
  String get modeLanTitle => 'LAN';

  @override
  String get modeLanBody => '同一 WiFi / 局域网直连。最快，但任一设备离开家就无法使用。';

  @override
  String get modeTailscaleTitle => 'Tailscale';

  @override
  String get modeTailscaleBody =>
      '可从任何地方使用的安全隧道。两台设备都需要 Tailscale，并加入同一 tailnet。';

  @override
  String get modeFunnelTitle => 'Funnel';

  @override
  String get modeFunnelBody =>
      '通过 Tailscale 暴露的公共 HTTPS 地址——无需安装 Tailscale 也能从任何地方访问。中转需启用 funnel（`tailscale funnel 8375`）。';

  @override
  String helpQuestion(String question) {
    return '问：$question';
  }

  @override
  String helpAnswer(String answer) {
    return '答：$answer';
  }

  @override
  String get settingsConnection => '连接';

  @override
  String get moreModes => '更多模式…';

  @override
  String get moreModesSubtitle => '中转通过 /pair 公布的模式';

  @override
  String get connectionSettingsEllipsis => '连接设置…';

  @override
  String get connectionSettingsSubtitle => '切换配置、配对设备、忘记此中转';

  @override
  String get settingsNotifications => '通知';

  @override
  String get blockedAgentAlerts => '助手阻塞提醒';

  @override
  String get blockedAgentAlertsSubtitle => '应用在后台时，若助手需要你回复则显示通知';

  @override
  String get settingsTerminal => '终端';

  @override
  String get terminalFontSize => '终端字号';

  @override
  String terminalFontSizeSubtitle(int pt) {
    return '助手输出的默认字号（$pt pt）';
  }

  @override
  String get autoFollowTerminal => '自动跟随终端输出';

  @override
  String get autoFollowTerminalSubtitle => '有新输出时保持终端滚动到底部';

  @override
  String get settingsAppearance => '外观';

  @override
  String get themeSubtitle => '应用配色主题';

  @override
  String get themeClaude => 'Claude';

  @override
  String get themeTeal => '青绿';

  @override
  String get settingsAbout => '关于';

  @override
  String get helpTroubleshooting => '帮助与排查';

  @override
  String get connection => '连接';

  @override
  String get device => '设备';

  @override
  String get onlyReachableLan => '仅可在本地 WiFi 访问';

  @override
  String get tipEnableTailscale => '提示：两台设备都启用 Tailscale 以便远程访问';

  @override
  String profileId(String id) {
    return 'id: $id';
  }

  @override
  String get connectionStatus => '连接状态';

  @override
  String get statusConnected => '已连接';

  @override
  String get statusConnecting => '连接中…';

  @override
  String get statusNoClient => '无客户端';

  @override
  String get statusDisconnected => '已断开';

  @override
  String get test => '测试';

  @override
  String get relayNotReachable => '中转不可达（healthz 失败）';

  @override
  String checkOk(int count, int ms) {
    return '正常 · $count 个助手 · ${ms}ms';
  }

  @override
  String get connectionMode => '连接模式';

  @override
  String get refreshModes => '刷新模式';

  @override
  String get savedModesForRelay => '此中转已保存的模式';

  @override
  String get noModesAvailable => '暂无可用模式 — 中转不可达？';

  @override
  String get switchModeManually => '手动切换模式';

  @override
  String get savedDevices => '已保存的设备';

  @override
  String get noSavedDevices => '还没有已保存的设备';

  @override
  String get pairAddDevice => '配对 / 添加设备';

  @override
  String switchedToMode(String mode) {
    return '已切换到 $mode';
  }

  @override
  String get pairSaved => '配对已保存';

  @override
  String get noWorkspaces => '暂无工作区';

  @override
  String panesCount(int count, String id) {
    return '$count 个窗格 · $id';
  }

  @override
  String get noPanesInWorkspace => '此工作区没有窗格';

  @override
  String get runAnAgent => '运行助手';

  @override
  String get agentKind => '助手类型';

  @override
  String get workspace => '工作区';

  @override
  String get agentName => '助手名称';

  @override
  String get agentNameHint => 'codex-1';

  @override
  String get noFreePaneAllHaveAgents => '没有空闲窗格 — 启动时会新建标签页。';

  @override
  String willStartInFreePane(String paneId) {
    return '将优先使用空闲窗格 $paneId；若不可用会自动新建标签页';
  }

  @override
  String get willCreateTabThenStart => '将新建一个标签页，然后启动助手';

  @override
  String get startAgent => '启动助手';

  @override
  String get noFreePaneRunFirst => '没有空闲窗格 — 启动时会新建标签页。';

  @override
  String get enterAgentName => '请输入助手名称';

  @override
  String startedAgentInPane(String name, String kind, String paneId) {
    return '已在 $paneId 启动 $name（$kind）';
  }

  @override
  String get noWorkspacesCreateFirst => '暂无工作区 — 请先在电脑上创建';

  @override
  String get smallerText => '缩小文字';

  @override
  String get largerText => '放大文字';

  @override
  String get refreshOutput => '刷新输出';

  @override
  String get noOutput => '（无输出）';

  @override
  String get ctrlC => 'Ctrl-C';

  @override
  String get messageAgent => '向助手发消息…';

  @override
  String get clearHistory => '清除历史';

  @override
  String get send => '发送';

  @override
  String get limitedConnectivity => '检测到连接能力有限';

  @override
  String get limitedConnectivityBody =>
      '你的中转目前只能通过 LAN（本地 WiFi）访问。离开家后将无法连接，除非：';

  @override
  String get installTailscaleBoth => '• 在两台设备上都安装 Tailscale 或 EasyTier';

  @override
  String get rescanQrTailscale => '• 重新扫描二维码以保存 Tailscale 端点';

  @override
  String get learnMore => '了解更多';

  @override
  String get continueAnyway => '仍然继续';

  @override
  String get manualConnection => '手动连接';

  @override
  String get manualConnectionHint => '在自动模式切换无效时使用。';

  @override
  String get mode => '模式';

  @override
  String get host => '主机';

  @override
  String get hostHintExample => '例如 mac.tailnet.ts.net';

  @override
  String get port => '端口';

  @override
  String get testConnection => '测试连接';

  @override
  String get enterHostFirst => '请先输入主机';

  @override
  String reachableHttp(int statusCode) {
    return '可达（HTTP $statusCode）';
  }

  @override
  String notReachable(String error) {
    return '不可达 — $error';
  }

  @override
  String get invalidModeLink => '中转返回的模式链接无效';

  @override
  String enterRelayHost(String hint) {
    return '请输入中转主机（例如 $hint）';
  }

  @override
  String invalidPort(String port) {
    return '无效端口：$port';
  }

  @override
  String get relayUnreachableManual => '中转不可达？手动连接';

  @override
  String get errorNotConnected => '无法连接中转。请检查网络连接。';

  @override
  String get errorTimeout => '中转未及时响应。请重试。';

  @override
  String get errorUnauthorized => '令牌无效。请重新扫描二维码。';

  @override
  String fallbackSwitched(String mode) {
    return '中转不可达 — 已自动切换到 $mode';
  }

  @override
  String get notifChannelName => '阻塞的助手';

  @override
  String get notifBlockedTitle => '助手已阻塞';

  @override
  String notifBlockedBody(String agentName) {
    return '$agentName 正在等待你的回复';
  }

  @override
  String versionLabel(String version) {
    return '版本 $version';
  }

  @override
  String get forgetThisDeviceButton => '忘记此设备';

  @override
  String get tapToSwitchDevice => '点按切换设备';

  @override
  String get deviceOnline => '在线';

  @override
  String get deviceOffline => '离线';

  @override
  String get deviceUnknown => '未知';

  @override
  String get addDeviceChip => '添加';

  @override
  String get agentPaneBusyRetry => '该窗格正忙 — 正在新建标签页…';

  @override
  String startAgentFailed(String error) {
    return '无法启动助手：$error';
  }

  @override
  String get selectSessions => '选择';

  @override
  String get cancelSelection => '取消';

  @override
  String get closeSelected => '关闭';

  @override
  String get closeSession => '关闭会话';

  @override
  String get closeSessionConfirmTitle => '关闭所选会话？';

  @override
  String closeSessionConfirmBody(int count) {
    return '将在这台电脑上关闭 $count 个会话。手机端无法撤销。';
  }

  @override
  String closeSessionConfirmOne(String name) {
    return '在这台电脑上关闭“$name”？对应标签页/窗格会被关闭。';
  }

  @override
  String sessionsClosed(int count) {
    return '已关闭 $count 个会话';
  }

  @override
  String selectedCount(int count) {
    return '已选 $count 个';
  }
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get appTitle => 'Herdr Mobile';

  @override
  String get tabSpaces => '工作区';

  @override
  String get tabAgents => '助手';

  @override
  String get tabRun => '运行';

  @override
  String get tabSettings => '设置';

  @override
  String get online => '在线';

  @override
  String get connecting => '连接中…';

  @override
  String get offline => '离线';

  @override
  String get refresh => '刷新';

  @override
  String get addDevice => '添加设备…';

  @override
  String get forgetDevice => '忘记设备';

  @override
  String get forgetThisDevice => '忘记此设备？';

  @override
  String get forgetThisDeviceBody => '已保存的配对将被移除。你可以再次扫描二维码重新连接。';

  @override
  String forgetThisDeviceBodyNamed(String displayName, String host, int port) {
    return '$displayName（$host:$port）将被移除，应用将返回扫码界面。';
  }

  @override
  String get cancel => '取消';

  @override
  String get forget => '忘记';

  @override
  String get retry => '重试';

  @override
  String get cannotReachRelay => '无法连接中转';

  @override
  String get gateBody => '中转已有一段时间未能连接。请重试，或切换到其他模式——例如不在本地网络时使用 Tailscale。';

  @override
  String get tryAgain => '再试一次';

  @override
  String get changeMode => '更换模式…';

  @override
  String get connectionSettings => '连接设置';

  @override
  String get openAppAnyway => '仍然打开应用';

  @override
  String get tapToSwitchMode => '点按以切换连接模式';

  @override
  String get noAgentsFound => '未找到助手';

  @override
  String get noAgentsHint => '在电脑上启动助手（例如 `herdr codex`），或点按刷新。';

  @override
  String get connectToRelay => '连接到中转';

  @override
  String get pairScanHint => '扫描电脑上中转显示的二维码（命令 `relay pair --qr`），或手动粘贴链接。';

  @override
  String get pairLink => '配对链接';

  @override
  String get pairLinkHint => 'herdrelay://pair?host=...&token=...';

  @override
  String get connect => '连接';

  @override
  String cameraUnavailable(String code) {
    return '相机不可用（$code）。请手动粘贴链接。';
  }

  @override
  String get selectConnectionMode => '选择连接模式';

  @override
  String get selectConnectionModeBody => '中转可通过多个网络访问。请选择当前要用的模式——其他模式也会一并保存。';

  @override
  String connectionError(String error) {
    return '连接错误：$error';
  }

  @override
  String get help => '帮助';

  @override
  String get connectionIssues => '连接问题';

  @override
  String get helpAwayQuestion => '出门在外连不上？';

  @override
  String get helpAwayAnswer =>
      '中转很可能只能在本地 WiFi（LAN 模式）下访问。请在中转机器和本机都安装 Tailscale，然后重新扫描二维码——所有可用模式会自动保存，LAN 不可用时应用会切换到 Tailscale。';

  @override
  String get connectionModes => '连接模式';

  @override
  String get modeLanTitle => 'LAN';

  @override
  String get modeLanBody => '同一 WiFi / 局域网直连。最快，但任一设备离开家就无法使用。';

  @override
  String get modeTailscaleTitle => 'Tailscale';

  @override
  String get modeTailscaleBody =>
      '可从任何地方使用的安全隧道。两台设备都需要 Tailscale，并加入同一 tailnet。';

  @override
  String get modeFunnelTitle => 'Funnel';

  @override
  String get modeFunnelBody =>
      '通过 Tailscale 暴露的公共 HTTPS 地址——无需安装 Tailscale 也能从任何地方访问。中转需启用 funnel（`tailscale funnel 8375`）。';

  @override
  String helpQuestion(String question) {
    return '问：$question';
  }

  @override
  String helpAnswer(String answer) {
    return '答：$answer';
  }

  @override
  String get settingsConnection => '连接';

  @override
  String get moreModes => '更多模式…';

  @override
  String get moreModesSubtitle => '中转通过 /pair 公布的模式';

  @override
  String get connectionSettingsEllipsis => '连接设置…';

  @override
  String get connectionSettingsSubtitle => '切换配置、配对设备、忘记此中转';

  @override
  String get settingsNotifications => '通知';

  @override
  String get blockedAgentAlerts => '助手阻塞提醒';

  @override
  String get blockedAgentAlertsSubtitle => '应用在后台时，若助手需要你回复则显示通知';

  @override
  String get settingsTerminal => '终端';

  @override
  String get terminalFontSize => '终端字号';

  @override
  String terminalFontSizeSubtitle(int pt) {
    return '助手输出的默认字号（$pt pt）';
  }

  @override
  String get autoFollowTerminal => '自动跟随终端输出';

  @override
  String get autoFollowTerminalSubtitle => '有新输出时保持终端滚动到底部';

  @override
  String get settingsAppearance => '外观';

  @override
  String get themeSubtitle => '应用配色主题';

  @override
  String get themeClaude => 'Claude';

  @override
  String get themeTeal => '青绿';

  @override
  String get settingsAbout => '关于';

  @override
  String get helpTroubleshooting => '帮助与排查';

  @override
  String get connection => '连接';

  @override
  String get device => '设备';

  @override
  String get onlyReachableLan => '仅可在本地 WiFi 访问';

  @override
  String get tipEnableTailscale => '提示：两台设备都启用 Tailscale 以便远程访问';

  @override
  String profileId(String id) {
    return 'id: $id';
  }

  @override
  String get connectionStatus => '连接状态';

  @override
  String get statusConnected => '已连接';

  @override
  String get statusConnecting => '连接中…';

  @override
  String get statusNoClient => '无客户端';

  @override
  String get statusDisconnected => '已断开';

  @override
  String get test => '测试';

  @override
  String get relayNotReachable => '中转不可达（healthz 失败）';

  @override
  String checkOk(int count, int ms) {
    return '正常 · $count 个助手 · ${ms}ms';
  }

  @override
  String get connectionMode => '连接模式';

  @override
  String get refreshModes => '刷新模式';

  @override
  String get savedModesForRelay => '此中转已保存的模式';

  @override
  String get noModesAvailable => '暂无可用模式 — 中转不可达？';

  @override
  String get switchModeManually => '手动切换模式';

  @override
  String get savedDevices => '已保存的设备';

  @override
  String get noSavedDevices => '还没有已保存的设备';

  @override
  String get pairAddDevice => '配对 / 添加设备';

  @override
  String switchedToMode(String mode) {
    return '已切换到 $mode';
  }

  @override
  String get pairSaved => '配对已保存';

  @override
  String get noWorkspaces => '暂无工作区';

  @override
  String panesCount(int count, String id) {
    return '$count 个窗格 · $id';
  }

  @override
  String get noPanesInWorkspace => '此工作区没有窗格';

  @override
  String get runAnAgent => '运行助手';

  @override
  String get agentKind => '助手类型';

  @override
  String get workspace => '工作区';

  @override
  String get agentName => '助手名称';

  @override
  String get agentNameHint => 'codex-1';

  @override
  String get noFreePaneAllHaveAgents => '没有空闲窗格 — 启动时会新建标签页。';

  @override
  String willStartInFreePane(String paneId) {
    return '将优先使用空闲窗格 $paneId；若不可用会自动新建标签页';
  }

  @override
  String get willCreateTabThenStart => '将新建一个标签页，然后启动助手';

  @override
  String get startAgent => '启动助手';

  @override
  String get noFreePaneRunFirst => '没有空闲窗格 — 启动时会新建标签页。';

  @override
  String get enterAgentName => '请输入助手名称';

  @override
  String startedAgentInPane(String name, String kind, String paneId) {
    return '已在 $paneId 启动 $name（$kind）';
  }

  @override
  String get noWorkspacesCreateFirst => '暂无工作区 — 请先在电脑上创建';

  @override
  String get smallerText => '缩小文字';

  @override
  String get largerText => '放大文字';

  @override
  String get refreshOutput => '刷新输出';

  @override
  String get noOutput => '（无输出）';

  @override
  String get ctrlC => 'Ctrl-C';

  @override
  String get messageAgent => '向助手发消息…';

  @override
  String get clearHistory => '清除历史';

  @override
  String get send => '发送';

  @override
  String get limitedConnectivity => '检测到连接能力有限';

  @override
  String get limitedConnectivityBody =>
      '你的中转目前只能通过 LAN（本地 WiFi）访问。离开家后将无法连接，除非：';

  @override
  String get installTailscaleBoth => '• 在两台设备上都安装 Tailscale 或 EasyTier';

  @override
  String get rescanQrTailscale => '• 重新扫描二维码以保存 Tailscale 端点';

  @override
  String get learnMore => '了解更多';

  @override
  String get continueAnyway => '仍然继续';

  @override
  String get manualConnection => '手动连接';

  @override
  String get manualConnectionHint => '在自动模式切换无效时使用。';

  @override
  String get mode => '模式';

  @override
  String get host => '主机';

  @override
  String get hostHintExample => '例如 mac.tailnet.ts.net';

  @override
  String get port => '端口';

  @override
  String get testConnection => '测试连接';

  @override
  String get enterHostFirst => '请先输入主机';

  @override
  String reachableHttp(int statusCode) {
    return '可达（HTTP $statusCode）';
  }

  @override
  String notReachable(String error) {
    return '不可达 — $error';
  }

  @override
  String get invalidModeLink => '中转返回的模式链接无效';

  @override
  String enterRelayHost(String hint) {
    return '请输入中转主机（例如 $hint）';
  }

  @override
  String invalidPort(String port) {
    return '无效端口：$port';
  }

  @override
  String get relayUnreachableManual => '中转不可达？手动连接';

  @override
  String get errorNotConnected => '无法连接中转。请检查网络连接。';

  @override
  String get errorTimeout => '中转未及时响应。请重试。';

  @override
  String get errorUnauthorized => '令牌无效。请重新扫描二维码。';

  @override
  String fallbackSwitched(String mode) {
    return '中转不可达 — 已自动切换到 $mode';
  }

  @override
  String get notifChannelName => '阻塞的助手';

  @override
  String get notifBlockedTitle => '助手已阻塞';

  @override
  String notifBlockedBody(String agentName) {
    return '$agentName 正在等待你的回复';
  }

  @override
  String versionLabel(String version) {
    return '版本 $version';
  }

  @override
  String get forgetThisDeviceButton => '忘记此设备';

  @override
  String get tapToSwitchDevice => '点按切换设备';

  @override
  String get deviceOnline => '在线';

  @override
  String get deviceOffline => '离线';

  @override
  String get deviceUnknown => '未知';

  @override
  String get addDeviceChip => '添加';

  @override
  String get agentPaneBusyRetry => '该窗格正忙 — 正在新建标签页…';

  @override
  String startAgentFailed(String error) {
    return '无法启动助手：$error';
  }

  @override
  String get selectSessions => '选择';

  @override
  String get cancelSelection => '取消';

  @override
  String get closeSelected => '关闭';

  @override
  String get closeSession => '关闭会话';

  @override
  String get closeSessionConfirmTitle => '关闭所选会话？';

  @override
  String closeSessionConfirmBody(int count) {
    return '将在这台电脑上关闭 $count 个会话。手机端无法撤销。';
  }

  @override
  String closeSessionConfirmOne(String name) {
    return '在这台电脑上关闭“$name”？对应标签页/窗格会被关闭。';
  }

  @override
  String sessionsClosed(int count) {
    return '已关闭 $count 个会话';
  }

  @override
  String selectedCount(int count) {
    return '已选 $count 个';
  }
}
