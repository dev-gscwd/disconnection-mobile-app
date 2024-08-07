import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diconnection/src/core/enums/status/status_enum.dart';
import 'package:diconnection/src/core/handler/utils_handler.dart';
import 'package:diconnection/src/core/messages/error_message/error_message.dart';
import 'package:diconnection/src/core/messages/verifying_messgae/verifying_message.dart';
import 'package:diconnection/src/core/messages/warning_message/warning_message.dart';
import 'package:diconnection/src/data/models/zone_model.dart';
import 'package:diconnection/src/data/services/auth_provider/auth_provider.dart';
import 'package:diconnection/src/data/services/disconnection_provider/disconnection_provider.dart';
import 'package:diconnection/src/data/services/sync_provider/sync_provider.dart';
import 'package:diconnection/src/presentation/widget/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diconnection/src/core/messages/reminder_message/reminder_message.dart';
import 'package:diconnection/src/core/messages/success_message/success_message.dart';
import 'package:diconnection/src/core/utils/constants.dart';
import 'package:diconnection/src/data/models/consumer_model/consumer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:sizer/sizer.dart';

class ConsumerDetailForDisconnect extends ConsumerStatefulWidget {
  final int index;
  final bool last;
  final ConsumerModel consumerData;
  final Function onPressedFunction;
  const ConsumerDetailForDisconnect(
      {super.key,
      required this.consumerData,
      required this.onPressedFunction,
      required this.index,
      required this.last});

  @override
  ConsumerState<ConsumerDetailForDisconnect> createState() =>
      _ConsumerDetailForDisconnectState();
}

