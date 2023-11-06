import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diconnection/src/core/enums/auth/auth_level.dart';
import 'package:diconnection/src/core/handler/checkBoxHandler/checkBoxHandler.dart';
import 'package:diconnection/src/core/utils/constants.dart';
import 'package:diconnection/src/data/mock/consumer_mock.dart';
import 'package:diconnection/src/data/models/consumer_model.dart';
import 'package:diconnection/src/presentation/widget/consumer_account_item_widget.dart';
import 'package:diconnection/src/presentation/widget/team_item_widget.dart';
import 'package:sizer/sizer.dart';

class DispatchAccountScreen extends StatefulWidget {
  const DispatchAccountScreen({super.key});

  @override
  State<DispatchAccountScreen> createState() =>
      _DispatchAccountScreenState();
}

class _DispatchAccountScreenState extends State<DispatchAccountScreen> {
  List<ConsumerModel> consumerList = ConsumerMockData.consumerList;
  TextEditingController txtSearch = TextEditingController();
  List<ConsumerModel> filterList = [];
  bool chkSelectAll = false;
  final _scrollController = ScrollController();

  void _alterfilter(String query) {
    filterList = [];
    consumerList.forEach((item) {
      if (item.zone == query) {
        filterList.add(item);
      }
    });
  }

  void _deployAccount(List<ConsumerModel> accounts, int team){
    int count = 0;
    accounts.forEach((account) {
      if(CheckBoxHandler.distributeSelected[count]){
        //changing Consumer mock data "Teams"
        ConsumerMockData.consumerList.forEach((element) {
          
         });
      }
      count++;
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Dispatch Accounts"),
        backgroundColor: kScaffoldColor,
      ),
      floatingActionButton: SizedBox(
        height: 22.0.h,
        width: 22.0.w,
        child: FittedBox(
          child: FloatingActionButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                          "CHOOSE TEAM TO DEPLOY", textAlign: TextAlign.center,
                          style: GoogleFonts.lato(fontWeight: FontWeight.w900),
                        ),
                        actions: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TeamItemWidget(
                                      icondata: FontAwesomeIcons.users,
                                      onPressedFunction: () {

                                      },
                                      teamName: "TEAM1"),
                                  TeamItemWidget(
                                      icondata: FontAwesomeIcons.users,
                                      onPressedFunction: () {},
                                      teamName: "TEAM2"),
                                  TeamItemWidget(
                                      icondata: FontAwesomeIcons.users,
                                      onPressedFunction: () {},
                                      teamName: "TEAM3")
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TeamItemWidget(
                                      icondata: FontAwesomeIcons.users,
                                      onPressedFunction: () {},
                                      teamName: "TEAM4"),
                                  TeamItemWidget(
                                      icondata: FontAwesomeIcons.users,
                                      onPressedFunction: () {},
                                      teamName: "TEAM5"),
                                ],
                              )
                            ],
                          )
                        ],
                      ));
            },
            backgroundColor: kBackgroundColor,
            child: const Icon(Icons.add),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 50,
                  width: 50.0.w,
                  child: TextField(
                    onChanged: (val) {
                      CheckBoxHandler.distributeSelected = [];
                      setState(() {
                        _alterfilter(val);
                      });
                    },
                    controller: txtSearch,
                    style: TextStyle(fontSize: 12.0.sp, color: kWhiteColor),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                            borderSide: BorderSide(
                                color: Colors.black, style: BorderStyle.solid)),
                        hintText: "Search here",
                        hintStyle:
                            TextStyle(fontSize: 12.0.sp, color: kWhiteColor),
                        fillColor: kBackgroundColor,
                        filled: true),
                    enabled: true,
                  ),
                ),
                SizedBox(
                  width: 35.0.w,
                  child: DropdownSearch<String>(
                    enabled: true,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        baseStyle:
                            TextStyle(fontSize: 12.0.sp, color: kWhiteColor),
                        dropdownSearchDecoration: InputDecoration(
                            filled: true,
                            fillColor: kBackgroundColor,
                            hintText: "Filter",
                            hintStyle: TextStyle(
                                fontSize: 12.0.sp, color: kWhiteColor),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                borderSide: BorderSide(
                                    color: Colors.black,
                                    style: BorderStyle.solid)))),
                    items: ["Zone", "Team"],
                    onChanged: (data) {
                      if (data != null) {
                        setState(() {});
                      } else {}
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                          activeColor: kLightBlue,
                          value: chkSelectAll, 
                          onChanged: (val){
                            int count = 0;
                            setState(() {
                              chkSelectAll = !chkSelectAll;
                              CheckBoxHandler.distributeSelected.forEach((item){
                                CheckBoxHandler.distributeSelected[count] = chkSelectAll;
                                count++;
                              });
                            });
                          }),
              const Text("Select All?", style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              height: 70.h,
              width: 100.w,
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: SizedBox(
                    height: 70.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: txtSearch.text == ""
                          ? consumerList.length
                          : filterList.length,
                      itemBuilder: (context, index) {
                        int consumerLength = ConsumerMockData.consumerList.length;
                        int chkHandler = CheckBoxHandler.distributeSelected.length;
                        if(chkHandler < consumerLength){
                          CheckBoxHandler.distributeSelected.add(false);
                        }
                        return ConsumerAccountItemWidget(
                          consumerData: txtSearch.text == ""
                              ? consumerList[index]
                              : filterList[index],
                          index: index,
                          onPressedFunction: () {},
                          isDiconnected: false,
                          auth: AuthLevel.Admin,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
