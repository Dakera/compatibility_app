// C:\Users\Dakera\flutter_projects\compatibility_app\lib\widgets\track_dialog.dart

import 'package:flutter/material.dart';
import 'package:compatibility_app/classes/tracked_medications.dart';
import 'package:compatibility_app/data/tracked.dart';
import 'package:compatibility_app/services/notification_manager.dart';
import 'package:compatibility_app/classes/app_notification.dart';

class TrackMedicationDialog extends StatefulWidget {
  final String medicationName;
  final String? medicationId;

  const TrackMedicationDialog({
    super.key,
    required this.medicationName,
    this.medicationId,
  });

  @override
  State<TrackMedicationDialog> createState() => _TrackMedicationDialogState();
}

class _TrackMedicationDialogState extends State<TrackMedicationDialog> {
  int currentStep = 0;

  final GlobalKey<FormState> _formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep2 = GlobalKey<FormState>();

  final TextEditingController customNameController = TextEditingController();

  MedicationForm? selectedForm;
  String? selectedDosage;
  DosageUnit? selectedUnit;

  bool _createNotification = false;
  TimeOfDay? selectedTime;
  NotificationFrequency? selectedFrequency;

  final Map<MedicationForm, String> formNames = {
    MedicationForm.tablet: 'Таблетка',
    MedicationForm.capsule: 'Капсула',
    MedicationForm.syrup: 'Сироп',
  };

  final List<String> dosages = ['250', '500', '1000'];

  final Map<DosageUnit, String> unitNames = {
    DosageUnit.mg: 'мг',
    DosageUnit.ml: 'мл',
  };

  final Map<NotificationFrequency, String> frequencyNames = {
    NotificationFrequency.daily: 'Ежедневно',
    NotificationFrequency.everyTwoDays: 'Раз в 2 дня',
    NotificationFrequency.weekly: 'Раз в неделю',
    NotificationFrequency.monthly: 'Ежемесячно',
  };

  @override
  void initState() {
    super.initState();
    customNameController.text = widget.medicationName;
  }

  @override
  void dispose() {
    customNameController.dispose();
    super.dispose();
  }

