enum paymentMethods { Bank, CreditCard, Paypal }  

class PaymentModel 
{
  String key;
  String name,bank,number;
  paymentMethods type;
  PaymentModel({this.name,this.number,this.bank,this.type});
  PaymentModel.cc({this.key,this.name,this.number})
  {
    this.type=paymentMethods.CreditCard;
  }
  PaymentModel.bank({this.key,this.name,this.number,})
   {
    this.type=paymentMethods.Bank;
  }
  PaymentModel.paypal({this.key,this.name,this.number,this.bank,this.type})
   {
    this.type=paymentMethods.Paypal;
  }
}