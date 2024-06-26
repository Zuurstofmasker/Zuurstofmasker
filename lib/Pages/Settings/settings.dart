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
  final Settings editSettings = Settings.fromJson(settings.toJson());

  void onLogin() {
    if (formKey.currentState!.validate()) {
      setState(() {
        hasLoggedIn = true;
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Nav(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (hasLoggedIn)
            SettingsInputsContent(
              editSettings: editSettings,
            )
          else
            SettingsPasswordContent(
              onLogin: onLogin,
              formKey: formKey,
              editSettings: editSettings,
            ),
        ],
      ),
    );
  }
}

class SettingsPasswordContent extends StatelessWidget {
  final dynamic Function() onLogin;
  final GlobalKey<FormState> formKey;
  final Settings editSettings;

  const SettingsPasswordContent({
    super.key,
    required this.onLogin,
    required this.formKey,
    required this.editSettings,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsPageBase(
      leftChild: Form(
        key: formKey,
        child: ListView(padding: pagePadding, children: [
          const PageTitle(title: 'Wachtwoord'),
          const PaddingSpacing(
            multiplier: 2,
          ),
          InputField(
            isPassword: true,
            hintText: 'Vul wachtwoord in',
            validator: (password) {
              if (password != null && !settings.comparePassword(password)) {
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
  final Settings editSettings;
  SettingColors get colors => editSettings.colors;
  SettingLimits get limits => editSettings.limits;

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
  ];

  late TextEditingController cprPulseController =
      TextEditingController(text: limits.cprPulse.toString());
  late TextEditingController lowPulseController =
      TextEditingController(text: limits.lowPulse.toString());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SettingsInputsContent({
    super.key,
    required this.editSettings,
  });

  Future<void> saveSettings(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      PopupAndLoading.showLoading();
      await editSettings.updateSettingsToFile().then((value) {
        settings = editSettings;
        // Go back to the login screen
        pushPage(
            MaterialPageRoute(builder: ((context) => const SettingsPage())));
        PopupAndLoading.showSuccess('Instellingen opslaan gelukt');
      }).catchError((error) {
        PopupAndLoading.showError('Instellingen opslaan mislukt');
      });
      PopupAndLoading.endLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPageBase(
      // rightChild: const Padding(
      //   padding: pagePadding,
      //   child: Column(
      //     children: [
      //       PageTitle(title: 'Voorbeeld grafiek'),
      //     ],
      //   ),
      // ),
      leftChild: Form(
        key: formKey,
        child: ListView(
          padding: pagePadding,
          children: [
            const PageTitle(title: 'Grenswaarden'),
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
            const PageTitle(title: 'Nieuw wachtwoord'),
            const PaddingSpacing(),
            InputField(
              isRequired: false,
              hintText: 'Nieuw wachtwoord',
              validator: (password) {
                if ((password ?? '') == '') return null;

                if (settings.comparePassword(password!)) {
                  return 'Nieuw wachtwoord mag niet hetzelfde zijn';
                } else if (password.length < 8) {
                  return 'Wachtwoord moet minimaal 8 tekens lang zijn';
                }
                return null;
              },
              onChange: (password) => editSettings
                  .setPassword(password ?? editSettings.passwordHash),
            ),
            const PaddingSpacing(multiplier: 2),
            Button(
              onTap: () => saveSettings(context),
              text: 'Wijzigingen opslaan',
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
          width: 400,
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
