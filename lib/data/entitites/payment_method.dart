class PaymentMethod {
  final String name;

  const PaymentMethod({
    required this.name,
  });
}

class UPIPaymentMethod extends PaymentMethod {
  final String vpa;
  const UPIPaymentMethod({
    required super.name,
    required this.vpa,
  });
}

class CardPaymentMethod extends PaymentMethod {
  final String last4;
  final String cardType;
  final String cardIssuer;
  final String cardNetwork;
  const CardPaymentMethod({
    required super.name,
    required this.last4,
    required this.cardType,
    required this.cardIssuer,
    required this.cardNetwork,
  });
}

class WalletPaymentMethod extends PaymentMethod {
  final String walletType;
  const WalletPaymentMethod({
    required super.name,
    required this.walletType,
  });
}

class CashOnDeliveryPaymentMethod extends PaymentMethod {
  const CashOnDeliveryPaymentMethod() : super(name: "Cash on Delivery");
}
