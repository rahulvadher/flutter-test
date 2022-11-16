import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  bool isHeaderVisible = false;

  ProfilePage({this.isHeaderVisible = false});

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  ClientListModel singleClient = new ClientListModel();
  String segment = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      singleClient = globals.clientList[globals.codeIndex];
      setSegment();
    });
  }

  void setSegment() {
    segment = '';
    if (singleClient.nseEq ?? false) {
      segment = segment + 'NSEEQ';
    }
    if (singleClient.nseFo ?? false) {
      segment = segment + ', NSEFO';
    }
    if (singleClient.nseCd ?? false) {
      segment = segment + ', NSECD';
    }

    if (singleClient.bseCd ?? false) {
      segment = segment + ', BSECD';
    }
    if (singleClient.bseEq ?? false) {
      segment = segment + ', BSEEQ';
    }
    if (singleClient.bseFo ?? false) {
      segment = segment + ', BSEFO';
    }
    if (singleClient.mcx ?? false) {
      segment = segment + ', MCX';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Container(
        
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.isHeaderVisible)
                        Flexible(
                          child: BackNavigationButton(
                            label: 'Profile',
                            isBackVisible: true,
                          ),
                        ),
                      GestureDetector(
                          onTap: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return DropDown(
                                      pickerData: globals.clientList);
                                }).then((value) => {
                                  if (value != null)
                                    {
                                      setState(() {
                                        singleClient = value;
                                        setSegment();
                                      }),
                                    }
                                });
                          },
                          child: Picker(singleClient.clientCode ?? '')),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: AppColor.primaryTextColor,
                          child: new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: LabelTextField(
                                    label: 'Personal',
                                    fontFamily: 'Bold',
                                    textSize: 20.0,
                                  ),
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'Name :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.name ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'Address :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label:
                                        '${singleClient.address1 ?? ''}, ${singleClient.address2 ?? ''}, ${singleClient.address3 ?? ''}${singleClient.city ?? ''} ${singleClient.pinCode ?? ''}',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'Mobile :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.mobileNo ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'Email :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.email ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'PAN :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.panNo ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'Aadhar No :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.adharNo ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'DOB :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label:Helpers.changeDateFormat( singleClient.dateOfBirth.toString(), "yyyy-MM-dd", 'dd-MM-yyyy') ,
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'UPI ID :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label:  singleClient.upiId??'',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: AppColor.primaryTextColor,
                          child: new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: LabelTextField(
                                    label: 'Trading',
                                    fontFamily: 'Bold',
                                    textSize: 20.0,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: 'Client Code :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.clientCode ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: 'Active Segment :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: segment,
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: 'A/c Opened Date :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label:Helpers.changeDateFormat( singleClient.openDate.toString(), "yyyy-MM-dd HH:mm:ss", 'dd-MM-yyyy') ,
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: AppColor.primaryTextColor,
                          child: new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: LabelTextField(
                                    label: 'Demat',
                                    fontFamily: 'Bold',
                                    textSize: 20.0,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'DP Name :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label:  'Patel Wealth Advisors Pvt. Ltd.',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'DP ID :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.memberDpId ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'Client ID :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.dpId ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'POA Flag :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.poaFlag??false ? 'Yes' : 'No',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: AppColor.primaryTextColor,
                          child: new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: LabelTextField(
                                    label: 'Bank',
                                    fontFamily: 'Bold',
                                    textSize: 20.0,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'Account No :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.bankAccountNo ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'Name :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.bankName ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'Address :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label:
                                        '${singleClient.bankAdd1 ?? ''}, ${singleClient.bankAdd2 ?? ''}, ${singleClient.bankAdd3 ?? ''} ${singleClient.bankAdd4 ?? ''}',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'IFSC Code :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.bankIfscCode ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: LabelTextField(
                                        label: 'MICR Code :- ',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: LabelTextField(
                                        label: singleClient.bankMicrCode ?? '',
                                        textColor: AppColor.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
