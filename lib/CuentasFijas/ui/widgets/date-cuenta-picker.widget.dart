import 'package:flutter/material.dart';

import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/widgets/btn/btn.widget.dart';

class DatePickerWidget extends StatefulWidget {
  final dynamic statePadre;
  DatePickerWidget(this.statePadre);
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  // DateTime _selectedDate;
  // DateTime _firstDate;
  // DateTime _lastDate;
  Color selectedSingleDateDecorationColor;
  bool selectedToday = false;

  @override
  void initState() {
    super.initState();
    // _selectedDate = DateTime.now();
    // _firstDate = DateTime(DateTime.now().year, 1, 1);
    // _lastDate = DateTime(DateTime.now().year, 12, 31);
  }

  @override
  Widget build(BuildContext context) {
    // add selected colors to default settings

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: double.infinity,
          constraints: BoxConstraints(maxHeight: 350),
          child: dp.DayPicker(
            selectedDate: widget.statePadre.selectedDate,
            onChanged: _onSelectedDateChanged,
            firstDate: widget.statePadre.firstDate,
            lastDate: widget.statePadre.lastDate,
            datePickerStyles: dp.DatePickerRangeStyles(
              disabledDateStyle: TextStyle(color: Colors.grey),
              selectedDateStyle: Theme.of(context)
                  .accentTextTheme
                  .bodyText1
                  .copyWith(color: redCanada),
              selectedSingleDateDecoration: BoxDecoration(
                  border: Border.all(
                    color: redCanada,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  color: Colors.transparent,
                  shape: BoxShape.circle),
            ),
            datePickerLayoutSettings: dp.DatePickerLayoutSettings(
                maxDayPickerRowCount: 2,
                showPrevMonthEnd: false,
                showNextMonthStart: false),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        !selectedToday
            ? Container(
                child: Center(
                  child: Container(
                    width: 90,
                    child: LoadingButtom(
                      btnLabel: "Hoy",
                      invert: false,
                      busy: false,
                      btnOnPressed: () {
                        selectedToday = true;
                        widget.statePadre.pagoCuentaFija.date = DateTime.now();
                        widget.statePadre.setState(() {
                          widget.statePadre.selectedDate = DateTime.now();
                        });
                      },
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  void _onSelectedDateChanged(DateTime newDate) {
    var now = DateTime.now();
    if (newDate.month == now.month &&
        newDate.year == now.year &&
        newDate.day == now.day) {
      selectedToday = true;
    } else {
      selectedToday = false;
    }
    widget.statePadre.selectedDate = newDate;

    widget.statePadre.setState(() {
      widget.statePadre.pagoCuentaFija.date = newDate;
    });
  }
}
