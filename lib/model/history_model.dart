import 'base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TxnType { credit, debit,unknown }
enum TxnMethod { creitCard, bank, promotion, other }
enum TxnStatus { completed, pending, rejected, cancelled,unknown }

class History{
  int id;
  String txnid;
  TxnType txnType;
  TxnMethod txnMethod;
  TxnStatus txnStatus;
  double txnAmount;
  String txndate;
  History();
  History.fromJson(Map<String,dynamic> data)
  {
    this.id=data['id'];
    this.txnStatus=settxnStatus(data['status']);
    this.txnType=settnxType(data['type']);
    this.settxnMethod(data['txnmethod']) ;
    this.txnAmount=data['amount'];
    txndate=data['txndate'];
  }
  String gettnxType() {
    switch (txnType) {
      case TxnType.credit:
        return 'Credit';
        break;
      case TxnType.debit:
        return 'Debit';
        break;
      default:
        return 'Unknown';
    }
  }
  TxnType settnxType(String type) {
    switch (type) {
      case 'Credit' :
        return TxnType.credit ;
        break;
      case 'Debit':
        return TxnType.debit;
        break;
      default:
        return TxnType.unknown;
    }
  }
  String gettxnMethod() {
    switch (txnMethod) {
      case TxnMethod.bank:
        return 'Bank';
        break;
      case TxnMethod.creitCard:
        return 'CreditCard';
        break;
      case TxnMethod.promotion:
        return 'Promotions';
        break;
      case TxnMethod.other:
        return 'Other';
        break;
      default:
        return 'Unknown';
    }
  }
   TxnMethod  settxnMethod(String method) {
    switch (method) {
      case 'Bank':
        return TxnMethod.bank;
        break;
      case 'CreditCard':
        return TxnMethod.creitCard;
        break;
      case 'Promotions':
        return TxnMethod.promotion;
        break;
      case 'Other':
        return TxnMethod.other;
        break;
      default:
        return TxnMethod.promotion;
    }
  }

  String gettxnStatus() {
    switch (txnStatus) {
      case TxnStatus.completed:
        return 'Completed';
        break;
      case TxnStatus.pending:
        return 'Pending';
        break;
      case TxnStatus.rejected:
        return 'Rejected';
        break;
      case TxnStatus.cancelled:
        return 'Cancelled';
        break;
      default:
        return 'Unknown';
    }
  }
    TxnStatus settxnStatus(String status) {
    switch (status) {
      case 'Completed':
        return TxnStatus.completed;
        break;
      case 'Pending':
        return TxnStatus.pending;
        break;
      case 'Rejected':
        return TxnStatus.rejected;
        break;
      case 'Cancelled':
        return TxnStatus.cancelled;
        break;
      default:
        return TxnStatus.unknown;
    }
  }


  Future<double> getCurrentBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('mainbalance') ?? 0;
  }

  setCurrentBalance(double amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('mainbalance', amount);
  }
}
class Transaction extends BaseModel
{
  List<History> transactions=[];
  Transaction.fromjson(List<Map<String,dynamic>> data)
  {
    List<History> _temp=[];
    for (var item in data) {
    _temp.add(History.fromJson(item));
      
    }
    transactions=_temp;
  }
}
