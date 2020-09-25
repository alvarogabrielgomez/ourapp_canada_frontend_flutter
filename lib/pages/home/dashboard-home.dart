import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourapp_canada/models/Purchase.dart';
import 'package:ourapp_canada/models/PurchaseResponse.dart';
import 'package:ourapp_canada/pages/PurchaseDetails/purchase-details-page.dart';
import 'package:ourapp_canada/pages/cuentasFijas/cuentas-fijas-page.dart';
import 'package:ourapp_canada/pages/home/components/list-tile-purchaase-dashboard.component.dart';
import 'package:ourapp_canada/pages/home/components/newPurchase.component.dart';
import 'package:ourapp_canada/functions/dialogTrigger.dart';
import 'package:ourapp_canada/pages/shared/Errors.widget.dart';
import 'package:ourapp_canada/sharedPreferences.dart';
import 'package:ourapp_canada/widgets/btn/btn.widget.dart';
import 'package:ourapp_canada/widgets/pageRoutes/DashboardPageRoute.widget.dart';
import 'package:ourapp_canada/widgets/tiles/main-tile.widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../colors.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool busyListWidget = true;
  bool errorShow = false;
  String errorMessage = "";

  Purchase _myLastPurchase;
  SharedPreferencesClass sharedPreferences = new SharedPreferencesClass();

  int pagePurchasesActive = 0;
  PurchaseResponse _purchaseResponse = new PurchaseResponse();

  int _selectedIndex = 0;
  final pageViewController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    loadPurchases();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusBar();
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            backgroundDashboard(),
            RefreshIndicator(
              key: _refreshIndicatorKey,
              displacement: 50,
              onRefresh: reload,
              child: ListView(
                // padding: EdgeInsets.symmetric(horizontal: 27),
                physics: BouncingScrollPhysics(),
                children: [
                  header(),
                  SizedBox(height: 35),
                  mainTileCompras(),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Compras de este mes",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  busyListWidget
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 35),
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        )
                      : !errorShow
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                listPurchaseControls(),
                                gastosTotalesCounter(_purchaseResponse),
                                listPurchases(_purchaseResponse),
                              ],
                            )
                          : ErrorRetrieveInfo(
                              error: errorMessage,
                            ),
                  SizedBox(height: 35),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeStatusBar() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      statusBarIconBrightness: Brightness.light, //top bar icons
      systemNavigationBarColor: Colors.white, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ));
  }

  loadMyLastPurchase() async {
    var purchase = await sharedPreferences.getLastPurchase();
    setState(() {
      _myLastPurchase = purchase;
    });
  }

  busyLoading() {
    errorShow = false;
    errorMessage = "";
    setState(() {
      busyListWidget = true;
    });
  }

  doneLoading(Function setStateFunction) {
    errorMessage = "";
    errorShow = false;
    setState(() {
      busyListWidget = false;
      setStateFunction();
    });
  }

  errorLoading(String error) {
    busyListWidget = false;
    errorMessage = error;
    setState(() {
      errorShow = true;
    });
  }

  loadPurchases() async {
    loadMyLastPurchase();
    print("Loading loadPurchases...");
    busyLoading();
    try {
      var purchaseResponse = await new Purchase().getAllCurrentMonth();
      doneLoading(() {
        _purchaseResponse = purchaseResponse;
      });
      print("Loaded loadPurchases...");
    } catch (onError) {
      print(onError);
      print("error loadPurchases...");
      errorLoading("error loadPurchases...");
    }
  }

  Future<void> reload() async {
    loadMyLastPurchase();
    print("Loading reloadPurchases...");
    try {
      var purchaseResponse = await new Purchase().getAllCurrentMonth();
      doneLoading(() {
        _purchaseResponse = purchaseResponse;
      });
      print("Loaded reloadPurchases...");
    } catch (onError) {
      print(onError);
      print("Error reloadPurchases...");
      errorLoading("error loadPurchases...");
    }
  }

  backgroundDashboard() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/photos/BackgroundImage.png'),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                redCanada,
                Color(0xFF6B160F).withAlpha(206),
              ],
              stops: [
                0.0,
                1.0,
              ],
            ),
          ),
        ),
      ],
    );
  }

  header() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Hero(
            tag: 'logo',
            child: Container(
              width: 60,
              child: Image.asset('assets/icons/canada_icon.png'),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: Text(
            "Let's Fucking go to Canada",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Lato',
              fontSize: 20,
            ),
          ),
        )
      ],
    );
  }

  myLastPurchaseWidget() {
    return _myLastPurchase != null
        ? Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Mi última compra:",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Flexible(
                  child: Text(
                    _myLastPurchase.description,
                    style: TextStyle(color: Colors.white, height: 1.4),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "R\$ " + _myLastPurchase.value.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          )
        : Container(
            child: Text(
            "Toca aquí para agregar una nueva compra",
            textAlign: TextAlign.end,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ));
  }

  mainTileCompras() {
    return Container(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: PageView(
              onPageChanged: (page) {
                setState(() {
                  _selectedIndex = page;
                });
              },
              physics: BouncingScrollPhysics(),
              controller: pageViewController,
              children: [
                pageView1(),
                pageView2(),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SmoothPageIndicator(
              controller: pageViewController, // PageController
              count: 2,
              effect: WormEffect(
                spacing: 8.0,
                radius: 16,
                dotWidth: 8,
                dotHeight: 8,
                dotColor: Colors.white.withAlpha(60),
                activeDotColor: Colors.white,
              ), // your preferred effect
              onDotClicked: (index) {}),
        ],
      ),
    );
  }

  pageView1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 27),
      child: MainTile(
        onTap: () {
          PanelOption.openPanel(
            context: context,
            child: NewPurchasePanel(),
          ).then((response) {
            print(response);
            if (response == true) {
              reload();
            }
          });
        },
        width: MediaQuery.of(context).size.width,
        color: redCanadaDark.withAlpha(150),
        iconTile: Container(
          width: 28,
          child: Image.asset('assets/icons/dolar_icon.png'),
        ),
        title: Container(
          child: Text(
            "Nueva Compra",
            style: TextStyle(
                color: Colors.white, fontFamily: 'Lato', fontSize: 20),
          ),
        ),
        trailing: myLastPurchaseWidget(),
      ),
    );
  }

  pageView2() {
    String heroTag = 'CuentasFijas';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 27),
      child: Hero(
        tag: heroTag,
        child: MainTile(
          onTap: () {
            Navigator.push(
              context,
              DashboardPageRoute(
                  builder: (context) => CuentasFijasWidget(heroTag: heroTag)),
            );
          },
          width: MediaQuery.of(context).size.width,
          color: redCanadaDark.withAlpha(150),
          iconTile: Container(
            width: 28,
            child: Image.asset('assets/icons/payment_icon.png'),
          ),
          title: Container(
            child: Text(
              "Cuentas Fijas",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Lato', fontSize: 20),
            ),
          ),
          trailing: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Total Cuentas:",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  "R\$ 250.55",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget gastosTotalesCounter(PurchaseResponse purchaseResponse) {
    double totalOtras = purchaseResponse.valorTotalCompras;
    double totalSupermercado = purchaseResponse.valorTotalSupermercado;

    double showing = pagePurchasesActive == 0 ? totalOtras : totalSupermercado;

    return Padding(
      padding: const EdgeInsets.only(left: 27, right: 27, bottom: 20),
      child: BtnBasic(
        color: Colors.transparent,
        width: double.infinity,
        height: 30,
        borderRadius: 10,
        child: Center(
            child: Text(
          "Gastos Totales: R\$ $showing",
          style: TextStyle(color: Colors.white, fontSize: 12.5),
        )),
        onTap: () {
          setState(() {
            pagePurchasesActive = 0;
          });
        },
      ),
    );
  }

  Widget listPurchases(PurchaseResponse purchaseResponse) {
    List<Purchase> listOfPurchases = purchaseResponse.purchases;
    List<Purchase> listOfPurchasesSupermercado =
        listOfPurchases.where((x) => x.types.contains("Supermercado")).toList();
    List<Purchase> listOfPurchasesOtrasCompras = listOfPurchases
        .where((x) => !x.types.contains("Supermercado"))
        .toList();

    switch (pagePurchasesActive) {
      case 0:
        return listPurchasesBuild(listOfPurchasesOtrasCompras);
      case 1:
        return listPurchasesBuild(listOfPurchasesSupermercado);
      default:
    }
    return Container(child: Text("1"));
  }

  Widget listPurchaseControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: BtnBasic(
              activeState: pagePurchasesActive == 0,
              color: redCanadaDark.withAlpha(150),
              width: double.infinity,
              height: 46,
              borderRadius: 10,
              child: Center(
                  child: Text(
                "Compras Varias",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: pagePurchasesActive == 0
                        ? FontWeight.bold
                        : FontWeight.normal),
              )),
              onTap: () {
                setState(() {
                  pagePurchasesActive = 0;
                });
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            child: BtnBasic(
              activeState: pagePurchasesActive == 1,
              color: redCanadaDark.withAlpha(200),
              width: double.infinity,
              height: 48,
              borderRadius: 10,
              child: Center(
                  child: Text(
                "Supermercado",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: pagePurchasesActive == 1
                        ? FontWeight.bold
                        : FontWeight.normal),
              )),
              onTap: () {
                setState(() {
                  pagePurchasesActive = 1;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  listPurchasesBuild(List<Purchase> list) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 27),
      child: ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Dismissible(
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  var dismissResponse = await DialogMessages.openDialogYesOrNo(
                      context: context,
                      title: "Estas seguro?",
                      message:
                          "Esta es una cuenta fija de cada mes, estas seguro que quieres borrarla?",
                      okLabel: "Si",
                      noLabel: "No",
                      maxHeight: 315);
                  if (dismissResponse) {
                    await deletePurchase()
                  }
                }
              },
              key: ValueKey(list[index].id),
              child: ListTilePurchase(
                list: list,
                index: index,
                onTap: () {
                  Navigator.push(
                    context,
                    DashboardPageRoute(
                        builder: (context) =>
                            PurchaseDetailsPage(purchase: list[index])),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
