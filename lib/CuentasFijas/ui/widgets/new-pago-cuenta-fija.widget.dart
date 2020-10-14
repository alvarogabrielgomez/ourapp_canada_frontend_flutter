import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/CuentasFijas/models/CuentasFijas.dart';
import 'package:ourapp_canada/CuentasFijas/models/PagoCuentaFija.dart';
import 'package:ourapp_canada/CuentasFijas/ui/widgets/date-cuenta-picker.widget.dart';
import 'package:ourapp_canada/widgets/SlidingUpPanelMessages/dialogTrigger.dart';
import 'package:ourapp_canada/widgets/SlidingUpPanelMessages/sliding-up-panel-messages.widget.dart';
import 'package:ourapp_canada/widgets/customPlugins/slide_popup_dialog-0.0.2/numberPicker.dart';

class NewPagoCuentaFijaPanel extends StatefulWidget {
  final CuentaFija cuentaFija;

  NewPagoCuentaFijaPanel({@required this.cuentaFija});
  @override
  _NewPagoCuentaFijaPanelState createState() => _NewPagoCuentaFijaPanelState();
}

class _NewPagoCuentaFijaPanelState extends State<NewPagoCuentaFijaPanel> {
  DialogMessages dialogMessages;

  _NewPagoCuentaFijaPanelState state;

  final PagoCuentaFija pagoCuentaFija = PagoCuentaFija.newObject();
  DateTime selectedDate;
  DateTime firstDate;
  DateTime lastDate;
  bool busy = false;
  int _maxPage = 2;
  int _selectedIndex = 0;

