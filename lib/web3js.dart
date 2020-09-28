import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

import 'package:google_fonts/google_fonts.dart';

class Web3Js extends StatefulWidget {
  @override
  _Web3JsState createState() => _Web3JsState();
}

class _Web3JsState extends State<Web3Js> {
  bool ethFlag = false;
  bool webFlag = false;
  String network = '';
  String account = '';
  String balance = '';
  String tokenBalance = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          _ethWidget(context),
          SizedBox(height: 10),
          _web3jsWidget(context),
          SizedBox(height: 10),
          _networkWidget(context),
          SizedBox(height: 10),
          _callMetaMaskWidget(context),
          SizedBox(height: 10),
          _accountWidget(context),
          SizedBox(height: 10),
          _balanceWidget(context),
          SizedBox(height: 10),
          _sendTransactionWidget(context),
          SizedBox(height: 10),
          _contractBalanceOfWidget(context),
          SizedBox(height: 10),
          _contractTransferWidget(context),
        ],
      ),
    );
  }

  Widget _ethWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          ethFlag = js.context.hasProperty('ethereum');
        });
        js.context.callMethod('alert', [ethFlag]);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ethereum.js: ',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
            SizedBox(width: 10),
            Text(
              ethFlag ? 'yes' : 'no',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _web3jsWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          webFlag = js.context.hasProperty("web3");
        });
        js.context.callMethod("alert", [webFlag]);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'web3.js: ',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
            SizedBox(width: 10),
            Text(
              webFlag ? 'yes' : 'no',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _callMetaMaskWidget(BuildContext context) {
    return InkWell(
      onTap: () async {
        (js.context["ethereum"] as js.JsObject).callMethod("send", <dynamic>["eth_requestAccounts"]);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Chip(
                padding: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
                backgroundColor: Colors.blue[500],
                label: Text(
                  'MetaMask',
                  style: GoogleFonts.lato(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        var arr = js.context["web3"]["eth"]["accounts"] as js.JsArray;
        if (arr.isNotEmpty) {
          setState(() {
            account = arr[0].toString();
          });
        }
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'account: ',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '$account',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _balanceWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        if (account != null && account.trim() != '') {
          (js.context["web3"]["eth"] as js.JsObject).callMethod('getBalance', [
            account,
            'latest',
                (err, value) {
              if (err != null && err == true) {
                js.context.callMethod("alert", ['getBalance error:' + err.toString()]);
              } else {
                js.context.callMethod("alert", ['getBalance value::' + value.toString()]);
                final decimalWei = Decimal.tryParse(value?.toString());
                if (decimalWei == null) {
                } else {
                  balance = (decimalWei / Decimal.fromInt(10).pow(18)).toString();
                }
                setState(() {});
              }
            }
          ]);
        }
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'balance: ',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '$balance ETH',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _networkWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        var result = js.context['ethereum']['networkVersion'];
        js.context.callMethod("alert", ['network:' + result.toString()]);
        setState(() {
          network = getNetwork(result.toString());
        });
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'network: ',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '$network',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sendTransactionWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        if (account != null && account.trim() != '') {
          js.context.callMethod('sendTransaction', [
            '0x5bbF0971382Faa31ca55e74D89875a1F1531311e',
            '0x9120892E98fc20DAF33691619D9b70c099625107',
            0.1
          ]);
        }
      },
      child: Container(
        child: Chip(
          padding: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
          backgroundColor: Colors.blue[500],
          label: Text(
            'SendTransaction',
            style: GoogleFonts.lato(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _contractBalanceOfWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        js.context['setTokenBalance']=setTokenBalance;
        if (account != null && account.trim() != '') {
          js.context.callMethod('contractBalanceOf', [account]);
        }
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ContractBalanceOfToken: ',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '$tokenBalance Token',
              style: GoogleFonts.lato(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setTokenBalance(value) {
    print('setTokenBalance value:' + value.toString());
    setState(() {
      tokenBalance = value.toString();
    });
  }

  Widget _contractTransferWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        js.context['reloadContractBalanceOf']=reloadContractBalanceOf;
        if (account != null && account.trim() != '') {
          js.context.callMethod('contractTransfer', [
            account,
            '0x9120892E98fc20DAF33691619D9b70c099625107',
            500*1e18,
          ]);
        }
      },
      child: Container(
        child: Chip(
          padding: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
          backgroundColor: Colors.blue[500],
          label: Text(
            'ContractTransferOfToken',
            style: GoogleFonts.lato(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void reloadContractBalanceOf() {
    print('reloadContractBalanceOf');
    if (account != null && account.trim() != '') {
      js.context.callMethod('contractBalanceOf', [account]);
    }
  }

  String getNetwork(String id) {
    switch (id.trim()) {
      case '1':
        return 'Mainnet';
      case "2":
        return 'Morden';
      case "3":
        return 'Ropsten';
      case "4":
        return 'Rinkeby';
      case "42":
        return 'Kovan';
      default:
        return 'unknown network';
    }
  }
}
