import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/Purchases/models/Purchase.dart';
import 'package:ourapp_canada/Purchases/models/TypePurchase.model.dart';
import 'package:ourapp_canada/sharedPreferences.dart';
import 'package:ourapp_canada/widgets/SlidingUpPanelMessages/dialogTrigger.dart';
import 'package:ourapp_canada/widgets/SlidingUpPanelMessages/sliding-up-panel-messages.widget.dart';

class NewPurchasePanel extends StatefulWidget {
  @override
  _NewPurchasePanelState createState() => _NewPurchasePanelState();
}

class _NewPurchasePanelState extends State<NewPurchasePanel> {
  DialogMessages dialogMessages;

  Purchase purchase = Purchase.newObject();
  bool busy = false;

  List<TypePurchase> _typesOfPurchases = getTypesOfPurchases();

  int _selectedIndex = 0;
  int _maxPage = 3;
  String formattedLocaleMoney;
  FocusNode focusNodeValuePurchase;
  FocusNode focusNodeDescription;
  SharedPreferencesClass sharedPreferences = new SharedPreferencesClass();
  var moneyMaskControllerPurchase = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');
  var descriptionController = new TextEditingController();
  final pageViewController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    focusNodeValuePurchase = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNodeValuePurchase.dispose();
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
                page1(moneyMaskControllerPurchase),
                page2(),
                page3(descriptionController),
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
                                  focusNodeValuePurchase.unfocus();
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
                                      focusNodeValuePurchase.unfocus();
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
    if (moneyMaskControllerPurchase.text != "0,00") {
      print("Have data on it");
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  _onTypePurchaseSelected(bool selected, type) {
    if (selected == true) {
      setState(() {
        purchase.types.add(type);
      });
    } else {
      setState(() {
        purchase.types.remove(type);
      });
    }
    print(purchase.types);
  }

  _onTypePurchaseSelectedRadio(type) {
    setState(() {
      purchase.types = [];
      purchase.types.add(type);
    });
    print(purchase.types);
  }

  listTypeOfPurchaseRadio() {
    return ListView.builder(
      itemCount: _typesOfPurchases.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return RadioListTile(
          title: Text(_typesOfPurchases[index].name),
          value: _typesOfPurchases[index].name,
          onChanged: (selected) {
            _onTypePurchaseSelectedRadio(selected);
          },
          groupValue: purchase.types.length > 0 ? purchase.types[0] ?? 0 : 0,
          selected: false,
        );
      },
    );
  }

  listTypeOfPurchase() {
    return ListView.builder(
      itemCount: _typesOfPurchases.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return CheckboxListTile(
          title: Text(_typesOfPurchases[index].name),
          value: purchase.types.contains(_typesOfPurchases[index].name),
          onChanged: (bool selected) {
            _onTypePurchaseSelected(selected, _typesOfPurchases[index].name);
          },
        );
      },
    );
  }

  inputDescription({TextEditingController controller}) {
    return TextField(
      focusNode: focusNodeDescription,
      controller: controller,
      decoration: null,
      textInputAction: TextInputAction.go,
      autofocus: true,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: TextStyle(color: textColor, fontFamily: 'Lato', fontSize: 20),
      cursorColor: Colors.transparent,
      onChanged: (value) {
        setState(() {
          purchase.description = value;
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
              focusNode: focusNodeValuePurchase,
              autofocus: true,
              controller: controller,
              decoration: null,
              textInputAction: TextInputAction.go,
              onChanged: (value) {
                String valor =
                    controller.text.replaceAll(".", "").replaceAll(",", ".");
                double valorDouble = double.tryParse(valor);

                setState(() {
                  purchase.value = valorDouble;
                  formattedLocaleMoney = controller.text;
                });
                print(valor);
              },
              onSubmitted: (value) {
                focusNodeValuePurchase.unfocus();
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
    return _onItemTapped(passTo);
  }

  void _submitPage() async {
    int passTo = 3;
    _onItemTapped(passTo);
    try {
      var purchaseCreate = await new Purchase().create(purchase);
      Navigator.pop(context, true);
      DialogMessages.openDialogMessage(
          context: this.context,
          title: purchaseCreate.success ? "Listo!" : "Error",
          typeMessage: purchaseCreate.success
              ? TypeMessages.SUCCESS
              : TypeMessages.ERROR,
          message: purchaseCreate.message.toString());
      await sharedPreferences.setLastPurchase(purchase);
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

  void _backPage() {
    int actualIndex = _selectedIndex;
    int passTo = actualIndex > 0 ? actualIndex - 1 : 0;
    return _onItemTapped(passTo);
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

  page2() {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          h1TituloPage2,
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                  style: TextStyle(
                      color: textSecondaryColor,
                      fontSize: 18,
                      fontFamily: 'Lato'),
                  children: [
                    TextSpan(text: 'Valor: R\$ '),
                    TextSpan(
                        text: formattedLocaleMoney.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ]),
            ),
          ),
          SizedBox(
            height: 0,
          ),
          Expanded(
            child: listTypeOfPurchaseRadio(),
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
            TextSpan(text: 'fue el valor?'),
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
            TextSpan(text: 'tipo de compra fué?'),
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
            TextSpan(text: 'una descripción de la compra'),
          ]),
    ),
  );
}
