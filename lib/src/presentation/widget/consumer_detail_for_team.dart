import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:putulinmo/src/core/messages/reminder_message/reminder_message.dart';
import 'package:putulinmo/src/core/messages/success_message/success_message.dart';
import 'package:putulinmo/src/core/utils/constants.dart';
import 'package:putulinmo/src/data/models/consumer_model.dart';
import 'package:sizer/sizer.dart';

class ConsumerDetailForTeam extends StatefulWidget {
  final int index;
  final ConsumerModel consumerData;
  final Function onPressedFunction;
  const ConsumerDetailForTeam(
      {Key? key,
      required this.consumerData,
      required this.onPressedFunction,
      required this.index})
      : super(key: key);

  @override
  State<ConsumerDetailForTeam> createState() => _ConsumerDetailForTeamState();
}

class _ConsumerDetailForTeamState extends State<ConsumerDetailForTeam> {
  TextEditingController txtCurrentReader = TextEditingController();
  bool isFormValidate = false;
  @override
  Widget build(BuildContext context) {
    ConsumerModel consumerData = widget.consumerData;
    bool stats = consumerData.status;
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            top: 0, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            SizedBox(
              height: 80.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Account Number:",
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                      Text(
                        "Consumer Name:",
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                      Text(
                        "Address:",
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                      Text(
                        "No. of Months:",
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                      Text(
                        "Mat Loan Balance:",
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                      Text(
                        "Meter Number:",
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                      Text(
                        "Previous Reading:",
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                      Text(
                        "Unpaid Balance:",
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                      Text(
                        "Status:",
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                      SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              "Current Reading:",
                              style: TextStyle(fontSize: 12.0.sp),
                            ),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consumerData.accountNumber,
                          style: TextStyle(
                              fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          consumerData.name!,
                          style: TextStyle(
                              fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          consumerData.address!,
                          style: TextStyle(
                              fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          consumerData.numMonths.toString(),
                          style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          consumerData.matLoan.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          consumerData.meterNumber.toString(),
                          style: TextStyle(
                              fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          consumerData.prevReading.toString(),
                          style: TextStyle(
                              fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "P${consumerData.unpaidBal}",
                          style: TextStyle(
                              fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          stats ? "ACTIVE" : "DISCONNECTED",
                          style: TextStyle(
                              fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50.0.w,
                          child: TextField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]')),
                            ], // Only numbers can be entered
                            controller: txtCurrentReader,
                            scrollPadding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        5),
                            onChanged: (val) {
                              _checkValidation(val);
                            },
                            style: TextStyle(
                                fontSize: 12.0.sp, color: kWhiteColor),
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    borderSide: BorderSide(
                                        color: Colors.black,
                                        style: BorderStyle.solid)),
                                hintText: "Input Reading Here",
                                hintStyle: TextStyle(
                                    fontSize: 12.0.sp, color: kWhiteColor),
                                fillColor: kBackgroundColor,
                                filled: true),
                            enabled: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
                child: GestureDetector(
              onTap: !isFormValidate
                  ? () {}
                  : () {
                      widget.onPressedFunction();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => ReminderMessage(
                                  title: 'DISCONNECT ACCOUNT?',
                                  content:
                                      'Confirm Disconnection for ${consumerData.name}?',
                                  textButtons: [
                                    TextButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) =>
                                                  SuccessMessage(
                                                    title: "Success",
                                                    content:
                                                        "Disconnect Successfully",
                                                    onPressedFunction: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                  ));
                                        },
                                        child: const Text('Yes')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('No'))
                                  ]));
                    },
              child: Card(
                color: isFormValidate ? kWhiteColor : Colors.grey,
                elevation: 12.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: SizedBox(
                      width: 40.w,
                      child: Text(
                        "DISCONNECT",
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _checkValidation(String val) {
    setState(() {
      if (val.isNotEmpty) {
        isFormValidate = true;
      } else {
        isFormValidate = false;
      }
    });
  }

  String _team(int val) {
    switch (val) {
      case 0:
        return "N/A";
      case 1:
        return "TEAM 1";
      case 2:
        return "TEAM 2";
      case 3:
        return "TEAM 3";
      case 4:
        return "TEAM 4";
      case 5:
        return "TEAM 5";
      default:
        return "N/A";
    }
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
