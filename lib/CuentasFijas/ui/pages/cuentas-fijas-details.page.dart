import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/CuentasFijas/models/CuentasFijas.dart';
import 'package:ourapp_canada/CuentasFijas/models/Increment.dart';
import 'package:ourapp_canada/CuentasFijas/models/PagoCuentaFija.dart';
import 'package:ourapp_canada/CuentasFijas/ui/widgets/new-pago-cuenta-fija.widget.dart';
import 'package:ourapp_canada/shared/Errors.widget.dart';
import 'package:ourapp_canada/widgets/SlidingUpPanelMessages/dialogTrigger.dart';

class CuentaFijaDetails extends StatefulWidget {
  final CuentaFija cuenta;

  CuentaFijaDetails({@required this.cuenta});
  @override
  _CuentaFijaDetailsState createState() => _CuentaFijaDetailsState();
}

class _CuentaFijaDetailsState extends State<CuentaFijaDetails> {
  DateFormat formatterDate = new DateFormat('dd/MM/yyyy');
  DateFormat formatterHour = new DateFormat('HH:mm');
  bool busyListWidget = true;
  bool errorShow = false;
  String errorMessage = "";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<PagoCuentaFija> _listOfPagosCuentasFijas;

  @override
  void initState() {
    loadPagosCuentasFijas();
    initializeDateFormatting("pt_BR");
    super.initState();
  }

  @override
  dispose() {
    _listOfPagosCuentasFijas = new List<PagoCuentaFija>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dayOfPayment = widget.cuenta.dayOfPayment;

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: lightBtnBackground,
        title: Text(widget.cuenta.name, style: TextStyle(color: redCanada)),
        iconTheme: IconThemeData(color: redCanada),
        centerTitle: true,
      ),
      floatingActionButton: floatingNewPayment(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          header(),
          Container(
            height: 54,
            color: redCanadaDark2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // alignment: Alignment.centerLeft,
                children: [
                  Container(
                    child: Text(
                      "Fecha de Pago: $dayOfPayment de cada mes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: _buildPagoCuentasFijas(_listOfPagosCuentasFijas),
          ),
        ],
      ),
    );
  }

  _buildPagoCuentasFijas(List<PagoCuentaFija> pagos) {
    return busyListWidget
        ? Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 35),
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(redCanada),
              ),
            ),
          )
        : !errorShow
            ? ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: pagos.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTileCuentasFijas(
                    title: Text(formatterDate.format(pagos[index].date)),
                    subtitle: Text(formatterHour.format(pagos[index].date)),
                    leading: incrementItem(pagos[index].increment),
                    trailing:
                        Text("R\$ " + pagos[index].value.toStringAsFixed(2)),
                  );
                })
            : ErrorRetrieveInfo(
                error: errorMessage,
              );
  }

  header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 195,
      decoration: BoxDecoration(
        color: redCanada,
        image: DecorationImage(
          alignment: Alignment.bottomCenter,
          fit: BoxFit.fitWidth,
          image: AssetImage('assets/graphics/charts_background.png'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 25),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 45,
                child: Opacity(
                    opacity: 0.10,
                    child: Image.asset('assets/icons/dolar_icon.png')),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "R\$ " + widget.cuenta.value.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    fontSize: 35,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                incrementTitle(widget.cuenta.increment)
              ],
            )
          ],
        ),
      ),
    );
  }

  incrementTitle(Increment increment) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
      decoration: BoxDecoration(
        color: redCanadaDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: 'Roboto'),
            children: [
              TextSpan(
                text: increment.sign == 'positive' ? "+ " : "- ",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: increment.sign == 'positive'
                        ? Colors.red
                        : Colors.green),
              ),
              TextSpan(
                text: "R\$ " + increment.value.toStringAsFixed(2),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: increment.sign == 'positive'
                        ? Colors.red
                        : Colors.green),
              ),
            ]),
      ),
    );
  }

  incrementItem(Increment increment) {
    return Container(
      width: 65,
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      constraints: BoxConstraints(maxWidth: 65),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontFamily: 'Roboto'),
            children: [
              TextSpan(
                text: increment.sign == 'positive' ? "+" : "-",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: increment.sign == 'positive'
                        ? Colors.red
                        : Colors.green),
              ),
              TextSpan(
                text: increment.value.toStringAsFixed(2),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: increment.sign == 'positive'
                        ? Colors.red
                        : Colors.green),
              ),
            ]),
      ),
    );
  }

  floatingNewPayment() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FloatingActionButton.extended(
        onPressed: () {
          PanelOption.openPanel(
            context: context,
            child: NewPagoCuentaFijaPanel(cuentaFija: widget.cuenta),
          ).then((response) {
            print(response);
            if (response == true) {
              loadPagosCuentasFijas();
            }
          });
        },
        tooltip: 'Registrar nuevo pago',
        icon: Icon(Icons.add),
        label: Text("Nuevo Pago"),
      ),
    );
  }

// Methods REST

  loadPagosCuentasFijas() async {
    _listOfPagosCuentasFijas = new List<PagoCuentaFija>();
    print("Loading loadCuentasFijas...");
    setState(() {
      busyListWidget = true;
    });
    new PagoCuentaFija()
        .getAllWhereIDCuentaFija(widget.cuenta.id)
        .then((response) {
      busyListWidget = false;
      print("Loaded loadPagosCuentasFijas...");
      setState(() {
        _listOfPagosCuentasFijas = response;
      });
    }).catchError((onError) {
      errorShow = true;
      errorMessage = "Error loadPagosCuentasFijas";
      print(onError);
      print("Error loadPagosCuentasFijas...");
      setState(() {
        busyListWidget = false;
      });
    });
  }
}

class ListTileCuentasFijas extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final Widget leading;
  ListTileCuentasFijas(
      {this.title, this.subtitle, this.trailing, this.leading});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      leading: leading,
    );
  }
}
