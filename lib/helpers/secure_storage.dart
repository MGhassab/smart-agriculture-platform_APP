import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  //static const _keyBiometric = 'biometric';
  static const _keyToken = 'token';
  //static const _keyAccounts = 'accounts';
  //static const _keyAccountTransfers = 'accountTransfers';
  //static const _keyBankCards = 'bankCards';
  //static const _keyBills = 'bills';
  //static const _keySimCards = 'simCards';
  //static const _keyTransactions = 'transactions';
  //static const _keyTransfers = 'transfers';

  static Future setToken(String token) async =>
      await _storage.write(key: _keyToken, value: token);

  static Future<String> getToken() async {
    final value = await _storage.read(key: _keyToken);
    return (value != null) ? value : '';
  }

  /*
  static Future setAuth(String auth) async => await _storage.write(key: _keyBiometric, value: auth);

  static Future<String> getAuth() async {
    final value = await _storage.read(key: _keyBiometric);
    return (value != null) ? value : '0';
  }

  static Future setAccounts(List<Account> accounts) async {
    final value = json.encode(accounts);
    await _storage.write(key: _keyAccounts, value: value);
  }

  static Future getAccounts(context) async {
    final value = await _storage.read(key: _keyAccounts);
    if (value != null) {
      var accountsJson = json.decode(value);
      for (var accountJson in accountsJson) {
        context.read(accountTransfersNotifierProvider).addAccountFromJson(Account.fromJson(accountJson));
        //Provider.of<Accounts>(context, listen: false).addAccountFromJson(Account.fromJson(accountJson));
      }
    }
  }

  static Future setAccountTransfers(List<AccountTransfer> accountTransfers) async {
    final value = json.encode(accountTransfers);
    await _storage.write(key: _keyAccountTransfers, value: value);
  }

  static Future getAccountTransfers(context) async {
    final value = await _storage.read(key: _keyAccountTransfers);
    if (value != null) {
      var accountTransfersJson = json.decode(value);
      for (var accountTransferJson in accountTransfersJson) {
        context.read(accountTransfersNotifierProvider).addAccountTransferFromJson(AccountTransfer.fromJson(accountTransferJson));
        //Provider.of<AccountTransfers>(context, listen: false).addAccountTransferFromJson(AccountTransfer.fromJson(accountTransferJson));
      }
    }
  }

  static Future removeAccountTransfers() async {
    await _storage.delete(key: _keyAccountTransfers);
  }

  static Future setBankCards(List<BankCard> bankCards) async {
    final value = json.encode(bankCards);
    await _storage.write(key: _keyBankCards, value: value);
  }

  static Future getBankCards(context) async {
    final value = await _storage.read(key: _keyBankCards);
    if (value != null) {
      var bankCardsJson = json.decode(value);
      for (var bankCardJson in bankCardsJson) {
        context.read(bankCardsNotifierProvider).addBankCardFromJson(BankCard.fromJson(bankCardJson));
        //Provider.of<BankCards>(context, listen: false).addBankCardFromJson(BankCard.fromJson(bankCardJson));
      }
    }
  }

  static Future removeBankCards() async {
    await _storage.delete(key: _keyBankCards);
  }

  static Future setBills(List<Bill> bills) async {
    final value = json.encode(bills);
    await _storage.write(key: _keyBills, value: value);
  }

  static Future getBills(context) async {
    final value = await _storage.read(key: _keyBills);
    if (value != null) {
      var billsJson = json.decode(value);
      for (var billJson in billsJson) {
        context.read(billsNotifierProvider).addBillFromJson(Bill.fromJson(billJson));
        //Provider.of<Bills>(context, listen: false).addBillFromJson(Bill.fromJson(billJson));
      }
    }
  }

  static Future removeBills() async {
    await _storage.delete(key: _keyBills);
  }

  static Future setSimCards(List<SimCard> simCards) async {
    final value = json.encode(simCards);
    await _storage.write(key: _keySimCards, value: value);
  }

  static Future getSimCards(context) async {
    final value = await _storage.read(key: _keySimCards);
    if (value != null) {
      var simCardsJson = json.decode(value);
      for (var simCardJson in simCardsJson) {
        context.read(simCardsNotifierProvider).addSimCardFromJson(SimCard.fromJson(simCardJson));
        //Provider.of<SimCards>(context, listen: false)
        //.addSimCardFromJson(SimCard.fromJson(simCardJson));
      }
    }
  }

  static Future removeSimCards() async {
    await _storage.delete(key: _keySimCards);
  }

  static Future setTransactions(List<Transaction> transactions) async {
    final value = json.encode(transactions);
    await _storage.write(key: _keyTransactions, value: value);
  }

  static Future<List<Transaction>?> getTransactions(context) async {
    final value = await _storage.read(key: _keyTransactions);
    return value == null ? null : List<Transaction>.from(json.decode(value));
  }

  static Future setTransfers(List<Transfer> transfers) async {
    final value = json.encode(transfers);
    await _storage.write(key: _keyTransfers, value: value);
  }

  static Future getTransfers(context) async {
    final value = await _storage.read(key: _keyTransfers);
    if (value != null) {
      var transfersJson = json.decode(value);
      for (var transferJson in transfersJson) {
        context.read(transfersNotifierProvider).addTransferFromJson(Transfer.fromJson(transferJson));
        //Provider.of<Transfers>(context, listen: false)
        //.addTransferFromJson(Transfer.fromJson(transferJson));
      }
    }
  }

  static Future removeTransfers() async {
    await _storage.delete(key: _keyTransfers);
  }

   */
}
