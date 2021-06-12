class goldrate {
  Portfolio portfolio;
  ProductLevel recommendedProduct;

  goldrate({this.portfolio, this.recommendedProduct});

  goldrate.fromJson(Map<String, dynamic> json) {
    portfolio = json['portfolio'] != null
        ? new Portfolio.fromJson(json['portfolio'])
        : null;
    recommendedProduct = json['recommended_product'] != null
        ? new ProductLevel.fromJson(json['recommended_product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.portfolio != null) {
      data['portfolio'] = this.portfolio.toJson();
    }
    if (this.recommendedProduct != null) {
      data['recommended_product'] = this.recommendedProduct.toJson();
    }
    return data;
  }
}

class Portfolio {
  List<ProductLevel> productLevel;

  Portfolio({this.productLevel});

  Portfolio.fromJson(Map<String, dynamic> json) {
    if (json['product_level'] != null) {
      productLevel = new List<ProductLevel>();
      json['product_level'].forEach((v) {
        productLevel.add(new ProductLevel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productLevel != null) {
      data['product_level'] = this.productLevel.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductLevel {
  String id;
  String name;
  String pricePerGm;
  String sellPricePerGm;
  Merchant merchant;

  ProductLevel(
      {this.id,
        this.name,
        this.pricePerGm,
        this.sellPricePerGm,
        this.merchant});

  ProductLevel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pricePerGm = json['price_per_gm'];
    sellPricePerGm = json['sell_price_per_gm'];
    merchant = json['merchant'] != null
        ? new Merchant.fromJson(json['merchant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price_per_gm'] = this.pricePerGm;
    data['sell_price_per_gm'] = this.sellPricePerGm;
    if (this.merchant != null) {
      data['merchant'] = this.merchant.toJson();
    }
    return data;
  }
}

class Merchant {
  String id;
  String name;

  Merchant({this.id, this.name});

  Merchant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}