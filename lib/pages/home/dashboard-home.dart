import 'package:flutter/material.dart';
import 'package:ourapp_canada/REST_ourApp.dart';
import 'package:ourapp_canada/models/Purchase.dart';
import 'package:ourapp_canada/pages/home/components/newPurchase.component.dart';
import 'package:ourapp_canada/functions/dialogTrigger.dart';
import 'package:ourapp_canada/widgets/tiles/main-tile.widget.dart';
import '../../colors.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Future<List<Purchase>> _getPurchases = fetchPurchases();
  List<Purchase> _listOfPurchases;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundDashboard(),
          RefreshIndicator(
            key: _refreshIndicatorKey,
            displacement: 50,
            onRefresh: reload,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 27),
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
                FutureBuilder<List<Purchase>>(
                  future: _getPurchases,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return listPurchases(snapshot.data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: CircularProgressIndicator(),
                    ));
                  },
                ),
                SizedBox(height: 35),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> reload() async {
    return fetchPurchases().then((response) {
      setState(() {
        _listOfPurchases = response;
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
            tag: 'Logo',
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
    return MainTile(
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
          style:
              TextStyle(color: Colors.white, fontFamily: 'Lato', fontSize: 20),
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
    );
  }

  listPurchases(List<Purchase> list) {
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: Colors.white.withAlpha(100),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListTile(
                title: Text(
                  list[index].types[0],
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                subtitle: Text(
                  list[index].description,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                trailing: Text(
                  "R\$ " + list[index].value.toString(),
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
