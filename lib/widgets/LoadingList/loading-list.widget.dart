// import 'package:flutter/material.dart';
// import 'package:ourapp_canada/pages/shared/Errors.widget.dart';

// class LoadingList extends StatefulWidget {
//   final LoadingListController controller;
//   final Function functionTrigger;
//   dynamic childs;

//   /// This can be used to control the state of the loadinglist.

//   LoadingList(
//       {Key key,
//       @required this.controller,
//       @required this.childs,
//       @required this.functionTrigger})
//       : super(key: key);

//   @override
//   _LoadingListState createState() => _LoadingListState();
// }

// class _LoadingListState extends State<LoadingList> {
//   bool busyListWidget;
//   bool errorShow;
//   String errorMessage;
//   @override
//   void initState() {
//     super.initState();
//     widget.controller._addState(this);
//     busyListWidget = false;
//     errorShow = false;
//     errorMessage = "";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return
//   }

//   void setBusyListWidget(bool value) {
//     setState(() {
//       busyListWidget = value;
//     });
//   }

//   void setErrorShow(bool value) {
//     setState(() {
//       errorShow = value;
//     });
//   }

//   void setErrorMessage(String value) {
//     setState(() {
//       errorMessage = value;
//     });
//   }
// }

// class LoadingListController {
//   _LoadingListState _loadingListState;
//   void _addState(_LoadingListState loadingListState) {
//     print("State added to LoadingListController");
//     this._loadingListState = loadingListState;
//   }

//   /// Determine if the panelController is attached to an instance
//   /// of the SlidingUpPanel (this property must return true before any other
//   /// functions can be used)
//   bool get isAttached => _loadingListState != null;

//   bool get busyListWidget {
//     return _loadingListState.busyListWidget;
//   }

//   set busyListWidget(bool value) {
//     _loadingListState.setBusyListWidget(value);
//   }

//   bool get errorShow {
//     return _loadingListState.errorShow;
//   }

//   set errorShow(bool value) {
//     _loadingListState.setErrorShow(value);
//   }

//   String get errorMessage {
//     return _loadingListState.errorMessage;
//   }

//   set errorMessage(String value) {
//     _loadingListState.setErrorMessage(value);
//   }

//   // Future<void> busy() {}

//   // Future<void> done() {}

//   // Future<void> error(String error) {}
// }