  FocusNode focusNodeValuePagoCuentaFija;
  String formattedLocaleMoney;
  var moneyMaskControllerCuentaFija = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');
  final pageViewController = new PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    focusNodeValuePagoCuentaFija = FocusNode();
    state = this;
    selectedDate = DateTime(DateTime.now().year, DateTime.now().month,
        widget.cuentaFija.dayOfPayment);
    firstDate = DateTime(DateTime.now().year, 1, 1);
    lastDate = DateTime(DateTime.now().year, 12, 31);
    pagoCuentaFija.idCuentaFija = widget.cuentaFija.id;
    pagoCuentaFija.value = widget.cuentaFija.value;
    moneyMaskControllerCuentaFija.text =
        pagoCuentaFija.value.toStringAsFixed(2);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNodeValuePagoCuentaFija.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _validateIfHaveData(context),
      child: Stack(
        children: [
          PageView(
            onPageChanged: _onPageChange,
            physics: NeverScrollableScrollPhysics(),
            controller: pageViewController,
            children: [
              page1(),
              page2(),
              submitPage(),
            ],
          ),
          bottomBtns(),
        ],
      ),
    );
  }

  void _onPageChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//btn
  bottomBtns() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
        child: Container(
          height: 60,
          child: Stack(
            children: [
              _selectedIndex == 1
                  ? floatingBtnSubmit()
                  : _selectedIndex < 1 ? floatingBtnNext() : Container(),
              _selectedIndex > 0 && _selectedIndex < 2
                  ? floatingBtnBack()
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  floatingBtnSubmit() {
    return Align(
      alignment: Alignment.centerRight,
      child: FloatingActionButton(
        onPressed: () {
          _submit();
        },
        tooltip: 'Submit',
        child: Icon(Icons.check),
      ),
    );
  }

  floatingBtnNext() {
    return Align(
      alignment: Alignment.centerRight,
      child: FloatingActionButton(
        onPressed: () {
          _nextPage();
        },
        tooltip: 'Next',
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  floatingBtnBack() {
    return Align(
      alignment: Alignment.centerLeft,
      child: FloatingActionButton(
        onPressed: () {
          _backPage();
        },
        tooltip: 'Back',
        child: Icon(Icons.arrow_back),
      ),
    );
  }

// PAGES
  page1() {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          h1TituloPage1,
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "R\$",
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Lato',
                  fontSize: 36,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  child: TextField(
                    focusNode: focusNodeValuePagoCuentaFija,
                    autofocus: true,
                    controller: moneyMaskControllerCuentaFija,
                    decoration: null,
                    textInputAction: TextInputAction.go,
                    onChanged: _onChangedMoney,
                    onSubmitted: (value) {
                      focusNodeValuePagoCuentaFija.unfocus();
                      _nextPage();
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontFamily: 'Lato', fontSize: 40),
                    cursorColor: Colors.transparent,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  page2() {
    return Padding(
        padding: EdgeInsets.only(top: 12, left: 20, right: 20),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            h1TituloPage2,
            SizedBox(
              height: 25,
            ),
            DatePickerWidget(state),
            SizedBox(
              height: 100,
            ),
          ],
        ));
  }

  submitPage() {
    return Center(child: CircularProgressIndicator());
  }

  // headers Pages
  Widget h1TituloPage1 = Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
          style: TextStyle(color: textColor, fontSize: 25, fontFamily: 'Lato'),
          children: [
            TextSpan(
                text: 'Cuanto ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'se pagó este mes?'),
          ]),
    ),
  );

  Widget h1TituloPage2 = Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
          style: TextStyle(color: textColor, fontSize: 25, fontFamily: 'Lato'),
          children: [
            TextSpan(
                text: 'Cuando ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'se pago esta cuenta del mes?'),
          ]),
    ),
  );

  // Functions

  void _submitRoutine() async {
    try {
      var creating = await new PagoCuentaFija().create(pagoCuentaFija);
      Navigator.pop(context, creating.success ? true : false);
      DialogMessages.openDialogMessage(
        context: this.context,
        title: creating.success ? "Listo!" : "Error",
        typeMessage:
            creating.success ? TypeMessages.SUCCESS : TypeMessages.ERROR,
        message: creating.message.toString(),
      );
      return;
    } catch (onError) {
      Navigator.pop(context, false);
      DialogMessages.openDialogMessage(
          context: this.context,
          title: "Error",
          typeMessage: TypeMessages.ERROR,
          message: onError.toString());
      // print(response);
      return;
    }
  }

  void _submit() {
    int passTo = 2;
    _onItemTapped(passTo);
    _submitRoutine();
  }

  void _nextPage() {
    int actualIndex = _selectedIndex;
    int passTo = actualIndex <= _maxPage ? actualIndex + 1 : _maxPage;
    switch (passTo) {
      case 0:
        focusNodeValuePagoCuentaFija.requestFocus();
        break;
      case 1:
        focusNodeValuePagoCuentaFija.unfocus();
        break;
      default:
    }

    return _onItemTapped(passTo);
  }

  void _backPage() {
    int actualIndex = _selectedIndex;
    int passTo = actualIndex > 0 ? actualIndex - 1 : 0;
    switch (passTo) {
      case 0:
        focusNodeValuePagoCuentaFija.requestFocus();
        break;
      case 1:
        focusNodeValuePagoCuentaFija.unfocus();
        break;
      default:
    }
    return _onItemTapped(passTo);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageViewController.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  void _onChangedMoney(String value) {
    String valor = moneyMaskControllerCuentaFija.text
        .replaceAll(".", "")
        .replaceAll(",", ".");
    double valorDouble = double.tryParse(valor);

    setState(() {
      pagoCuentaFija.value = valorDouble;
      formattedLocaleMoney = moneyMaskControllerCuentaFija.text;
    });
    print(valor);
  }

  Future<bool> _validateIfHaveData(BuildContext context) async {
    print("Validating if have data");
    if (moneyMaskControllerCuentaFija.text != "0,00") {
      print("Have data on it");
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Widget dayPicker() {
    var mesString = DateFormat.MMMM("es_ES").format(pagoCuentaFija.date);

    return Expanded(
      flex: 1,
      child: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new NumberPicker.horizontal(
              initialValue: pagoCuentaFija.date.day,
              minValue: 1,
              haptics: true,
              fontSize: 40,
              maxValue: new DateTime(
                      DateTime.now().year,
                      DateTime.now().month + 1,
                      0) // get last day of month as maxValue
                  .day,
              onChanged: _onSelectedDateChanged,
            ),
            SizedBox(
              height: 50,
            ),
            RichText(
              text: TextSpan(
                  style: TextStyle(
                      color: textSecondaryColor,
                      fontSize: 18,
                      fontFamily: 'Lato'),
                  children: [
                    TextSpan(text: 'Se pagó el '),
                    TextSpan(
                      text: pagoCuentaFija.date.day.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' de $mesString.'),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectedDateChanged(num newDate) {
    setState(() {
      pagoCuentaFija.date =
          new DateTime(DateTime.now().year, DateTime.now().month, newDate);
    });
  }
}