  void nextStep() {
    bool isValid = false;
    if (currentStep == 0) {
      isValid = _formKeyStep1.currentState?.validate() ?? false;
    } else if (currentStep == 1) {
      isValid = _formKeyStep2.currentState?.validate() ?? false;
      if (isValid && (selectedForm == null || selectedDosage == null || selectedUnit == null)) {
        isValid = false;
      }
    } else {
      if (_createNotification) {
        if (selectedTime == null || selectedFrequency == null) {
          isValid = false;
          // ИСПРАВЛЕНО: Добавлена проверка `mounted` перед использованием `context`
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Пожалуйста, выберите время и частоту уведомления.')),
            );
          }
        } else {
          isValid = true;
        }
      } else {
        isValid = true;
      }
    }

    if (isValid) {
      if (currentStep < 2) {
        setState(() {
          currentStep++;
        });
      } else {
        _finish();
      }
    }
  }

  void _finish() async {
    if (selectedForm == null || selectedDosage == null || selectedUnit == null) {
      print('Основные поля формы не заполнены.');
      return;
    }

    AppNotification? appNotification;
    if (_createNotification && selectedTime != null && selectedFrequency != null) {
      appNotification = AppNotification.fromTrackedMedication(
        medicationId: widget.medicationId ?? UniqueKey().toString(),
        medicationName: customNameController.text.isNotEmpty ? customNameController.text : widget.medicationName,
        reminderTime: selectedTime,
        frequency: selectedFrequency,
      );

      if (appNotification != null) {
        await NotificationManager().scheduleNotification(appNotification);
      } else {
        print('Не удалось создать объект уведомления. Проверьте время и частоту.');
      }
    }

    final trackedMedication = TrackedMedication(
      medicationId: widget.medicationId ?? UniqueKey().toString(),
      customName: customNameController.text.isNotEmpty ? customNameController.text : widget.medicationName,
      form: selectedForm!,
      dosage: double.parse(selectedDosage!),
      dosageUnit: selectedUnit!,
      reminderTime: _createNotification ? selectedTime : null,
      frequency: _createNotification ? selectedFrequency : null,
      notificationId: appNotification?.id,
    );

    TrackedMedicationsStore().addMedication(trackedMedication);

    // ИСПРАВЛЕНО: Добавлена проверка `mounted` перед использованием `context`
    if (mounted) {
      Navigator.of(context).pop();
    }

    print('Добавлено в отслеживаемое:');
    print('ID: ${trackedMedication.medicationId}');
    print('Имя: ${trackedMedication.customName}');
    print('Форма: ${formNames[trackedMedication.form]}');
    print('Дозировка: ${trackedMedication.dosage} ${unitNames[trackedMedication.dosageUnit]}');
    print('Время: ${trackedMedication.reminderTime?.format(context) ?? 'N/A'}');
    print('Частота: ${frequencyNames[trackedMedication.frequency] ?? 'N/A'}');
    print('ID Уведомления: ${trackedMedication.notificationId ?? 'N/A'}');
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: customNameController,
            decoration: const InputDecoration(
              labelText: 'Собственное название (опционально)',
              hintText: 'Введите название',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<MedicationForm>(
            value: selectedForm,
            decoration: const InputDecoration(labelText: 'Форма'),
            items: MedicationForm.values.map((form) {
              return DropdownMenuItem(value: form, child: Text(formNames[form]!));
            }).toList(),
            onChanged: (value) => setState(() => selectedForm = value),
            validator: (value) {
              if (value == null) {
                return 'Пожалуйста, выберите форму';
              }
              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedDosage,
                  decoration: const InputDecoration(labelText: 'Дозировка'),
                  items: dosages.map((d) {
                    return DropdownMenuItem(value: d, child: Text(d));
                  }).toList(),
                  onChanged: (value) => setState(() => selectedDosage = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, выберите дозировку';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<DosageUnit>(
                  value: selectedUnit,
                  decoration: const InputDecoration(labelText: 'Единица'),
                  items: DosageUnit.values.map((u) {
                    return DropdownMenuItem(value: u, child: Text(unitNames[u]!));
                  }).toList(),
                  onChanged: (value) => setState(() => selectedUnit = value),
                  validator: (value) {
                    if (value == null) {
                      return 'Пожалуйста, выберите единицу';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          title: const Text('Создать уведомление'),
          value: _createNotification,
          onChanged: (bool value) {
            setState(() {
              _createNotification = value;
              if (_createNotification) {
                selectedTime = TimeOfDay.now();
                selectedFrequency = NotificationFrequency.daily;
              } else {
                selectedTime = null;
                selectedFrequency = null;
              }
            });
          },
        ),
        if (_createNotification) ...[
          ListTile(
            title: Text('Время приёма: ${selectedTime?.format(context) ?? 'Выберите время'}'),
            trailing: const Icon(Icons.access_time),
            onTap: _pickTime,
          ),
          DropdownButtonFormField<NotificationFrequency>(
            value: selectedFrequency,
            decoration: const InputDecoration(labelText: 'Частота'),
            items: NotificationFrequency.values.map((freq) {
              return DropdownMenuItem(value: freq, child: Text(frequencyNames[freq] ?? freq.toString()));
            }).toList(),
            onChanged: (value) => setState(() => selectedFrequency = value!),
            validator: (value) {
              if (_createNotification && value == null) {
                return 'Пожалуйста, выберите частоту';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Добавить "${widget.medicationName}"'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentStep == 0) _buildStep1(),
            if (currentStep == 1) _buildStep2(),
            if (currentStep == 2) _buildStep3(),
          ],
        ),
      ),
      actions: [
        if (currentStep > 0)
          TextButton(
            onPressed: () => setState(() => currentStep--),
            child: const Text('Назад'),
          ),
        TextButton(
          onPressed: nextStep,
          child: Text(currentStep == 2 ? 'Готово' : 'Далее'),
        ),
      ],
    );
  }
}
