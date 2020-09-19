import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/functions/dialogTrigger.dart';
import 'package:ourapp_canada/models/CuentasFijas.dart';
import 'package:ourapp_canada/models/RestResponse.dart';
import 'package:ourapp_canada/pages/cuentasFijas/components/new-cuenta-fija.component.dart';
import 'package:ourapp_canada/pages/cuentasFijas/cuentas-fijas-details.page.dart';
import 'package:ourapp_canada/pages/shared/Errors.widget.dart';
import 'package:ourapp_canada/widgets/SlidingUpPanelMessages/sliding-up-panel-messages.widget.dart';
import 'dart:math' as math;

import 'package:ourapp_canada/widgets/btn/btn.widget.dart';
import 'package:ourapp_canada/widgets/tiles/grid-tile.widget.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child,
      this.brightness});
  final double minHeight;
  final double maxHeight;
  final Widget child;

  final Brightness brightness;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final show = shrinkOffset < 100;

    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ThemeData theme = Theme.of(context);

    final _brightness =
        brightness ?? appBarTheme.brightness ?? theme.primaryColorBrightness;

    final SystemUiOverlayStyle overlayStyle = _brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return Material(
      child: Stack(
        children: [
          Container(color: redCanada),
          AnimatedOpacity(
            opacity: show ? 1 : 0,
            duration: Duration(milliseconds: 100),
            child: new SizedBox.expand(child: child),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CuentasFijasWidget extends StatefulWidget {
  final String heroTag;

  CuentasFijasWidget({this.heroTag});
  @override
  _CuentasFijasWidgetState createState() => _CuentasFijasWidgetState();
}

class _CuentasFijasWidgetState extends State<CuentasFijasWidget> {
  bool busyListWidget = true;
  bool errorShow = false;
  String errorMessage = "";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController;
  List<CuentaFija> _listOfCuentasFijas;
  List<CuentaFija> _mainCuentasFijas = new CuentaFija().getMainCuentasFijas();

  @override
  void initState() {
    loadCuentasFijas();
    super.initState();
  }

  @override
  dispose() {
    _listOfCuentasFijas = new List<CuentaFija>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.heroTag,
      child: Scaffold(
        floatingActionButton: _floatingActionButton(context),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: reload,
            child: CustomScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: _SliverAppBarDelegate(
                    brightness: Brightness.dark,
                    minHeight: 0.0,
                    maxHeight: 250.0,
                    child: Container(
                      color: redCanada,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 30, left: 29, right: 29, bottom: 20),
                        child: SafeArea(
                          top: true,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: FractionallySizedBox(
                                    widthFactor: 0.75,
                                    heightFactor: 0.75,
                                    child: Container(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Total Cuentas:",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: LeadingBtn(
                                    color: redCanada,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 50,
                                      child: Image.asset(
                                          'assets/icons/payment_icon.png'),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 30,
                                    maxHeight: 80,
                                    minWidth: 100,
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Cuentas Fijas",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Lato',
                                          fontSize: 23),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildMainCuentasFijas(_mainCuentasFijas),
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "Otras cuentas fijas",
                      style: TextStyle(
                          fontFamily: 'Lato', fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                _buildCuentasFijas(_listOfCuentasFijas)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<RestResponse> deleteCuentaFija(CuentaFija cuentaDelete) async {
    await Future.delayed(Duration(milliseconds: 500));
    return new CuentaFija().delete(cuentaDelete);
  }

  loadCuentasFijas() async {
    setState(() {
      busyListWidget = true;
      _listOfCuentasFijas = new List<CuentaFija>();
      print("Loading loadCuentasFijas...");
    });

    await Future.delayed(Duration(milliseconds: 300));

    new CuentaFija().getAll().then((response) {
      var res = response;
      // print(json.encode(res).toString());

      setState(() {
        _listOfCuentasFijas = response;
        // print(json.encode(response).toString());
        busyListWidget = false;
        print("Loaded loadCuentasFijas...");
      });
    }).catchError((onError) {
      setState(() {
        busyListWidget = false;
        errorShow = true;
        errorMessage = "Error loadCuentasFijas";
        print(onError);
        print("Error loadCuentasFijas...");
      });
    });
  }

  Future<void> reload() async {
    setState(() {
      print("Loading reloadCuentasFijas..");
    });
    await Future.delayed(Duration(seconds: 1));
    return new CuentaFija().getAll().then((response) {
      setState(() {
        _listOfCuentasFijas = response;
        print("Loaded reloadCuentasFijas...");
      });
    }).catchError((onError) {
      setState(() {
        busyListWidget = false;
        errorShow = true;
        errorMessage = "Error reloadCuentasFijas";
        print("Error reloadCuentasFijas...");
      });
    });
  }

  _floatingActionButton(BuildContext context) {
    var backgroundColor = redCanada;
    Color _splashColor = darken(backgroundColor, 0.2).withAlpha(50);
    Color _highlightColor = darken(backgroundColor, 0.2).withAlpha(75);

    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Material(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        color: backgroundColor,
        shape: CircleBorder(),
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          splashColor: _splashColor,
          focusColor: Colors.transparent,
          highlightColor: _highlightColor,
          child: Container(
            width: 55,
            height: 55,
            color: Colors.transparent,
            child: Center(
                child: Icon(
              Icons.add,
              color: Colors.white,
            )),
          ),
          onTap: () {
            PanelOption.openPanel(
              context: context,
              child: NewCuentaFijaPanel(),
            ).then((response) {
              print(response);
              if (response == true) {
                loadCuentasFijas();
              }
            });
          },
        ),
      ),
    );
  }

  _buildCuentasFijas(List<CuentaFija> cuentas) {
    return busyListWidget
        ? SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 35),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(redCanada),
                ),
              ),
            ),
          )
        : !errorShow
            ? SliverPadding(
                padding: const EdgeInsets.only(
                    top: 30, left: 0, right: 0, bottom: 20),
                sliver: cuentas.length == 0
                    ? SliverToBoxAdapter(
                        child: _vacioCuentas(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            var title = cuentas[index].name;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 27, vertical: 8),
                              child: Material(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                color: lightBtnBackground,
                                child: Dismissible(
                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      //user swiped left to delete item
                                      DialogMessages.openDialogYesOrNo(
                                              context: context,
                                              title: "Estas seguro?",
                                              message:
                                                  "Esta es una cuenta fija de cada mes, estas seguro que quieres borrarla?",
                                              okLabel: "Si",
                                              noLabel: "No",
                                              maxHeight: 315)
                                          .then((response) {
                                        print(response);
                                        if (response == true) {
                                          deleteCuentaFija(cuentas[index])
                                              .then((response) {
                                            // Deleted
                                            if (response.success) {
                                              setState(() {
                                                cuentas.removeAt(index);
                                              });
                                              return true;
                                            } else {
                                              DialogMessages.openDialogMessage(
                                                      typeMessage:
                                                          TypeMessages.ERROR,
                                                      title: "Error al borrar",
                                                      message: response.message)
                                                  .then((response) {
                                                loadCuentasFijas();
                                              });
                                              return false;
                                            }
                                          }).catchError((onError) {
                                            DialogMessages.openDialogMessage(
                                                    typeMessage:
                                                        TypeMessages.ERROR,
                                                    title: "Error al borrar",
                                                    message:
                                                        "Error desconocido al borrar")
                                                .then((response) {
                                              loadCuentasFijas();
                                            });
                                            return false;
                                          });
                                        } else {
                                          return false;
                                        }
                                      }).catchError((onError) {
                                        return false;
                                      });
                                    }
                                    // Swipe para la derecha
                                    return false;
                                  },
                                  key: ValueKey(cuentas[index].id),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13.0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 27),
                                    title: Text(title),
                                    trailing: Text("R\$ " +
                                        cuentas[index].value.toString()),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CuentaFijaDetails(
                                                  cuenta: cuentas[index],
                                                )),
                                      );
                                    },
                                  ),
                                  secondaryBackground: Container(
                                    color: redCanada,
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.all(27),
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  background: Container(
                                    color: Colors.green,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(27),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: cuentas.length,
                        ),
                      ),
              )
            : SliverToBoxAdapter(
                child: ErrorRetrieveInfo(
                  error: errorMessage,
                ),
              );
  }

  _vacioCuentas() {
    return Container(
      height: 250,
      child: Center(
        child: Column(
          children: [
            Flexible(
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: Text("Añade mas cuentas (+) y aparecerán aquí."),
            ),
          ],
        ),
      ),
    );
  }

  _buildMainCuentasFijas(List<CuentaFija> mainCuentasFijas) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 30, left: 27, right: 27, bottom: 20),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            var title = mainCuentasFijas[index].name;
            var icon = mainCuentasFijas[index].icon;
            return CustomGridTile(
              title: Text("$title"),
              iconTile: FaIcon(icon),
              heroTitle: Container(
                child: Text(
                  "R\$ 250.55",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                ),
              ),
              onTap: () {
                loadCuentasFijas();
              },
            );
          },
          childCount: mainCuentasFijas.length,
        ),
      ),
    );
  }
}
