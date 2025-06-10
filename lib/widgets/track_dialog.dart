// C:\Users\Dakera\flutter_projects\compatibility_app\lib\widgets\track_dialog.dart

import 'package:flutter/material.dart';
import 'package:compatibility_app/classes/tracked_medications.dart';
import '../data/tracked.dart';

class TrackMedicationDialog extends StatefulWidget {
  final String medicationName;
  final String? medicationId; // ДОБАВЛЕНО/ИСПРАВЛЕНО: Теперь medicationId является частью виджета

  const TrackMedicationDialog({
    super.key,
    required this.medicationName,
    this.medicationId, // ДОБАВЛЕНО/ИСПРАВЛЕНО: Принимаем medicationId в конструкторе
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

  TimeOfDay selectedTime = TimeOfDay.now();
  // Убедитесь, что selectedFrequency всегда инициализировано
  NotificationFrequency selectedFrequency = NotificationFrequency.daily; 

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
    NotificationFrequency.monthly: 'Раз в месяц',
    // Добавьте другие частоты, если нужно
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
      // Дополнительная проверка на null для полей из Step 2
      if (isValid && (selectedForm == null || selectedDosage == null || selectedUnit == null)) {
        isValid = false;
        // Можно добавить сообщение пользователю о необходимости заполнить все поля
      }
    } else {
      isValid = true;
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

  void _finish() {
    // Использование NotificationFrequency.values.byName() для конвертации
    // Это предполагает, что имена в MedicationFrequency и NotificationFrequency совпадают.
    // Если они отличаются, вам понадобится явное сопоставление.

    // final NotificationFrequency finalFrequency = NotificationFrequency.values.byName(selectedFrequency.name);
    // ^ Эту строку можно упростить, так как selectedFrequency уже является нужным типом.

    final trackedMedication = TrackedMedication(
      medicationId: widget.medicationId ?? UniqueKey().toString(),
      customName: customNameController.text.isNotEmpty ? customNameController.text : widget.medicationName,
      form: selectedForm!,
      dosage: double.parse(selectedDosage!),
      dosageUnit: selectedUnit!,
      reminderTime: selectedTime,
      frequency: selectedFrequency, // Используйте selectedFrequency напрямую
    );

    // Вместо pop с результатом, добавляем в стор
    TrackedMedicationsStore().addMedication(trackedMedication);

    // Просто закрываем диалог
    Navigator.of(context).pop();

    print('Добавлено в отслеживаемое:');
    print('ID: ${trackedMedication.medicationId}');
    print('Имя: ${trackedMedication.customName}');
    print('Форма: ${formNames[trackedMedication.form]}');
    print('Дозировка: ${trackedMedication.dosage} ${unitNames[trackedMedication.dosageUnit]}');
    print('Время: ${trackedMedication.reminderTime.format(context)}');
    print('Частота: ${frequencyNames[selectedFrequency]}'); // Для печати можно использовать map frequencyNames
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
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
        ListTile(
          title: Text('Время приёма: ${selectedTime.format(context)}'),
          trailing: const Icon(Icons.access_time),
          onTap: _pickTime,
        ),
        DropdownButtonFormField<NotificationFrequency>(
          value: selectedFrequency,
          decoration: const InputDecoration(labelText: 'Частота'),
          items: NotificationFrequency.values.map((freq) {
            return DropdownMenuItem(value: freq, child: Text(frequencyNames[freq]!));
          }).toList(),
          onChanged: (value) => setState(() => selectedFrequency = value!),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Добавить препарат'),
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
