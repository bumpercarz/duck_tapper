import '../models/account.dart';
import 'package:flutter/material.dart';

Future<int> checkInput(BuildContext context, List<Account> accounts, String username, String password) async {
  int accountToLog = 0;
  int i = 0;
  // DUCK/accounts CHANGE LINK HERE IMPORTANT
  while(i < accounts.length){
    if(accounts[i].username == username && accounts[i].password == password) 
    {
      accountToLog = accounts[i].id ?? 0;
      i == accounts.length;
    }
    i++;
  }
  return accountToLog;
}
