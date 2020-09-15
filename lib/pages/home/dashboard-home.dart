import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:ourapp_canada/REST_ourApp.dart';
import 'package:ourapp_canada/models/Purchase.dart';
import 'package:ourapp_canada/pages/PurchaseDetails/purchase-details-page.dart';
import 'package:ourapp_canada/pages/cuentasFijas/cuentasFijas.dart';
import 'package:ourapp_canada/pages/home/components/list-tile-purchaase-dashboard.component.dart';
import 'package:ourapp_canada/pages/home/components/newPurchase.component.dart';
import 'package:ourapp_canada/functions/dialogTrigger.dart';
import 'package:ourapp_canada/pages/shared/Errors.widget.dart';
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
  bool errorMessage = false;
  Future<List<Purchase>> _getPurchases = fetchPurchases();
  List<Purchase> _listOfPurchases;
  int _selectedIndex = 0;
  final pageViewController = new PageController(initialPage: 0);
  @override
  void initState() {
    loadPurchases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusBar();
    return Scaffold(
      body: Stack(
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
                SizedBox(height: 35),
                Center(
                  child: Text(
                    "Historial de Compras",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                busyListWidget
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 35),
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : !errorMessage
                        ? listPurchases(_listOfPurchases)
                        : ErrorRetrieveInfo(),
                SizedBox(height: 35),
              ],
            ),
          ),
        ],
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

  loadPurchases() async {
    setState(() {
      busyListWidget = true;
      print("Loading loadPurchases...");
    });
    return fetchPurchases().then((response) {
      setState(() {
        _listOfPurchases = response;
        busyListWidget = false;
        print("Loaded loadPurchases...");
      });
    }).catchError((onError) {
      setState(() {
        busyListWidget = false;
        errorMessage = true;
        print("Error loadPurchases...");
      });
    });
  }

  Future<void> reload() async {
    setState(() {
      print("Loading reloadPurchases...");
    });
    return fetchPurchases().then((response) {
      setState(() {
        _listOfPurchases = response;
        print("Loaded reloadPurchases...");
      });
    }).catchError((onError) {
      setState(() {
        busyListWidget = false;
        errorMessage = true;
        print("Error reloadPurchases...");
      });
    });
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
          height: 50,
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Hero(
            tag: 'logo',
            child: Container(
              width: 165,
              child: Image.asset('assets/icons/canada_icon.png'),
            ),
          ),
        ),
        SizedBox(
          height: 9,
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
        trailing: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Última compra:",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Flexible(
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla pharetra hendrerit odio a blandit. Donec semper ipsum ut eros gravida, id lacinia mauris tincidunt. ",
                  style: TextStyle(color: Colors.white, height: 1.4),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "R\$ 250.55",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ),
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
                  builder: (context) => CuentasFijas(heroTag: heroTag)),
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

  listPurchases(List<Purchase> list) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 27),
      child: ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
          );
        },
      ),
    );
  }
}
