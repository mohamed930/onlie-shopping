// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class AllproducsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Allproducs {
      category(input: {title: "all"}) {
        __typename
        products {
          __typename
          ...productsDetails
        }
      }
    }
    """

  public let operationName: String = "Allproducs"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ProductsDetails.fragmentDefinition)
    document.append("\n" + PriceDetails.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("category", arguments: ["input": ["title": "all"]], type: .object(Category.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(category: Category? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "category": category.flatMap { (value: Category) -> ResultMap in value.resultMap }])
    }

    public var category: Category? {
      get {
        return (resultMap["category"] as? ResultMap).flatMap { Category(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "category")
      }
    }

    public struct Category: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Category"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("products", type: .nonNull(.list(.object(Product.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(products: [Product?]) {
        self.init(unsafeResultMap: ["__typename": "Category", "products": products.map { (value: Product?) -> ResultMap? in value.flatMap { (value: Product) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var products: [Product?] {
        get {
          return (resultMap["products"] as! [ResultMap?]).map { (value: ResultMap?) -> Product? in value.flatMap { (value: ResultMap) -> Product in Product(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Product?) -> ResultMap? in value.flatMap { (value: Product) -> ResultMap in value.resultMap } }, forKey: "products")
        }
      }

      public struct Product: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Product"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(ProductsDetails.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var productsDetails: ProductsDetails {
            get {
              return ProductsDetails(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class AllproducsWithColthesTagQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query AllproducsWithColthesTag {
      category(input: {title: "clothes"}) {
        __typename
        products {
          __typename
          ...productsDetails
        }
      }
    }
    """

  public let operationName: String = "AllproducsWithColthesTag"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ProductsDetails.fragmentDefinition)
    document.append("\n" + PriceDetails.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("category", arguments: ["input": ["title": "clothes"]], type: .object(Category.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(category: Category? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "category": category.flatMap { (value: Category) -> ResultMap in value.resultMap }])
    }

    public var category: Category? {
      get {
        return (resultMap["category"] as? ResultMap).flatMap { Category(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "category")
      }
    }

    public struct Category: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Category"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("products", type: .nonNull(.list(.object(Product.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(products: [Product?]) {
        self.init(unsafeResultMap: ["__typename": "Category", "products": products.map { (value: Product?) -> ResultMap? in value.flatMap { (value: Product) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var products: [Product?] {
        get {
          return (resultMap["products"] as! [ResultMap?]).map { (value: ResultMap?) -> Product? in value.flatMap { (value: ResultMap) -> Product in Product(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Product?) -> ResultMap? in value.flatMap { (value: Product) -> ResultMap in value.resultMap } }, forKey: "products")
        }
      }

      public struct Product: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Product"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(ProductsDetails.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var productsDetails: ProductsDetails {
            get {
              return ProductsDetails(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class AllproducsWithTechTagQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query AllproducsWithTechTag {
      category(input: {title: "tech"}) {
        __typename
        products {
          __typename
          ...productsDetails
        }
      }
    }
    """

  public let operationName: String = "AllproducsWithTechTag"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ProductsDetails.fragmentDefinition)
    document.append("\n" + PriceDetails.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("category", arguments: ["input": ["title": "tech"]], type: .object(Category.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(category: Category? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "category": category.flatMap { (value: Category) -> ResultMap in value.resultMap }])
    }

    public var category: Category? {
      get {
        return (resultMap["category"] as? ResultMap).flatMap { Category(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "category")
      }
    }

    public struct Category: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Category"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("products", type: .nonNull(.list(.object(Product.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(products: [Product?]) {
        self.init(unsafeResultMap: ["__typename": "Category", "products": products.map { (value: Product?) -> ResultMap? in value.flatMap { (value: Product) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var products: [Product?] {
        get {
          return (resultMap["products"] as! [ResultMap?]).map { (value: ResultMap?) -> Product? in value.flatMap { (value: ResultMap) -> Product in Product(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Product?) -> ResultMap? in value.flatMap { (value: Product) -> ResultMap in value.resultMap } }, forKey: "products")
        }
      }

      public struct Product: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Product"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(ProductsDetails.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var productsDetails: ProductsDetails {
            get {
              return ProductsDetails(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class ProductDetailsViewQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query productDetailsView($id: String!) {
      product(id: $id) {
        __typename
        id
        name
        brand
        inStock
        gallery
        description
        category
        attributes {
          __typename
          ...attributeDetails
        }
        prices {
          __typename
          ...priceDetails
        }
      }
    }
    """

  public let operationName: String = "productDetailsView"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + AttributeDetails.fragmentDefinition)
    document.append("\n" + PriceDetails.fragmentDefinition)
    return document
  }

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("product", arguments: ["id": GraphQLVariable("id")], type: .object(Product.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(product: Product? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "product": product.flatMap { (value: Product) -> ResultMap in value.resultMap }])
    }

    public var product: Product? {
      get {
        return (resultMap["product"] as? ResultMap).flatMap { Product(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "product")
      }
    }

    public struct Product: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Product"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("brand", type: .nonNull(.scalar(String.self))),
          GraphQLField("inStock", type: .scalar(Bool.self)),
          GraphQLField("gallery", type: .list(.scalar(String.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
          GraphQLField("category", type: .nonNull(.scalar(String.self))),
          GraphQLField("attributes", type: .list(.object(Attribute.selections))),
          GraphQLField("prices", type: .nonNull(.list(.nonNull(.object(Price.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, name: String, brand: String, inStock: Bool? = nil, gallery: [String?]? = nil, description: String, category: String, attributes: [Attribute?]? = nil, prices: [Price]) {
        self.init(unsafeResultMap: ["__typename": "Product", "id": id, "name": name, "brand": brand, "inStock": inStock, "gallery": gallery, "description": description, "category": category, "attributes": attributes.flatMap { (value: [Attribute?]) -> [ResultMap?] in value.map { (value: Attribute?) -> ResultMap? in value.flatMap { (value: Attribute) -> ResultMap in value.resultMap } } }, "prices": prices.map { (value: Price) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var brand: String {
        get {
          return resultMap["brand"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "brand")
        }
      }

      public var inStock: Bool? {
        get {
          return resultMap["inStock"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "inStock")
        }
      }

      public var gallery: [String?]? {
        get {
          return resultMap["gallery"] as? [String?]
        }
        set {
          resultMap.updateValue(newValue, forKey: "gallery")
        }
      }

      public var description: String {
        get {
          return resultMap["description"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }

      public var category: String {
        get {
          return resultMap["category"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "category")
        }
      }

      public var attributes: [Attribute?]? {
        get {
          return (resultMap["attributes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Attribute?] in value.map { (value: ResultMap?) -> Attribute? in value.flatMap { (value: ResultMap) -> Attribute in Attribute(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Attribute?]) -> [ResultMap?] in value.map { (value: Attribute?) -> ResultMap? in value.flatMap { (value: Attribute) -> ResultMap in value.resultMap } } }, forKey: "attributes")
        }
      }

      public var prices: [Price] {
        get {
          return (resultMap["prices"] as! [ResultMap]).map { (value: ResultMap) -> Price in Price(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Price) -> ResultMap in value.resultMap }, forKey: "prices")
        }
      }

      public struct Attribute: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["AttributeSet"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(AttributeDetails.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var attributeDetails: AttributeDetails {
            get {
              return AttributeDetails(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }

      public struct Price: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Price"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(PriceDetails.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var priceDetails: PriceDetails {
            get {
              return PriceDetails(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public struct ProductsDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment productsDetails on Product {
      __typename
      id
      name
      inStock
      gallery
      prices {
        __typename
        ...priceDetails
      }
    }
    """

  public static let possibleTypes: [String] = ["Product"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("inStock", type: .scalar(Bool.self)),
      GraphQLField("gallery", type: .list(.scalar(String.self))),
      GraphQLField("prices", type: .nonNull(.list(.nonNull(.object(Price.selections))))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String, name: String, inStock: Bool? = nil, gallery: [String?]? = nil, prices: [Price]) {
    self.init(unsafeResultMap: ["__typename": "Product", "id": id, "name": name, "inStock": inStock, "gallery": gallery, "prices": prices.map { (value: Price) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
    get {
      return resultMap["id"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var inStock: Bool? {
    get {
      return resultMap["inStock"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "inStock")
    }
  }

  public var gallery: [String?]? {
    get {
      return resultMap["gallery"] as? [String?]
    }
    set {
      resultMap.updateValue(newValue, forKey: "gallery")
    }
  }

  public var prices: [Price] {
    get {
      return (resultMap["prices"] as! [ResultMap]).map { (value: ResultMap) -> Price in Price(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: Price) -> ResultMap in value.resultMap }, forKey: "prices")
    }
  }

  public struct Price: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Price"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(PriceDetails.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var priceDetails: PriceDetails {
        get {
          return PriceDetails(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct PriceDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment priceDetails on Price {
      __typename
      currency {
        __typename
        symbol
      }
      amount
    }
    """

  public static let possibleTypes: [String] = ["Price"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("currency", type: .nonNull(.object(Currency.selections))),
      GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(currency: Currency, amount: Double) {
    self.init(unsafeResultMap: ["__typename": "Price", "currency": currency.resultMap, "amount": amount])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var currency: Currency {
    get {
      return Currency(unsafeResultMap: resultMap["currency"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "currency")
    }
  }

  public var amount: Double {
    get {
      return resultMap["amount"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "amount")
    }
  }

  public struct Currency: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Currency"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(symbol: String) {
      self.init(unsafeResultMap: ["__typename": "Currency", "symbol": symbol])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var symbol: String {
      get {
        return resultMap["symbol"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "symbol")
      }
    }
  }
}

public struct AttributeDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment attributeDetails on AttributeSet {
      __typename
      id
      name
      type
      items {
        __typename
        displayValue
        value
        id
      }
    }
    """

  public static let possibleTypes: [String] = ["AttributeSet"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .scalar(String.self)),
      GraphQLField("type", type: .scalar(String.self)),
      GraphQLField("items", type: .list(.object(Item.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String, name: String? = nil, type: String? = nil, items: [Item?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "AttributeSet", "id": id, "name": name, "type": type, "items": items.flatMap { (value: [Item?]) -> [ResultMap?] in value.map { (value: Item?) -> ResultMap? in value.flatMap { (value: Item) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
    get {
      return resultMap["id"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var type: String? {
    get {
      return resultMap["type"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "type")
    }
  }

  public var items: [Item?]? {
    get {
      return (resultMap["items"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Item?] in value.map { (value: ResultMap?) -> Item? in value.flatMap { (value: ResultMap) -> Item in Item(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Item?]) -> [ResultMap?] in value.map { (value: Item?) -> ResultMap? in value.flatMap { (value: Item) -> ResultMap in value.resultMap } } }, forKey: "items")
    }
  }

  public struct Item: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Attribute"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("displayValue", type: .scalar(String.self)),
        GraphQLField("value", type: .scalar(String.self)),
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(displayValue: String? = nil, value: String? = nil, id: String) {
      self.init(unsafeResultMap: ["__typename": "Attribute", "displayValue": displayValue, "value": value, "id": id])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var displayValue: String? {
      get {
        return resultMap["displayValue"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "displayValue")
      }
    }

    public var value: String? {
      get {
        return resultMap["value"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "value")
      }
    }

    public var id: String {
      get {
        return resultMap["id"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }
  }
}
