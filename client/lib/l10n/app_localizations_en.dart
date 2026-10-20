// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Herdr Mobile';

  @override
  String get tabSpaces => 'Spaces';

  @override
  String get tabAgents => 'Agents';

  @override
  String get tabRun => 'Run';

  @override
  String get tabSettings => 'Settings';

  @override
  String get online => 'online';

  @override
  String get connecting => 'connecting…';

  @override
  String get offline => 'offline';

  @override
  String get refresh => 'Refresh';

  @override
  String get addDevice => 'Add device…';

  @override
  String get forgetDevice => 'Forget device';

  @override
  String get forgetThisDevice => 'Forget this device?';

  @override
  String get forgetThisDeviceBody =>
      'The saved pair will be removed. You can scan its QR again to reconnect.';

  @override
  String forgetThisDeviceBodyNamed(String displayName, String host, int port) {
    return '$displayName ($host:$port) will be removed and the app returns to the scanner.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get forget => 'Forget';

  @override
  String get retry => 'Retry';

  @override
  String get cannotReachRelay => 'Cannot reach the relay';

  @override
  String get gateBody =>
      'The relay has not connected for a while. Try again, or switch to another mode — e.g. Tailscale if you are away from the local network.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get changeMode => 'Change mode…';

  @override
  String get connectionSettings => 'Connection settings';

  @override
  String get openAppAnyway => 'Open app anyway';

  @override
  String get tapToSwitchMode => 'Tap to switch connection mode';

  @override
  String get noAgentsFound => 'No agents found';

  @override
  String get noAgentsHint =>
      'Start an agent (e.g. `herdr codex`) on the computer or press Refresh.';

  @override
  String get connectToRelay => 'Connect to relay';

  @override
  String get pairScanHint =>
      'Scan the QR code the relay shows on the computer (command `relay pair --qr`), or paste the link manually.';

  @override
  String get pairLink => 'Pair link';

  @override
  String get pairLinkHint => 'herdrelay://pair?host=...&token=...';

  @override
  String get connect => 'Connect';

  @override
  String cameraUnavailable(String code) {
    return 'Camera unavailable ($code). Paste the link manually.';
  }

  @override
  String get selectConnectionMode => 'Select connection mode';

  @override
  String get selectConnectionModeBody =>
      'The relay is reachable through several networks. Pick the one to use now — the others are saved too.';

  @override
  String connectionError(String error) {
    return 'Connection error: $error';
  }

  @override
  String get help => 'Help';

  @override
  String get connectionIssues => 'Connection issues';

  @override
  String get helpAwayQuestion => 'Can\'t connect when away from home?';

  @override
  String get helpAwayAnswer =>
      'The relay is probably reachable only on your local WiFi (LAN mode). Install Tailscale on the relay machine and on this device, then re-scan the QR code — all reachable modes are saved automatically, and the app switches to Tailscale when LAN goes dark.';

  @override
  String get connectionModes => 'Connection modes';

  @override
  String get modeLanTitle => 'LAN';

  @override
  String get modeLanBody =>
      'Direct connection on the same WiFi / local network. Fastest, but stops working when either device leaves home.';

  @override
  String get modeTailscaleTitle => 'Tailscale';

  @override
  String get modeTailscaleBody =>
      'Secure tunnel that works from anywhere. Both devices need the Tailscale app and must be on the same tailnet.';

  @override
  String get modeFunnelTitle => 'Funnel';

  @override
  String get modeFunnelBody =>
      'Public HTTPS URL exposed through Tailscale — reachable from anywhere without Tailscale installed. Relay must enable funnel (`tailscale funnel 8375`).';

  @override
  String helpQuestion(String question) {
    return 'Q: $question';
  }

  @override
  String helpAnswer(String answer) {
    return 'A: $answer';
  }

  @override
  String get settingsConnection => 'Connection';

  @override
  String get moreModes => 'More modes…';

  @override
  String get moreModesSubtitle => 'Modes the relay advertises over /pair';

  @override
  String get connectionSettingsEllipsis => 'Connection settings…';

  @override
  String get connectionSettingsSubtitle =>
      'Switch profile, pair a device, forget this relay';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get blockedAgentAlerts => 'Blocked agent alerts';

  @override
  String get blockedAgentAlertsSubtitle =>
      'Show a notification when an agent needs your response while the app is in the background';

  @override
  String get settingsTerminal => 'Terminal';

  @override
  String get terminalFontSize => 'Terminal font size';

  @override
  String terminalFontSizeSubtitle(int pt) {
    return 'Default size for agent output ($pt pt)';
  }

  @override
  String get autoFollowTerminal => 'Auto-follow terminal output';

  @override
  String get autoFollowTerminalSubtitle =>
      'Keep the terminal scrolled to the bottom as new output arrives';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get themeSubtitle => 'App color theme';

  @override
  String get themeClaude => 'Claude';

  @override
  String get themeTeal => 'Teal';

  @override
  String get settingsAbout => 'About';

  @override
  String get helpTroubleshooting => 'Help & troubleshooting';

  @override
  String get connection => 'Connection';

  @override
  String get device => 'Device';

  @override
  String get onlyReachableLan => 'Only reachable on local WiFi';

  @override
  String get tipEnableTailscale =>
      'Tip: enable Tailscale on both devices for remote access';

  @override
  String profileId(String id) {
    return 'id: $id';
  }

  @override
  String get connectionStatus => 'Connection status';

  @override
  String get statusConnected => 'Connected';

  @override
  String get statusConnecting => 'Connecting…';

  @override
  String get statusNoClient => 'No client';

  @override
  String get statusDisconnected => 'Disconnected';

  @override
  String get test => 'Test';

  @override
  String get relayNotReachable => 'Relay not reachable (healthz failed)';

  @override
  String checkOk(int count, int ms) {
    return 'OK · $count agent(s) · ${ms}ms';
  }

  @override
  String get connectionMode => 'Connection mode';

  @override
  String get refreshModes => 'Refresh modes';

  @override
  String get savedModesForRelay => 'Saved modes for this relay';

  @override
  String get noModesAvailable => 'No modes available — relay unreachable?';

  @override
  String get switchModeManually => 'Switch mode manually';

  @override
  String get savedDevices => 'Saved devices';

  @override
  String get noSavedDevices => 'No saved devices yet';

  @override
  String get pairAddDevice => 'Pair / add device';

  @override
  String switchedToMode(String mode) {
    return 'Switched to $mode';
  }

  @override
  String get pairSaved => 'Pair saved';

  @override
  String get noWorkspaces => 'No workspaces';

  @override
  String panesCount(int count, String id) {
    return '$count pane(s) · $id';
  }

  @override
  String get noPanesInWorkspace => 'No panes in this workspace';

  @override
  String get runAnAgent => 'Run an agent';

  @override
  String get agentKind => 'Agent kind';

  @override
  String get workspace => 'Workspace';

  @override
  String get agentName => 'Agent name';

  @override
  String get agentNameHint => 'codex-1';

  @override
  String get noFreePaneAllHaveAgents =>
      'No free pane in this workspace — all panes have agents.';

  @override
  String willStartInFreePane(String paneId) {
    return 'Will start in free pane $paneId';
  }

  @override
  String get startAgent => 'Start agent';

  @override
  String get noFreePaneRunFirst =>
      'No free pane in this workspace — run an agent there first on the computer.';

  @override
  String get enterAgentName => 'Enter an agent name';

  @override
  String startedAgentInPane(String name, String kind, String paneId) {
    return 'Started $name ($kind) in $paneId';
  }

  @override
  String get noWorkspacesCreateFirst =>
      'No workspaces — create one on the computer first';

  @override
  String get smallerText => 'Smaller text';

  @override
  String get largerText => 'Larger text';

  @override
  String get refreshOutput => 'Refresh output';

  @override
  String get noOutput => '(no output)';

  @override
  String get ctrlC => 'Ctrl-C';

  @override
  String get messageAgent => 'Message agent…';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get send => 'Send';

  @override
  String get limitedConnectivity => 'Limited connectivity detected';

  @override
  String get limitedConnectivityBody =>
      'Your relay is only reachable via LAN (local WiFi). When you leave home you won\'t be able to connect unless:';

  @override
  String get installTailscaleBoth =>
      '• Install Tailscale or EasyTier on both devices';

  @override
  String get rescanQrTailscale =>
      '• Re-scan the QR code to save the Tailscale endpoint';

  @override
  String get learnMore => 'Learn more';

  @override
  String get continueAnyway => 'Continue anyway';

  @override
  String get manualConnection => 'Manual Connection';

  @override
  String get manualConnectionHint =>
      'Use this when automatic mode switching doesn\'t work.';

  @override
  String get mode => 'Mode';

  @override
  String get host => 'Host';

  @override
  String get hostHintExample => 'e.g. mac.tailnet.ts.net';

  @override
  String get port => 'Port';

  @override
  String get testConnection => 'Test connection';

  @override
  String get enterHostFirst => 'Enter a host first';

  @override
  String reachableHttp(int statusCode) {
    return 'Reachable (HTTP $statusCode)';
  }

  @override
  String notReachable(String error) {
    return 'Not reachable — $error';
  }

  @override
  String get invalidModeLink => 'Invalid mode link from relay';

  @override
  String enterRelayHost(String hint) {
    return 'Enter the relay host (e.g. $hint)';
  }

  @override
  String invalidPort(String port) {
    return 'Invalid port: $port';
  }

  @override
  String get relayUnreachableManual => 'Relay unreachable? Connect manually';

  @override
  String get errorNotConnected =>
      'Cannot reach relay. Check your network connection.';

  @override
  String get errorTimeout => 'Relay did not respond in time. Try again.';

  @override
  String get errorUnauthorized =>
      'Invalid token. Please scan the QR code again.';

  @override
  String fallbackSwitched(String mode) {
    return 'Relay unreachable — switched to $mode automatically';
  }

  @override
  String get notifChannelName => 'Blocked agents';

  @override
  String get notifBlockedTitle => 'Agent blocked';

  @override
  String notifBlockedBody(String agentName) {
    return '$agentName is waiting for your response';
  }

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get forgetThisDeviceButton => 'Forget this device';

  @override
  String get tapToSwitchDevice => 'Tap to switch device';

  @override
  String get deviceOnline => 'Online';

  @override
  String get deviceOffline => 'Offline';

  @override
  String get deviceUnknown => 'Unknown';

  @override
  String get addDeviceChip => 'Add';
}
