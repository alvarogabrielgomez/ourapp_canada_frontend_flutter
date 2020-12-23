import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ourapp_canada/ListaDeCompras/blocs/listaDeCompras.bloc.dart';
import 'package:ourapp_canada/ListaDeCompras/models/ItemCompras.dart';
import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/shared/Errors.widget.dart';
import 'package:ourapp_canada/widgets/SlidingUpPanelMessages/dialogTrigger.dart';
import 'package:ourapp_canada/widgets/btn/btn.widget.dart';
import 'dart:math' as math;

class ListaDeComprasPage extends StatefulWidget {
  @override
  _ListaDeComprasPageState createState() => _ListaDeComprasPageState();
}

class _ListaDeComprasPageState extends State<ListaDeComprasPage> {
  bool busyListWidget = true;
  bool errorShow = false;
  String errorMessage = "";
  int cantidadItems = 0;
  int cantidadItemsDone = 0;
  double porcentajeDone = 0.00;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ScrollController _controller = ScrollController();
  final maxExtent = 150.0;
  double currentExtent = 0.0;
  List<ItemCompras> itemsCompras = [];
  @override
  void initState() {
    loadItemCompras();
    _controller.addListener(() {
      setState(() {
        currentExtent = maxExtent - _controller.offset;
        if (currentExtent < 0) currentExtent = 0.0;
        if (currentExtent > maxExtent) currentExtent = maxExtent;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    itemsCompras = new List<ItemCompras>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.add),
        tooltip: 'Registrar nuevo item',
        label: Text("Nuevo item"),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _SliverAppBarDelegate(
              brightness: Brightness.dark,
              minHeight: 87,
              maxHeight: 250.0,
              secundary: _secondaryHeader(),
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
                                  child: Container(),
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
                                child: FaIcon(
                                  FontAwesomeIcons.shoppingBasket,
                                  color: Colors.white,
                                  size: 40,
                                ),
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
                                "Lista de Compras",
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
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _SliverLinearProgressBarDelegate(
              minHeight: 11,
              maxHeight: 85.1,
              child: _linearProgressWidget(),
              secundary: _secundaryLinearProgressWidget(),
            ),
          ),
          busyListWidget
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(redCanada),
                      ),
                    ),
                  ),
                )
              : errorShow
                  ? SliverToBoxAdapter(
                      child: ErrorRetrieveInfo(
                        error: errorMessage,
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 0, right: 0, bottom: 20),
                      sliver: itemsCompras.length == 0
                          ? SliverToBoxAdapter(
                              child: _vacioCuentas(),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 27, vertical: 8),
                                    child: listTileWidget(index),
                                  );
                                },
                                childCount: itemsCompras.length,
                              ),
                            ),
                    ),
        ],
      ),
    );
  }

  _linearProgressWidget() {
    return Container(
      height: 87,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 27, right: 27, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Comprado',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: redCanada,
                          fontSize: 15,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: cantidadItemsDone.toString()),
                        TextSpan(text: '/'),
                        TextSpan(text: cantidadItems.toString()),
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: LinearProgressIndicator(
                minHeight: 11,
                value: porcentajeDone,
                backgroundColor: Colors.grey.withAlpha(70),
                valueColor: AlwaysStoppedAnimation<Color>(redCanada),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _secundaryLinearProgressWidget() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            minHeight: 11,
            value: porcentajeDone,
            backgroundColor: Colors.grey.withAlpha(70),
            valueColor: AlwaysStoppedAnimation<Color>(redCanada),
          ),
        ],
      ),
    );
  }

  _secondaryHeader() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: AppBar(
          elevation: 0,
          title: Text('Lista de Compras'),
        ),
      ),
    );
  }

  _vacioCuentas() {
    return Container(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              child: Text("Añade mas articulos (+) y aparecerán aquí."),
            ),
          ],
        ),
      ),
    );
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

  evaluateDones() {
    int _cantidadItemsDone =
        itemsCompras.where((x) => x.done == true).toList().length;
    cantidadItems = itemsCompras.length;
    cantidadItemsDone = _cantidadItemsDone;
    porcentajeDone = (cantidadItemsDone / cantidadItems).toDouble();
  }

  loadItemCompras() async {
    print("Loading loadItemCompras...");
    busyLoading();
    try {
      var _itemsCompras = await new ListaDeComprasBloc().getAllItemCompras();
      print("Loaded loadItemCompras...");
      int _cantidadItemsDone =
          _itemsCompras.where((x) => x.done == true).toList().length;
      doneLoading(() {
        itemsCompras = _itemsCompras;
        cantidadItems = _itemsCompras.length;
        cantidadItemsDone = _cantidadItemsDone;
      });
    } catch (onError) {
      errorLoading('Error loadItemCompras');
      print(onError);
      print("Error loadItemCompras...");
    }
  }

  _onChangeListaDeCompras(index, selected) {
    setState(() {
      itemsCompras[index].done = selected;
      evaluateDones();
    });
  }

  listTileWidget(int index) {
    var item = itemsCompras[index];
    return Material(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
      ),
      clipBehavior: Clip.antiAlias,
      color: lightBtnBackground,
      child: Dismissible(
        key: ValueKey(item.id),
        background: Container(
          color: redCanada,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(18),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        secondaryBackground: Container(
          color: redCanada,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(18),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            //user swiped left to delete item
            DialogMessages.openDialogYesOrNo(
                    context: context,
                    title: "Estas seguro?",
                    message: "Seguro que quieres borrar este item?",
                    okLabel: "Si",
                    noLabel: "No",
                    maxHeight: 295)
                .then((response) {
              print(response);
              if (response == true) {
                return true;
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
        child: ListTile(
          contentPadding:
              EdgeInsets.only(top: 3, bottom: 3, right: 18, left: 10),
          title: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _onChangeListaDeCompras(index, !item.done);
            },
            child: Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(item.description.toString(),
                  style: item.done
                      ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.black45,
                        )
                      : TextStyle()),
            ),
          ),
          leading: CircularCheckBox(
            value: item.done,
            onChanged: (selected) {
              _onChangeListaDeCompras(index, selected);
            },
          ),
          trailing: Container(
            width: 80,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Positioned(
                  top: 0,
                  child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: Colors.black12,
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: 70,
                        height: 35,
                        child: Center(
                            child: FaIcon(
                          FontAwesomeIcons.dollarSign,
                          size: 17,
                          color: Colors.white,
                        )),
                      )),
                ),
                Material(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: redCanada,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: 35,
                    height: 35,
                    child: Center(
                        child: FaIcon(
                      FontAwesomeIcons.dollarSign,
                      size: 17,
                      color: Colors.white,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverLinearProgressBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverLinearProgressBarDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child,
      this.secundary,
      this.brightness});
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final Widget secundary;

  final Brightness brightness;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final show = shrinkOffset < 1;
    //final show = !overlapsContent;

    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ThemeData theme = Theme.of(context);

    final _brightness =
        brightness ?? appBarTheme.brightness ?? theme.primaryColorBrightness;

    final SystemUiOverlayStyle overlayStyle = _brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(color: Colors.transparent),
          AnimatedOpacity(
            opacity: show ? 1 : 0,
            duration: Duration(milliseconds: 100),
            child: new SizedBox.expand(child: child),
          ),
          AnimatedOpacity(
            opacity: !show ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: new SizedBox.expand(child: secundary),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverLinearProgressBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child,
      this.secundary,
      this.brightness});
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final Widget secundary;

  final Brightness brightness;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final show = shrinkOffset < 70;

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
          AnimatedOpacity(
            opacity: !show ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: new SizedBox.expand(child: secundary),
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
