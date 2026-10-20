import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'CN'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Herdr Mobile'**
  String get appTitle;

  /// No description provided for @tabSpaces.
  ///
  /// In en, this message translates to:
  /// **'Spaces'**
  String get tabSpaces;

  /// No description provided for @tabAgents.
  ///
  /// In en, this message translates to:
  /// **'Agents'**
  String get tabAgents;

  /// No description provided for @tabRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get tabRun;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get online;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'connecting…'**
  String get connecting;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'offline'**
  String get offline;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @addDevice.
  ///
  /// In en, this message translates to:
  /// **'Add device…'**
  String get addDevice;

  /// No description provided for @forgetDevice.
  ///
  /// In en, this message translates to:
  /// **'Forget device'**
  String get forgetDevice;

  /// No description provided for @forgetThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Forget this device?'**
  String get forgetThisDevice;

  /// No description provided for @forgetThisDeviceBody.
  ///
  /// In en, this message translates to:
  /// **'The saved pair will be removed. You can scan its QR again to reconnect.'**
  String get forgetThisDeviceBody;

  /// No description provided for @forgetThisDeviceBodyNamed.
  ///
  /// In en, this message translates to:
  /// **'{displayName} ({host}:{port}) will be removed and the app returns to the scanner.'**
  String forgetThisDeviceBodyNamed(String displayName, String host, int port);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @forget.
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get forget;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cannotReachRelay.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the relay'**
  String get cannotReachRelay;

  /// No description provided for @gateBody.
  ///
  /// In en, this message translates to:
  /// **'The relay has not connected for a while. Try again, or switch to another mode — e.g. Tailscale if you are away from the local network.'**
  String get gateBody;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @changeMode.
  ///
  /// In en, this message translates to:
  /// **'Change mode…'**
  String get changeMode;

  /// No description provided for @connectionSettings.
  ///
  /// In en, this message translates to:
  /// **'Connection settings'**
  String get connectionSettings;

  /// No description provided for @openAppAnyway.
  ///
  /// In en, this message translates to:
  /// **'Open app anyway'**
  String get openAppAnyway;

  /// No description provided for @tapToSwitchMode.
  ///
  /// In en, this message translates to:
  /// **'Tap to switch connection mode'**
  String get tapToSwitchMode;

  /// No description provided for @noAgentsFound.
  ///
  /// In en, this message translates to:
  /// **'No agents found'**
  String get noAgentsFound;

  /// No description provided for @noAgentsHint.
  ///
  /// In en, this message translates to:
  /// **'Start an agent (e.g. `herdr codex`) on the computer or press Refresh.'**
  String get noAgentsHint;

  /// No description provided for @connectToRelay.
  ///
  /// In en, this message translates to:
  /// **'Connect to relay'**
  String get connectToRelay;

  /// No description provided for @pairScanHint.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code the relay shows on the computer (command `relay pair --qr`), or paste the link manually.'**
  String get pairScanHint;

  /// No description provided for @pairLink.
  ///
  /// In en, this message translates to:
  /// **'Pair link'**
  String get pairLink;

  /// No description provided for @pairLinkHint.
  ///
  /// In en, this message translates to:
  /// **'herdrelay://pair?host=...&token=...'**
  String get pairLinkHint;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable ({code}). Paste the link manually.'**
  String cameraUnavailable(String code);

  /// No description provided for @selectConnectionMode.
  ///
  /// In en, this message translates to:
  /// **'Select connection mode'**
  String get selectConnectionMode;

  /// No description provided for @selectConnectionModeBody.
  ///
  /// In en, this message translates to:
  /// **'The relay is reachable through several networks. Pick the one to use now — the others are saved too.'**
  String get selectConnectionModeBody;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error: {error}'**
  String connectionError(String error);

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @connectionIssues.
  ///
  /// In en, this message translates to:
  /// **'Connection issues'**
  String get connectionIssues;

  /// No description provided for @helpAwayQuestion.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect when away from home?'**
  String get helpAwayQuestion;

  /// No description provided for @helpAwayAnswer.
  ///
  /// In en, this message translates to:
  /// **'The relay is probably reachable only on your local WiFi (LAN mode). Install Tailscale on the relay machine and on this device, then re-scan the QR code — all reachable modes are saved automatically, and the app switches to Tailscale when LAN goes dark.'**
  String get helpAwayAnswer;

  /// No description provided for @connectionModes.
  ///
  /// In en, this message translates to:
  /// **'Connection modes'**
  String get connectionModes;

  /// No description provided for @modeLanTitle.
  ///
  /// In en, this message translates to:
  /// **'LAN'**
  String get modeLanTitle;

  /// No description provided for @modeLanBody.
  ///
  /// In en, this message translates to:
  /// **'Direct connection on the same WiFi / local network. Fastest, but stops working when either device leaves home.'**
  String get modeLanBody;

  /// No description provided for @modeTailscaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Tailscale'**
  String get modeTailscaleTitle;

  /// No description provided for @modeTailscaleBody.
  ///
  /// In en, this message translates to:
  /// **'Secure tunnel that works from anywhere. Both devices need the Tailscale app and must be on the same tailnet.'**
  String get modeTailscaleBody;

  /// No description provided for @modeFunnelTitle.
  ///
  /// In en, this message translates to:
  /// **'Funnel'**
  String get modeFunnelTitle;

  /// No description provided for @modeFunnelBody.
  ///
  /// In en, this message translates to:
  /// **'Public HTTPS URL exposed through Tailscale — reachable from anywhere without Tailscale installed. Relay must enable funnel (`tailscale funnel 8375`).'**
  String get modeFunnelBody;

  /// No description provided for @helpQuestion.
  ///
  /// In en, this message translates to:
  /// **'Q: {question}'**
  String helpQuestion(String question);

  /// No description provided for @helpAnswer.
  ///
  /// In en, this message translates to:
  /// **'A: {answer}'**
  String helpAnswer(String answer);

  /// No description provided for @settingsConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get settingsConnection;

  /// No description provided for @moreModes.
  ///
  /// In en, this message translates to:
  /// **'More modes…'**
  String get moreModes;

  /// No description provided for @moreModesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Modes the relay advertises over /pair'**
  String get moreModesSubtitle;

  /// No description provided for @connectionSettingsEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Connection settings…'**
  String get connectionSettingsEllipsis;

  /// No description provided for @connectionSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch profile, pair a device, forget this relay'**
  String get connectionSettingsSubtitle;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @blockedAgentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Blocked agent alerts'**
  String get blockedAgentAlerts;

  /// No description provided for @blockedAgentAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show a notification when an agent needs your response while the app is in the background'**
  String get blockedAgentAlertsSubtitle;

  /// No description provided for @settingsTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get settingsTerminal;

  /// No description provided for @terminalFontSize.
  ///
  /// In en, this message translates to:
  /// **'Terminal font size'**
  String get terminalFontSize;

  /// No description provided for @terminalFontSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Default size for agent output ({pt} pt)'**
  String terminalFontSizeSubtitle(int pt);

  /// No description provided for @autoFollowTerminal.
  ///
  /// In en, this message translates to:
  /// **'Auto-follow terminal output'**
  String get autoFollowTerminal;

  /// No description provided for @autoFollowTerminalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the terminal scrolled to the bottom as new output arrives'**
  String get autoFollowTerminalSubtitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @themeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App color theme'**
  String get themeSubtitle;

  /// No description provided for @themeClaude.
  ///
  /// In en, this message translates to:
  /// **'Claude'**
  String get themeClaude;

  /// No description provided for @themeTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get themeTeal;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @helpTroubleshooting.
  ///
  /// In en, this message translates to:
  /// **'Help & troubleshooting'**
  String get helpTroubleshooting;

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @onlyReachableLan.
  ///
  /// In en, this message translates to:
  /// **'Only reachable on local WiFi'**
  String get onlyReachableLan;

  /// No description provided for @tipEnableTailscale.
  ///
  /// In en, this message translates to:
  /// **'Tip: enable Tailscale on both devices for remote access'**
  String get tipEnableTailscale;

  /// No description provided for @profileId.
  ///
  /// In en, this message translates to:
  /// **'id: {id}'**
  String profileId(String id);

  /// No description provided for @connectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection status'**
  String get connectionStatus;

  /// No description provided for @statusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get statusConnected;

  /// No description provided for @statusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get statusConnecting;

  /// No description provided for @statusNoClient.
  ///
  /// In en, this message translates to:
  /// **'No client'**
  String get statusNoClient;

  /// No description provided for @statusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get statusDisconnected;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// No description provided for @relayNotReachable.
  ///
  /// In en, this message translates to:
  /// **'Relay not reachable (healthz failed)'**
  String get relayNotReachable;

  /// No description provided for @checkOk.
  ///
  /// In en, this message translates to:
  /// **'OK · {count} agent(s) · {ms}ms'**
  String checkOk(int count, int ms);

  /// No description provided for @connectionMode.
  ///
  /// In en, this message translates to:
  /// **'Connection mode'**
  String get connectionMode;

  /// No description provided for @refreshModes.
  ///
  /// In en, this message translates to:
  /// **'Refresh modes'**
  String get refreshModes;

  /// No description provided for @savedModesForRelay.
  ///
  /// In en, this message translates to:
  /// **'Saved modes for this relay'**
  String get savedModesForRelay;

  /// No description provided for @noModesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No modes available — relay unreachable?'**
  String get noModesAvailable;

  /// No description provided for @switchModeManually.
  ///
  /// In en, this message translates to:
  /// **'Switch mode manually'**
  String get switchModeManually;

  /// No description provided for @savedDevices.
  ///
  /// In en, this message translates to:
  /// **'Saved devices'**
  String get savedDevices;

  /// No description provided for @noSavedDevices.
  ///
  /// In en, this message translates to:
  /// **'No saved devices yet'**
  String get noSavedDevices;

  /// No description provided for @pairAddDevice.
  ///
  /// In en, this message translates to:
  /// **'Pair / add device'**
  String get pairAddDevice;

  /// No description provided for @switchedToMode.
  ///
  /// In en, this message translates to:
  /// **'Switched to {mode}'**
  String switchedToMode(String mode);

  /// No description provided for @pairSaved.
  ///
  /// In en, this message translates to:
  /// **'Pair saved'**
  String get pairSaved;

  /// No description provided for @noWorkspaces.
  ///
  /// In en, this message translates to:
  /// **'No workspaces'**
  String get noWorkspaces;

  /// No description provided for @panesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pane(s) · {id}'**
  String panesCount(int count, String id);

  /// No description provided for @noPanesInWorkspace.
  ///
  /// In en, this message translates to:
  /// **'No panes in this workspace'**
  String get noPanesInWorkspace;

  /// No description provided for @runAnAgent.
  ///
  /// In en, this message translates to:
  /// **'Run an agent'**
  String get runAnAgent;

  /// No description provided for @agentKind.
  ///
  /// In en, this message translates to:
  /// **'Agent kind'**
  String get agentKind;

  /// No description provided for @workspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get workspace;

  /// No description provided for @agentName.
  ///
  /// In en, this message translates to:
  /// **'Agent name'**
  String get agentName;

  /// No description provided for @agentNameHint.
  ///
  /// In en, this message translates to:
  /// **'codex-1'**
  String get agentNameHint;

  /// No description provided for @noFreePaneAllHaveAgents.
  ///
  /// In en, this message translates to:
  /// **'No free pane — a new tab will be created when you start.'**
  String get noFreePaneAllHaveAgents;

  /// No description provided for @willStartInFreePane.
  ///
  /// In en, this message translates to:
  /// **'Will try free pane {paneId}; if busy, creates a new tab'**
  String willStartInFreePane(String paneId);

  /// No description provided for @willCreateTabThenStart.
  ///
  /// In en, this message translates to:
  /// **'Will create a new tab, then start the agent'**
  String get willCreateTabThenStart;

  /// No description provided for @startAgent.
  ///
  /// In en, this message translates to:
  /// **'Start agent'**
  String get startAgent;

  /// No description provided for @noFreePaneRunFirst.
  ///
  /// In en, this message translates to:
  /// **'No free pane — a new tab will be created when you start.'**
  String get noFreePaneRunFirst;

  /// No description provided for @enterAgentName.
  ///
  /// In en, this message translates to:
  /// **'Enter an agent name'**
  String get enterAgentName;

  /// No description provided for @startedAgentInPane.
  ///
  /// In en, this message translates to:
  /// **'Started {name} ({kind}) in {paneId}'**
  String startedAgentInPane(String name, String kind, String paneId);

  /// No description provided for @noWorkspacesCreateFirst.
  ///
  /// In en, this message translates to:
  /// **'No workspaces — create one on the computer first'**
  String get noWorkspacesCreateFirst;

  /// No description provided for @smallerText.
  ///
  /// In en, this message translates to:
  /// **'Smaller text'**
  String get smallerText;

  /// No description provided for @largerText.
  ///
  /// In en, this message translates to:
  /// **'Larger text'**
  String get largerText;

  /// No description provided for @refreshOutput.
  ///
  /// In en, this message translates to:
  /// **'Refresh output'**
  String get refreshOutput;

  /// No description provided for @noOutput.
  ///
  /// In en, this message translates to:
  /// **'(no output)'**
  String get noOutput;

  /// No description provided for @ctrlC.
  ///
  /// In en, this message translates to:
  /// **'Ctrl-C'**
  String get ctrlC;

  /// No description provided for @messageAgent.
  ///
  /// In en, this message translates to:
  /// **'Message agent…'**
  String get messageAgent;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @limitedConnectivity.
  ///
  /// In en, this message translates to:
  /// **'Limited connectivity detected'**
  String get limitedConnectivity;

  /// No description provided for @limitedConnectivityBody.
  ///
  /// In en, this message translates to:
  /// **'Your relay is only reachable via LAN (local WiFi). When you leave home you won\'t be able to connect unless:'**
  String get limitedConnectivityBody;

  /// No description provided for @installTailscaleBoth.
  ///
  /// In en, this message translates to:
  /// **'• Install Tailscale or EasyTier on both devices'**
  String get installTailscaleBoth;

  /// No description provided for @rescanQrTailscale.
  ///
  /// In en, this message translates to:
  /// **'• Re-scan the QR code to save the Tailscale endpoint'**
  String get rescanQrTailscale;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;

  /// No description provided for @continueAnyway.
  ///
  /// In en, this message translates to:
  /// **'Continue anyway'**
  String get continueAnyway;

  /// No description provided for @manualConnection.
  ///
  /// In en, this message translates to:
  /// **'Manual Connection'**
  String get manualConnection;

  /// No description provided for @manualConnectionHint.
  ///
  /// In en, this message translates to:
  /// **'Use this when automatic mode switching doesn\'t work.'**
  String get manualConnectionHint;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @hostHintExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. mac.tailnet.ts.net'**
  String get hostHintExample;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get testConnection;

  /// No description provided for @enterHostFirst.
  ///
  /// In en, this message translates to:
  /// **'Enter a host first'**
  String get enterHostFirst;

  /// No description provided for @reachableHttp.
  ///
  /// In en, this message translates to:
  /// **'Reachable (HTTP {statusCode})'**
  String reachableHttp(int statusCode);

  /// No description provided for @notReachable.
  ///
  /// In en, this message translates to:
  /// **'Not reachable — {error}'**
  String notReachable(String error);

  /// No description provided for @invalidModeLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid mode link from relay'**
  String get invalidModeLink;

  /// No description provided for @enterRelayHost.
  ///
  /// In en, this message translates to:
  /// **'Enter the relay host (e.g. {hint})'**
  String enterRelayHost(String hint);

  /// No description provided for @invalidPort.
  ///
  /// In en, this message translates to:
  /// **'Invalid port: {port}'**
  String invalidPort(String port);

  /// No description provided for @relayUnreachableManual.
  ///
  /// In en, this message translates to:
  /// **'Relay unreachable? Connect manually'**
  String get relayUnreachableManual;

  /// No description provided for @errorNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach relay. Check your network connection.'**
  String get errorNotConnected;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Relay did not respond in time. Try again.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Invalid token. Please scan the QR code again.'**
  String get errorUnauthorized;

  /// No description provided for @fallbackSwitched.
  ///
  /// In en, this message translates to:
  /// **'Relay unreachable — switched to {mode} automatically'**
  String fallbackSwitched(String mode);

  /// No description provided for @notifChannelName.
  ///
  /// In en, this message translates to:
  /// **'Blocked agents'**
  String get notifChannelName;

  /// No description provided for @notifBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Agent blocked'**
  String get notifBlockedTitle;

  /// No description provided for @notifBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'{agentName} is waiting for your response'**
  String notifBlockedBody(String agentName);

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @forgetThisDeviceButton.
  ///
  /// In en, this message translates to:
  /// **'Forget this device'**
  String get forgetThisDeviceButton;

  /// No description provided for @tapToSwitchDevice.
  ///
  /// In en, this message translates to:
  /// **'Tap to switch device'**
  String get tapToSwitchDevice;

  /// No description provided for @deviceOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get deviceOnline;

  /// No description provided for @deviceOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get deviceOffline;

  /// No description provided for @deviceUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get deviceUnknown;

  /// No description provided for @addDeviceChip.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addDeviceChip;

  /// No description provided for @agentPaneBusyRetry.
  ///
  /// In en, this message translates to:
  /// **'That pane is busy — creating a new tab…'**
  String get agentPaneBusyRetry;

  /// No description provided for @startAgentFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start the agent: {error}'**
  String startAgentFailed(String error);

  /// No description provided for @selectSessions.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectSessions;

  /// No description provided for @cancelSelection.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelSelection;

  /// No description provided for @closeSelected.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeSelected;

  /// No description provided for @closeSession.
  ///
  /// In en, this message translates to:
  /// **'Close session'**
  String get closeSession;

  /// No description provided for @closeSessionConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Close selected sessions?'**
  String get closeSessionConfirmTitle;

  /// No description provided for @closeSessionConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Will close {count} session(s) on this computer. This cannot be undone from the phone.'**
  String closeSessionConfirmBody(int count);

  /// No description provided for @closeSessionConfirmOne.
  ///
  /// In en, this message translates to:
  /// **'Close “{name}” on this computer? The tab/pane will be closed.'**
  String closeSessionConfirmOne(String name);

  /// No description provided for @sessionsClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed {count} session(s)'**
  String sessionsClosed(int count);

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