class _ConsumerDetailForDisconnectState
    extends ConsumerState<ConsumerDetailForDisconnect> {
  TextEditingController txtCurrentReader = TextEditingController();
  TextEditingController txtCustomRemarks = TextEditingController();
  TextEditingController txtSealNo = TextEditingController();
  TextEditingController txtRemark = TextEditingController();
  final MultiSelectController<dynamic> controller = MultiSelectController();
  final MultiSelectController<dynamic> itemController = MultiSelectController();
  String selectRemark = "";
  bool isFormValidate = false,
      isRead = true,
      isDisconnected = true,
      isCustom = false;
  late StreamController<int> _events;
  late Widget _imageWidget;

  @override
  void initState() {
    UtilsHandler.mediaFileList = [];
    _imageWidget = ImagePickerWidget(onChanged: () {
      _checkValidation();
    });
    _events = StreamController<int>();
    super.initState();
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 3,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    ConsumerModel consumerData = widget.consumerData;
    bool stats = !(consumerData.status == StatusEnum.mlDone.getIntVal ||
        consumerData.status == StatusEnum.done.getIntVal);
    bool isMainLine = consumerData.status == StatusEnum.mlOngoing.getIntVal;
    double a = double.parse(consumerData.billAmount!);
    controller.setOptions(UtilsHandler.remarks);
    final disconnection = ref.watch(asyncDisconnectionProvider);
    final TextStyle textStyle =
        TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.bold);
    final Size txtSize = _textSize(consumerData.address!, textStyle);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldColor,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            // Just ensure this is set:
            bottom: MediaQuery.of(context).viewInsets.bottom),
        physics: const BouncingScrollPhysics(),
        // padding: EdgeInsets.only(
        //     top: 0, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Separate Account Number UI
            ListTile(
              leading: Icon(
                Icons.account_circle_sharp,
                size: 35,
                color: Colors.blue[600],
              ),
              title: Text(consumerData.consumerName ?? ""),
              subtitle: Text(consumerData.accountNo ?? ""),
            ),
            //Separate Account Number Consumer Name
            const Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
              color: Colors.black12,
            ),
            ListTile(
              leading: Icon(
                Icons.location_on_sharp,
                size: 35,
                color: Colors.blue[600],
              ),
              title: Text(consumerData.address ?? ""),
            ),
            const Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
              color: Colors.black12,
            ),
            ListTile(
              leading: Icon(
                Icons.electric_meter_rounded,
                size: 35,
                color: Colors.blue[600],
              ),
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Meter No.", style: TextStyle(fontSize: 14)),
                  Text("Previous Reading", style: TextStyle(fontSize: 14))
                ],
              ),
              // Text(consumerData.meterNo ?? ""),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    consumerData.meterNo ?? "",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    consumerData.lastReading.toString(),
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
              color: Colors.black12,
            ),
            ListTile(
              leading: Icon(Icons.info_outline_rounded,
                  size: 35, color: Colors.red[500]),
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("No. of Months", style: TextStyle(fontSize: 14)),
                  Text("Balance", style: TextStyle(fontSize: 14))
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(consumerData.noOfMonths.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    "P ${a.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
              color: Colors.black12,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Remarks",
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: DropdownMenu<dynamic>(
                        controller: txtRemark,
                        initialSelection: "Disconnected",
                        hintText: "Select Remarks",
                        width: MediaQuery.of(context).size.width * .93,
                        dropdownMenuEntries: UtilsHandler.remarks
                            .map<DropdownMenuEntry<dynamic>>((dynamic remarks) {
                          return DropdownMenuEntry(
                              value: remarks.value, label: remarks.label);
                        }).toList(),
                      ))
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        onChanged: (val) {
                          _checkValidation();
                        },
                        controller: txtCurrentReader,
                        scrollPadding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).viewInsets.bottom + 5),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                        ],
                        decoration: const InputDecoration(
                            hintText: "Current Reading",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                                borderSide: BorderSide(
                                    color: Colors.black,
                                    style: BorderStyle.solid)))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                      ],
                      scrollPadding: EdgeInsets.symmetric(
                          vertical:
                              MediaQuery.of(context).viewInsets.bottom + 5),
                      controller: txtSealNo,
                      onChanged: (val) {
                        _checkValidation();
                      },
                      decoration: const InputDecoration(
                        hintText: "Seal No",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(
                                color: Colors.black, style: BorderStyle.solid)),
                      ),
                    ),
                  ),

                  // Container(color: Colors.amber, child: const Text("Test")),
                  // Column(
                  //   children: [Text("data"), Text("data1")],
                  // )
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
              color: Colors.black12,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Additional Remarks",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    TextField(
                      controller: txtCustomRemarks,
                      scrollPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).viewInsets.bottom),
                      style: TextStyle(fontSize: 12.0.sp, color: Colors.black),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  style: BorderStyle.solid)),
                          hintText: "Additional Remarks",
                          hintStyle: TextStyle(fontSize: 12.0.sp),
                          fillColor:
                              isDisconnected ? Colors.white : Colors.grey,
                          filled: true),
                      enabled: isDisconnected,
                      maxLines: 2,
                    ),
                  ],
                )),
            ListTile(
              title: const Text("Proof"),
              subtitle: _imageWidget,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isFormValidate ? Colors.grey : kBackgroundColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  onPressed: !isFormValidate
                      ? () {
                          showDialog(
                              context: context,
                              builder: (context) => ErrorMessage(
                                    title: 'No Proof',
                                    content:
                                        'Please make sure your current reading is greater than Previous reading and Capture a proof to continue.',
                                    onPressedFunction: () {
                                      Navigator.pop(context);
                                    },
                                  ));
                          print('not valid');
                        }
                      : () {
                          _disconnectAccount(
                              context, consumerData, disconnection);
                        },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  StatusEnum getStatus(int input) {
    switch (input) {
      case 0:
        return StatusEnum.ongoing;
      case 1:
        return StatusEnum.done;
      case 2:
        return StatusEnum.cancelled;
      case 3:
        return StatusEnum.mlOngoing;
      case 4:
        return StatusEnum.mlDone;
      default:
        return StatusEnum.ongoing;
    }
  }

  Future<dynamic> _disconnectAccount(
      BuildContext context,
      ConsumerModel consumerData,
      AsyncValue<List<ZoneModel>> disconnection) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool hasInternet = connectivityResult[0] == ConnectivityResult.mobile ||
        connectivityResult[0] == ConnectivityResult.wifi;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ReminderMessage(
                title: 'DISCONNECT ACCOUNT?',
                content:
                    'Confirm Disconnection for ${consumerData.consumerName}?',
                textButtons: [
                  TextButton(
                      onPressed: () {
                        final input = formUpdate();
                        ref
                            .read(asyncDisconnectionProvider.notifier)
                            .offlineMode(input, _events);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => StreamBuilder<int>(
                                initialData: 1,
                                stream: _events.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  switch (snapshot.data!) {
                                    case 300:
                                      return SuccessMessage(
                                        title: "Success",
                                        content: hasInternet
                                            ? "Submitting. Please continue your disconnection"
                                            : "Saved Successfully and waiting for internet to sync to server",
                                        onPressedFunction: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context, 'refresh');
                                          if (widget.last) {
                                            Navigator.pop(context, 'refresh');
                                          }
                                          if (hasInternet &&
                                              !UtilsHandler.executed) {
                                            Timer.run(() => ref
                                                .read(
                                                    asyncSyncProvider.notifier)
                                                .syncAll());
                                          }
                                        },
                                      );
                                    case 400:
                                      return SuccessMessage(
                                        title: "Already Paid",
                                        content:
                                            "Please abort disconnection the Consumer was already paid",
                                        onPressedFunction: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context, 'refresh');
                                        },
                                      );
                                    case 401: //Failed to Verify Please try again
                                      return ErrorMessage(
                                        title: 'Expired Session',
                                        content: 'Please login again.',
                                        onPressedFunction: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          ref
                                              .read(asyncAuthProvider.notifier)
                                              .isExpired();
                                        },
                                      );
                                    case 500: //Failed to Verify Please try again
                                      return ErrorMessage(
                                        title: 'Please try again',
                                        content:
                                            'Failed to Verify Please try again',
                                        onPressedFunction: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    case 501: //Failed to upload from API
                                      return ErrorMessage(
                                        title: 'Please try again',
                                        content: 'Failed to upload from API',
                                        onPressedFunction: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    case 502: //Failed to disconnect Consumers from API
                                      return ErrorMessage(
                                        title: 'Please try again',
                                        content:
                                            'Failed to disconnect Consumers from API',
                                        onPressedFunction: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    default:
                                      return ErrorMessage(
                                        title: 'Please try again',
                                        content: 'There is error',
                                        onPressedFunction: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                  }
                                }));
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(fontSize: 16.0.sp),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'No',
                        style: TextStyle(fontSize: 16.0.sp),
                      ))
                ]));
  }

  void _checkValidation() {
    final a = widget.consumerData;
    setState(() {
      // bool cantRead = isRead ? txtCurrentReader.text.isNotEmpty : true;
      // String finalRemarks = selectRemark + txtCustomRemarks.text;
      var myInt =
          txtCurrentReader.text.isEmpty ? 0 : int.parse(txtCurrentReader.text);
      bool currentReadValidations = myInt > a.lastReading! || myInt == 0;
      if (UtilsHandler.mediaFileList!.isNotEmpty && currentReadValidations) {
        isFormValidate = true;
      } else {
        isFormValidate = false;
      }
    });
  }

  ConsumerModel formUpdate() {
    final a = widget.consumerData;
    int stats = a.jobCode == 33
        ? StatusEnum.mlDone.getIntVal
        : StatusEnum.done.getIntVal;
    String mainRemark = 'Disconnected';
    isDisconnected =
        txtRemark.text.toLowerCase().contains(mainRemark.toLowerCase());
    stats = isDisconnected ? stats : StatusEnum.cancelled.getIntVal;
    int? currentReading =
        txtCurrentReader.text == '0' || txtCurrentReader.text.isEmpty
            ? a.lastReading
            : int.parse(txtCurrentReader.text);
    String mainRemarks = txtRemark.text;
    String additionalRemark = txtCustomRemarks.text.isEmpty
        ? ''
        : ', Additional Remarks: ${txtCustomRemarks.text}';
    String sealNo = txtSealNo.text.isEmpty ? '' : ', SealNo: ${txtSealNo.text}';
    String currentNo = txtCurrentReader.text.isEmpty
        ? ', Current Reading: No Reading'
        : ', Current No: ${txtCurrentReader.text}';
    final b = ConsumerModel(
        lastUpdated: a.lastUpdated,
        dispatchDateTime: a.dispatchDateTime,
        disconnectionId: a.disconnectionId,
        accountNo: a.accountNo,
        prevAccountNo: a.prevAccountNo ?? "",
        consumerName: a.consumerName,
        address: a.address,
        meterNo: a.meterNo,
        billAmount: a.billAmount,
        noOfMonths: a.noOfMonths,
        lastReading: a.lastReading,
        currentReading: currentReading,
        remarks: '$mainRemarks$currentNo$sealNo$additionalRemark',
        disconnectionDate: a.disconnectionDate,
        disconnectedDate: isDisconnected ? a.disconnectedDate : null,
        zoneNo: a.zoneNo,
        bookNo: a.bookNo,
        isConnected: !isDisconnected,
        isPayed: a.isPayed,
        disconnectionTeam: a.disconnectionTeam,
        status: stats,
        proofOfDisconnection: a.proofOfDisconnection,
        seqNo: a.seqNo,
        disconnectedTime: a.disconnectedTime,
        jobCode: a.jobCode);
    return b;
  }

  Widget _menuItem(String label, String value,
      {double fontVal = 10, Color colorVal = Colors.red}) {
    return SizedBox(
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.0.sp),
          ),
          Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontVal.sp,
                color: colorVal),
          ),
        ],
      ),
    );
  }
}
