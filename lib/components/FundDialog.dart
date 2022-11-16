import 'dart:convert';
import 'dart:io';

import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/model/BankListModel.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/FundsOrderModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;
import 'InputTextField.dart';
import 'RadioButton.dart';
import 'SubmitButton.dart';
import 'DropDown.dart';

class FundDialog extends StatefulWidget {
  State<StatefulWidget> createState() => FundDialogState();
}

class FundDialogState extends State<FundDialog> {
  ClientListModel singleClient = new ClientListModel();
  BankListModel selectedBank = new BankListModel();
  TextEditingController amountController = TextEditingController();
  bool chbTerm = false;
  int bankRbValue = -1, paymentModeRbValue = 1;
  Response response = Response('', 200);
  List<BankListModel> bankList = [];
  FundsOrderModel orderModel = new FundsOrderModel();
  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    getBankList();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            shadowColor: AppColor.primaryColor,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                    }),
                                  }
                              });
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Picker(singleClient.clientCode ?? ''),
                        ),
                      ),
                    ],
                  ),
                  InputTextField(
                    onChanged: (text) {
                      amountController.selection = TextSelection.fromPosition(
                        TextPosition(offset: amountController.text.length),
                      );
                    },
                    labelText: 'Amount',
                    textFieldController: amountController,
                    textInputType: TextInputType.number,
                    textInputLength: 10,
                    icon: IconView(
                      icon: Icons.smartphone,
                      size: 20,
                      color: AppColor.primaryHintColor,
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    shadowColor: AppColor.primaryTextColor,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 5.0, bottom: 5.0),
                      child: Column(
                        children: [
                          LabelTextField(
                            label: 'Payment Mode',
                            fontFamily: 'SemiBold',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RadioButton<int>(
                                value: 1,
                                groupValue: paymentModeRbValue,
                                leading: 'A',
                                title: LabelTextField(
                                  label: 'Net Banking',
                                  textColor: AppColor.secondaryTextColor,
                                ),
                                onChanged: (value) =>
                                    setState(() => paymentModeRbValue = value!),
                              ),
                              RadioButton<int>(
                                value: 2,
                                groupValue: paymentModeRbValue,
                                leading: 'A',
                                title: LabelTextField(
                                  label: 'UPI',
                                  textColor: AppColor.secondaryTextColor,
                                ),
                                onChanged: (value) =>
                                    setState(() => paymentModeRbValue = value!),
                              ),
                            ],
                          ),
                          LabelTextField(
                            label: 'Bank Payment',
                            fontFamily: 'SemiBold',
                          ),
                          bankListView(),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: AppColor.primaryColor,
                        checkColor: AppColor.primaryTextColor,
                        value: chbTerm,
                        onChanged: (bool? value) {
                          setState(() {
                            chbTerm = value!;
                          });
                        },
                      ),
                      Flexible(
                        child: LabelTextField(
                          onPressed: () {},
                          label: 'I agree with terms and conditions',
                          textColor: AppColor.secondaryTextColor,
                        ),
                      ),
                      LabelTextField(
                        onPressed: () {},
                        label: '(Read)',
                        fontFamily: 'SemiBold',
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: SubmitButton(
                        onPressed: () {
                          if (amountController.text.isEmpty) {
                            Helpers.showAlertDialog('Enter amount', context);
                          } else if (selectedBank.bankAccountNumber == null) {
                            Helpers.showAlertDialog('Select Bank', context);
                          } else if (!chbTerm) {
                            Helpers.showAlertDialog(
                                'Check term and conditions', context);
                          } else {
                            callPayment();
                          }
                        },
                        fontFamily: 'SemiBold',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Card(
              margin: EdgeInsets.only(top: 15.0),
              elevation: 5.0,
              shadowColor: AppColor.primaryTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Container(
                width: 40.0,
                height: 40.0,
                child: IconView(icon: Icons.clear),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bankListView() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: new ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          itemCount: bankList.length,
          itemBuilder: (context, index) {
            BankListModel singleBank = bankList[index];

            return Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelTextField(
                        onPressed: () {},
                        label:
                            '${singleBank.bankName ?? ''} *${singleBank.bankAccountNumber.toString().substring(singleBank.bankAccountNumber.toString().length - 4)}',
                        textColor: AppColor.secondaryTextColor,
                      ),
                      RadioButton<int>(
                        value: index,
                        groupValue: bankRbValue,
                        leading: index.toString(),
                        title: LabelTextField(
                          label: '',
                          textSize: 0.0,
                        ),
                        onChanged: (value) => setState(() =>
                            {selectedBank = singleBank, bankRbValue = value!}),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  getBankList() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/client/bank/${singleClient.clientCode}',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                bankList = (json.decode(response.body) as List)
                    .map((i) => BankListModel.fromJson(i))
                    .toList();
              })
            }
        });
  }

  callPayment() async {
    var options;
    var prefill;
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
      'Content-Type': 'application/json'
    };
    Map<String, dynamic> bankAccount = {
      'account_number': selectedBank.bankAccountNumber,
      'name': selectedBank.bankName,
      'ifsc': selectedBank.bankIfsc,
    };
    Map<String, dynamic> amount = {
      'clientCode': singleClient.clientCode,
      'amount': amountController.text,
      'method': paymentModeRbValue == 1 ? 'netbanking' : 'upi',
      'platform': Platform.operatingSystem,
      'bankAccount': bankAccount,
    };
    await ApiService.postMethod(
            '${Constants.middleWareBaseUrl}/api/v1/payment/razorpay/order',
            context,
            headerParam: headerParam,
            bodyParam: jsonEncode(amount))
        .then((result) => {
              response = result,
              if (response.statusCode == 200)
                {
                  orderModel =
                      FundsOrderModel.fromJson(jsonDecode(response.body)),
                  prefill = {
                    'email': singleClient.email,
                    'contact': singleClient.mobileNo,
                  },
                  options = {
                    'key': 'rzp_live_PHZhuLwxutqQiL',
                    'currency': orderModel.currency,
                    'name': 'Patel Wealth Advisors Pvt. Ltd.',
                    'amount': orderModel.amount,
                    'order_id': orderModel.id,
                    'prefill': prefill,
                  },
                  razorpay.open(options),
                }
            });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('_handlePaymentSuccess ${response.orderId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('_handlePaymentError ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('_handleExternalWallet ${response.walletName}');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }
}
