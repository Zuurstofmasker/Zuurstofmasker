import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Models/settings.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/Widgets/titles.dart';

void main() async {
  runApp(const SettingsPage());
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool hasLoggedIn = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Settings? settings;

  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  void onLogin() {
    if (formKey.currentState!.validate()) {
      setState(() {
        hasLoggedIn = true;
      });
    }
  }

  Future<void> loadSettings() async {
    settings = await Settings.getSettingsFromFile();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Nav(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (hasLoggedIn && settings != null)
            SettingsInputsContent(
              settings: settings!,
            )
          else
            SettingsPasswordContent(
              onLogin: onLogin,
              formKey: formKey,
              getSettings: () => settings,
            ),
        ],
      ),
    );
  }
}

class SettingsPasswordContent extends StatelessWidget {
  final dynamic Function() onLogin;
  final GlobalKey<FormState> formKey;
  final Settings? Function() getSettings;
  Settings? get settings => getSettings();

  const SettingsPasswordContent({
    super.key,
    required this.onLogin,
    required this.formKey,
    required this.getSettings,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsPageBase(
      leftChild: Form(
        key: formKey,
        child: ListView(padding: pagePadding, children: [
          const PageTitle(title: 'Password'),
          const PaddingSpacing(
            multiplier: 2,
          ),
          InputField(
            isPassword: true,
            hintText: 'Vul wachtwoord in',
            validator: (password) {
              if (settings == null) return 'Settings not loaded';

              if (password != null && !settings!.comparePassword(password)) {
                return 'Wachtwoord is incorrect';
              }

              return null;
            },
          ),
          const PaddingSpacing(),
          Button(onTap: onLogin, text: 'Inloggen'),
        ]),
      ),
    );
  }
}

// ignore: must_be_immutable
class SettingsInputsContent extends StatelessWidget {
  final Settings settings;
  SettingColors get colors => settings.colors;
  SettingLimits get limits => settings.limits;

  final List<DropdownMenuItem<LimitType>> dropDownItems = const [
    DropdownMenuItem(
      value: LimitType.AHA,
      child: Text('AHA'),
    ),
    DropdownMenuItem(
      value: LimitType.ERC,
      child: Text('ERC'),
    ),
    DropdownMenuItem(
      value: LimitType.ARC,
      child: Text('ARC'),
    ),
    DropdownMenuItem(
      value: LimitType.TenToFiftyDawson,
      child: Text('10-50 Dawson'),
    ),
    DropdownMenuItem(
      value: LimitType.TenToNinetyDawson,
      child: Text('10-90 Dawson'),
    ),
    DropdownMenuItem(
      value: LimitType.Custom,
      child: Text('Custom'),
    ),
  ];

  late TextEditingController cprPulseController =
      TextEditingController(text: limits.cprPulse.toString());
  late TextEditingController lowPulseController =
      TextEditingController(text: limits.lowPulse.toString());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SettingsInputsContent({
    super.key,
    required this.settings,
  });

  Future<void> saveSettings(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      PopupAndLoading.showLoading();
      await settings.updateSettingsToFile().then((value) {
        // Go back to the login screen
        pushPage(
            MaterialPageRoute(builder: ((context) => const SettingsPage())));
        PopupAndLoading.showSuccess('Opslaan gelukt');
      }).catchError((error) {
        PopupAndLoading.showError('Opslaan mislukt');
      });
      PopupAndLoading.endLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPageBase(
      rightChild: const Padding(
        padding: pagePadding,
        child: Column(
          children: [
            PageTitle(title: 'Voorbeeld grafiek'),
          ],
        ),
      ),
      leftChild: Form(
        key: formKey,
        child: ListView(
          padding: pagePadding,
          children: [
            const PageTitle(title: 'Genswaarden'),
            const PaddingSpacing(multiplier: 1),
            const SubTitle(title: 'SpO2'),
            const PaddingSpacing(),
            InputDropDown<LimitType>(
              items: dropDownItems,
              value: limits.spO2,
              onChange: (value) => limits.spO2 = value ?? limits.spO2,
            ),
            const PaddingSpacing(),
            const SubTitle(title: 'cSrO2'),
            const PaddingSpacing(),
            InputDropDown<LimitType>(
              items: dropDownItems,
              value: limits.cSrO2,
              onChange: (value) => limits.cSrO2 = value ?? limits.cSrO2,
            ),
            const PaddingSpacing(),
            const SubTitle(title: 'cFTOE'),
            const PaddingSpacing(),
            InputDropDown<LimitType>(
              items: dropDownItems,
              value: limits.cFTOE,
              onChange: (value) => limits.cFTOE = value ?? limits.cFTOE,
            ),
            const PaddingSpacing(),
            const SubTitle(title: 'Pulse'),
            const PaddingSpacing(),
            InputField(
              labelText: 'CPR Pulse',
              isInt: true,
              controller: cprPulseController,
              onChange: (value) => limits.cprPulse =
                  int.tryParse(value ?? '') ?? limits.cprPulse,
            ),
            const PaddingSpacing(),
            InputField(
              labelText: 'Low Pulse',
              isInt: true,
              controller: lowPulseController,
              onChange: (value) => limits.lowPulse =
                  int.tryParse(value ?? '') ?? limits.lowPulse,
            ),
            const PaddingSpacing(multiplier: 2),
            const PageTitle(title: 'Kleuren'),
            const PaddingSpacing(),
            InputColor(
              value: colors.spO2,
              labelText: 'SpO2',
              onChange: (color) => colors.spO2 = color,
            ),
            const PaddingSpacing(),
            InputColor(
                value: colors.pulse,
                labelText: 'Pulse',
                onChange: (color) => colors.pulse = color),
            const PaddingSpacing(),
            InputColor(
                value: colors.fiO2,
                labelText: 'FiO2',
                onChange: (color) => colors.fiO2 = color),
            const PaddingSpacing(),
            InputColor(
                value: colors.flow,
                labelText: 'Flow',
                onChange: (color) => colors.flow = color),
            const PaddingSpacing(),
            InputColor(
                value: colors.leak,
                labelText: 'Leak',
                onChange: (color) => colors.leak = color),
            const PaddingSpacing(),
            InputColor(
              value: colors.pressure,
              labelText: 'Pressure',
              onChange: (color) => colors.pressure = color,
            ),
            const PaddingSpacing(),
            InputColor(
              value: colors.tidalVolume,
              labelText: 'Tidal Volume',
              onChange: (color) => colors.tidalVolume = color,
            ),
            const PaddingSpacing(),
            InputColor(
              value: colors.limitValues,
              labelText: 'Limit Values',
              onChange: (color) => colors.limitValues = color,
            ),
            const PaddingSpacing(multiplier: 2),
            const PageTitle(title: 'Nieuw Wachtwoord'),
            const PaddingSpacing(),
            InputField(
              isRequired: false,
              hintText: 'Nieuw wachtwoord',
              onChange: (password) =>
                  settings.setPassword(password ?? settings.passwordHash),
            ),
            const PaddingSpacing(multiplier: 2),
            Button(
              onTap: () => saveSettings(context),
              text: 'Opslaan',
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPageBase extends StatelessWidget {
  final Widget leftChild;
  final Widget? rightChild;

  const SettingsPageBase({
    super.key,
    required this.leftChild,
    this.rightChild,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 325,
          height: double.infinity,
          child: leftChild,
        ),
        const VerticalDivider(
          width: 2,
          color: greyTextColor,
        ),
        if (rightChild != null) rightChild!,
      ],
    );
  }
}
