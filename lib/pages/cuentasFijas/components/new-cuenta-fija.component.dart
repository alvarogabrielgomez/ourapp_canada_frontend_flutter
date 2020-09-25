import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/models/CuentasFijas.dart';
import 'package:ourapp_canada/functions/dialogTrigger.dart';
import 'package:ourapp_canada/widgets/SlidingUpPanelMessages/sliding-up-panel-messages.widget.dart';

class NewCuentaFijaPanel extends StatefulWidget {
  @override
  _NewCuentaFijaPanelState createState() => _NewCuentaFijaPanelState();
}

class _NewCuentaFijaPanelState extends State<NewCuentaFijaPanel> {
  DialogMessages dialogMessages;

  CuentaFija cuentaFija = CuentaFija.newObject();
  bool busy = false;

  int _selectedIndex = 0;
  int _maxPage = 3;
  String formattedLocaleMoney;
  FocusNode focusNodeValueCuentaFija;
  FocusNode focusNodeName;
  FocusNode focusNodeDescription;

  var moneyMaskControllerCuentaFija = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');
  var nameController = new TextEditingController();
  var descriptionController = new TextEditingController();
  final pageViewController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    focusNodeValueCuentaFija = FocusNode();
    focusNodeName = FocusNode();
    focusNodeDescription = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNodeValueCuentaFija.dispose();
    focusNodeName.dispose();
    focusNodeDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _validateIfHaveData(context),
      child: Stack(
        children: [
          Container(
            child: PageView(
              onPageChanged: (page) {
                setState(() {
                  _selectedIndex = page;
                });
              },
              physics: NeverScrollableScrollPhysics(),
              controller: pageViewController,
              children: [
                page1(moneyMaskControllerCuentaFija),
                page2(nameController),
                page3(descriptionController),
                page4(),
                pageSubmit(),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
                child: Container(
                  height: 60,
                  child: Stack(
                    children: [
                      _selectedIndex == 2
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: FloatingActionButton(
                                onPressed: () {
                                  _submitPage();
                                },
                                tooltip: 'Submit',
                                child: Icon(Icons.check),
                              ),
                            )
                          : _selectedIndex < 2
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      _nextPage();
                                    },
                                    tooltip: 'Next',
                                    child: Icon(Icons.arrow_forward),
                                  ),
                                )
                              : Container(),
                      _selectedIndex > 0 && _selectedIndex < 3
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: FloatingActionButton(
                                onPressed: () {
                                  _backPage();
                                },
                                tooltip: 'Back',
                                child: Icon(Icons.arrow_back),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
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

  inputName({TextEditingController controller}) {
    return TextField(
      focusNode: focusNodeName,
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      decoration: null,
      textInputAction: TextInputAction.go,
      autofocus: false,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: TextStyle(color: textColor, fontFamily: 'Lato', fontSize: 20),
      cursorColor: Colors.transparent,
      onChanged: (value) {
        setState(() {
          cuentaFija.name = value;
        });
      },
      onSubmitted: (value) {
        focusNodeName.unfocus();
        _nextPage();
      },
    );
  }

  Future<Null> selectDate(BuildContext context) async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: null,
    );
  }

  inputDate() {}

  inputDescription({TextEditingController controller}) {
    return TextField(
      focusNode: focusNodeDescription,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      decoration: null,
      textInputAction: TextInputAction.go,
      autofocus: false,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: TextStyle(color: textColor, fontFamily: 'Lato', fontSize: 20),
      cursorColor: Colors.transparent,
      onChanged: (value) {
        setState(() {
          cuentaFija.description = value;
        });
      },
      onSubmitted: (value) {
        focusNodeDescription.unfocus();
        _submitPage();
      },
    );
  }

  inputMoney({MoneyMaskedTextController controller}) {
    return Row(
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
              focusNode: focusNodeValueCuentaFija,
              autofocus: true,
              controller: controller,
              decoration: null,
              textInputAction: TextInputAction.go,
              onChanged: (value) {
                String valor =
                    controller.text.replaceAll(".", "").replaceAll(",", ".");
                double valorDouble = double.tryParse(valor);

                setState(() {
                  cuentaFija.value = valorDouble;
                  formattedLocaleMoney = controller.text;
                });
                print(valor);
              },
              onSubmitted: (value) {
                focusNodeValueCuentaFija.unfocus();
                _nextPage();
              },
              keyboardType: TextInputType.number,
              style: TextStyle(fontFamily: 'Lato', fontSize: 40),
              cursorColor: Colors.transparent,
            ),
          ),
        )
      ],
    );
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

  void _nextPage() {
    int actualIndex = _selectedIndex;
    int passTo = actualIndex <= _maxPage ? actualIndex + 1 : _maxPage;
    switch (passTo) {
      case 0:
        focusNodeValueCuentaFija.requestFocus();
        break;
      case 1:
        focusNodeName.requestFocus();
        break;
      case 2:
        focusNodeDescription.requestFocus();
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
        focusNodeValueCuentaFija.requestFocus();
        break;
      case 1:
        focusNodeName.requestFocus();
        break;
      case 2:
        focusNodeDescription.requestFocus();
        break;
      default:
    }
    return _onItemTapped(passTo);
  }

  void _submitPage() async {
    int passTo = 3;
    focusNodeDescription.unfocus();

    _onItemTapped(passTo);
    await new CuentaFija().create(cuentaFija).then((response) {
      Navigator.pop(context, true);
      DialogMessages.openDialogMessage(
          context: this.context,
          title: response.success ? "Listo!" : "Error",
          typeMessage:
              response.success ? TypeMessages.SUCCESS : TypeMessages.ERROR,
          message: response.message.toString());
      // print(response);
      return;
    }).catchError((err) {
      Navigator.pop(context, false);
      DialogMessages.openDialogMessage(
          context: this.context,
          title: "Error",
          typeMessage: TypeMessages.ERROR,
          message: err.toString());
      // print(response);
      return;
    });
  }

  page1(MoneyMaskedTextController moneyMaskController) {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          h1TituloPage1,
          SizedBox(
            height: 25,
          ),
          inputMoney(controller: moneyMaskController),
        ],
      ),
    );
  }

  page2(TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          h1TituloPage2,
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: inputName(controller: controller),
          )
        ],
      ),
    );
  }

  page3(TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          h1TituloPage3,
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: inputDescription(controller: controller),
          )
        ],
      ),
    );
  }

  page4() {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          h1TituloPage4,
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: inputDate(),
          )
        ],
      ),
    );
  }

  pageSubmit() {
    return Center(child: CircularProgressIndicator());
  }

  Widget h1TituloPage1 = Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
          style: TextStyle(color: textColor, fontSize: 25, fontFamily: 'Lato'),
          children: [
            TextSpan(
                text: 'Cual ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'es el valor de la cuenta?'),
          ]),
    ),
  );

  Widget h1TituloPage3 = Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
          style: TextStyle(color: textColor, fontSize: 25, fontFamily: 'Lato'),
          children: [
            TextSpan(
                text: 'Escribe ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'el una descripcion de la cuenta fija'),
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
                text: 'Cual ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'el nombre de la cuenta fija'),
          ]),
    ),
  );

  Widget h1TituloPage4 = Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
          style: TextStyle(color: textColor, fontSize: 25, fontFamily: 'Lato'),
          children: [
            TextSpan(
                text: 'Cual ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'sería la fecha de pago?'),
          ]),
    ),
  );
}
