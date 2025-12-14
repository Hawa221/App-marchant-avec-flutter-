import 'package:flutter/material.dart';

void main() => runApp(const PerfumeApp());

// -------------------- MODELE --------------------
class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> notes;
  final String category; // homme / femme / unisexe

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.notes,
    required this.category,
  });
}

final List<Product> kProducts = [
  const Product(
    id: 'p1',
    name: 'Chanel N°5',
    brand: 'Chanel',
    price: 120,
    imageUrl: 'assets/chanel5.jpg',
    description:
        'Icône intemporelle. Bouquet floral aldéhydé élégant et raffiné.',
    notes: ['Aldéhydes', 'Jasmin', 'Rose', 'Ylang-ylang'],
    category: 'femme',
  ),
  const Product(
    id: 'p2',
    name: 'Dior Sauvage',
    brand: 'Dior',
    price: 95,
    imageUrl: 'assets/sauvagedior.jpg',
    description:
        'Fraîcheur brute et noble. Bergamote vive et ambroxan puissant.',
    notes: ['Bergamote', 'Ambroxan', 'Poivre', 'Lavande'],
    category: 'homme',
  ),
  const Product(
    id: 'p3',
    name: 'YSL Libre',
    brand: 'Yves Saint Laurent',
    price: 110,
    imageUrl: 'assets/ysllibre.webp',
    description: 'Contraste audacieux entre lavande et fleur d’oranger.',
    notes: ['Lavande', 'Fleur d’oranger', 'Vanille', 'Mandarine'],
    category: 'femme',
  ),
  const Product(
    id: 'p4',
    name: 'Bleu de Chanel',
    brand: 'Chanel',
    price: 115,
    imageUrl: 'assets/bleuchanel.jpg',
    description: 'Boisé aromatique. Élégance et force tranquille.',
    notes: ['Agrumes', 'Bois de cèdre', 'Santal', 'Encens'],
    category: 'homme',
  ),
  const Product(
    id: 'p5',
    name: 'La Vie Est Belle',
    brand: 'Lancôme',
    price: 105,
    imageUrl: 'assets/lancome.webp',
    description: 'Un parfum lumineux et joyeux, symbole du bonheur.',
    notes: ['Iris', 'Patchouli', 'Vanille', 'Fleurs blanches'],
    category: 'femme',
  ),
  const Product(
    id: 'p6',
    name: 'Black Opium',
    brand: 'Yves Saint Laurent',
    price: 99,
    imageUrl: 'assets/blackopium.webp',
    description:
        'Un parfum gourmand et addictif, café intense et vanille sensuelle.',
    notes: ['Café', 'Vanille', 'Fleur d’oranger', 'Cèdre'],
    category: 'femme',
  ),
  const Product(
    id: 'p7',
    name: 'Light Blue',
    brand: 'Dolce & Gabbana',
    price: 89,
    imageUrl: 'assets/lightblue.webp',
    description:
        'Fraîcheur méditerranéenne, citron sicilien et pomme verte pétillante.',
    notes: ['Citron', 'Pomme verte', 'Cèdre', 'Musc'],
    category: 'unisexe',
  ),
  const Product(
    id: 'p8',
    name: 'Flowerbomb',
    brand: 'Viktor & Rolf',
    price: 115,
    imageUrl: 'assets/flowerbomb.webp',
    description: 'Explosion florale, un bouquet opulent et sensuel.',
    notes: ['Jasmin', 'Rose', 'Orchidée', 'Patchouli'],
    category: 'femme',
  ),
];

// -------------------- APP --------------------
class PerfumeApp extends StatelessWidget {
  const PerfumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          primary: Colors.pink.shade600,
          secondary: Colors.redAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink.shade500,
            foregroundColor: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}

// -------------------- APP SHELL --------------------
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final Map<String, int> _cart = {};
  final Set<String> _favorites = {};
  List<Product> filteredProducts = kProducts;
  int _currentIndex = 0;

  int get cartItemCount => _cart.values.fold(0, (a, b) => a + b);
  double get cartTotal {
    double total = 0;
    for (final entry in _cart.entries) {
      final product = kProducts.firstWhere((p) => p.id == entry.key);
      total += product.price * entry.value;
    }
    return total;
  }

  void addToCart(Product product) {
    setState(() {
      _cart.update(product.id, (q) => q + 1, ifAbsent: () => 1);
    });
  }

  void removeOne(Product product) {
    setState(() {
      if (_cart[product.id]! > 1) {
        _cart[product.id] = _cart[product.id]! - 1;
      } else {
        _cart.remove(product.id);
      }
    });
  }

  void toggleFavorite(Product product) {
    setState(() {
      if (_favorites.contains(product.id)) {
        _favorites.remove(product.id);
      } else {
        _favorites.add(product.id);
      }
    });
  }

  void searchProducts(String query) {
    setState(() {
      filteredProducts = kProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.brand.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      _currentIndex = 0;
    });
  }

  void filterByCategory(String category) {
    setState(() {
      filteredProducts = kProducts
          .where((p) => p.category == category)
          .toList();
      _currentIndex = 0;
    });
  }

  void openPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_currentIndex == 0) {
      body = ProductGrid(
        products: filteredProducts,
        onAdd: addToCart,
        onFavorite: toggleFavorite,
        favorites: _favorites,
      );
    } else if (_currentIndex == 1) {
      body = ProductGrid(
        products: kProducts.where((p) => _favorites.contains(p.id)).toList(),
        onAdd: addToCart,
        onFavorite: toggleFavorite,
        favorites: _favorites,
      );
    } else if (_currentIndex == 2) {
      body = CartPage(
        cart: _cart,
        products: kProducts,
        total: cartTotal,
        onAdd: addToCart,
        onRemoveOne: removeOne,
        onRemoveAll: (p) => setState(() => _cart.remove(p.id)),
        onCheckout: () async {
          final ok = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => CheckoutForm(total: cartTotal)),
          );
          if (ok == true) {
            _cart.clear();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Commande confirmée')));
          }
        },
      );
    } else if (_currentIndex == 3) {
      body = CategoryPage(onFilter: filterByCategory);
    } else {
      body = const ContactPage();
    }

    return Scaffold(
      body: Column(
        children: [
          // HEADER avec logo et recherche
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.pink.shade100,
            child: Row(
              children: [
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: searchProducts,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un parfum...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: openPage,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartItemCount > 0)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartItemCount.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Panier',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Catégories',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

// -------------------- GRID PRODUITS --------------------
class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) onAdd;
  final void Function(Product) onFavorite;
  final Set<String> favorites;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onAdd,
    required this.onFavorite,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 produits par ligne
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 3,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(
                              product: product,
                              onAddToCart: () => onAdd(product),
                              onBuyNow: () {},
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: AspectRatio(
                          aspectRatio: 1, // carré
                          child: Image.asset(
                            product.imageUrl,
                            fit: BoxFit.contain, // visible entièrement
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: Icon(
                          favorites.contains(product.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () => onFavorite(product),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${product.price} €'),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => onAdd(product),
                    child: const Text(
                      'Ajouter',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text(
                      'Commander',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }
}


// -------------------- PAGE CATEGORIES --------------------
class CategoryPage extends StatelessWidget {
  final void Function(String) onFilter;

  const CategoryPage({super.key, required this.onFilter});

  final List<Map<String, dynamic>> mainCategories = const [
    {'name': 'Homme', 'color': Colors.blue},
    {'name': 'Femme', 'color': Colors.pink},
    {'name': 'Unisexe', 'color': Colors.purple},
  ];

  final Map<String, List<Map<String, dynamic>>> subCategories = const {
    'homme': [
      {'name': 'Floral', 'color': Colors.pinkAccent},
      {'name': 'Boisé', 'color': Colors.brown},
      {'name': 'Oriental', 'color': Colors.deepOrange},
      {'name': 'Fruité', 'color': Colors.orange},
    ],
    'femme': [
      {'name': 'Floral', 'color': Colors.pinkAccent},
      {'name': 'Boisé', 'color': Colors.brown},
      {'name': 'Oriental', 'color': Colors.deepOrange},
      {'name': 'Fruité', 'color': Colors.orange},
    ],
    'unisexe': [
      {'name': 'Floral', 'color': Colors.pinkAccent},
      {'name': 'Boisé', 'color': Colors.brown},
      {'name': 'Oriental', 'color': Colors.deepOrange},
      {'name': 'Fruité', 'color': Colors.orange},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cartes par ligne
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 3,
        ),
        itemCount: mainCategories.length,
        itemBuilder: (context, index) {
          final category = mainCategories[index];
          return Card(
            color: category['color'],
            child: InkWell(
              onTap: () {
                // Ouvre la sous-page des sous-catégories
                final subCats = subCategories[category['name'].toString().toLowerCase()]!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubCategoryPage(
                      mainCategory: category['name'],
                      subCategories: subCats,
                      onFilter: onFilter,
                    ),
                  ),
                );
              },
              child: Center(
                child: Text(
                  category['name'],
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubCategoryPage extends StatelessWidget {
  final String mainCategory;
  final List<Map<String, dynamic>> subCategories;
  final void Function(String) onFilter;

  const SubCategoryPage({
    super.key,
    required this.mainCategory,
    required this.subCategories,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$mainCategory - Sous-catégories')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3,
          ),
          itemCount: subCategories.length,
          itemBuilder: (context, index) {
            final sub = subCategories[index];
            return Card(
              color: sub['color'],
              child: InkWell(
                onTap: () => onFilter(sub['name'].toString().toLowerCase()),
                child: Center(
                  child: Text(
                    sub['name'],
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// -------------------- PAGE CONTACT --------------------
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text('Contactez la boutique', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nom complet'),
              validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              onSaved: (v) => name = v!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              onSaved: (v) => email = v!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Message'),
              maxLines: 5,
              validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              onSaved: (v) => message = v!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message envoyé')),
                  );
                }
              },
              child: const Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- DETAIL PRODUIT --------------------
class ProductDetailPage extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(product.imageUrl, height: 300),
            const SizedBox(height: 12),
            Text(product.description),
            const SizedBox(height: 8),
            Text(
              'Notes : ${product.notes.join(', ')}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: onAddToCart,
                  child: const Text('Ajouter'),
                ),
                ElevatedButton(
                  onPressed: onBuyNow,
                  child: const Text('Commander'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- PANIER --------------------
class CartPage extends StatelessWidget {
  final Map<String, int> cart;
  final List<Product> products;
  final double total;
  final void Function(Product) onAdd;
  final void Function(Product) onRemoveOne;
  final void Function(Product) onRemoveAll;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.cart,
    required this.products,
    required this.total,
    required this.onAdd,
    required this.onRemoveOne,
    required this.onRemoveAll,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panier')),
      body: cart.isEmpty
          ? const Center(child: Text('Votre panier est vide'))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: cart.entries.map((e) {
                      final product = products.firstWhere((p) => p.id == e.key);
                      return ListTile(
                        leading: Image.asset(product.imageUrl, width: 50),
                        title: Text(product.name),
                        subtitle: Text('${product.price} € x ${e.value}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => onRemoveOne(product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => onAdd(product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => onRemoveAll(product),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Total : ${total.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: onCheckout,
                        child: const Text('Passer à la caisse'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// -------------------- FORMULAIRE CHECKOUT --------------------
class CheckoutForm extends StatefulWidget {
  final double total;

  const CheckoutForm({super.key, required this.total});

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String address = '';
  String payment = 'Carte';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Total : ${widget.total.toStringAsFixed(2)} €',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom complet'),
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
                onSaved: (v) => name = v!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Adresse'),
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
                onSaved: (v) => address = v!,
              ),
              DropdownButtonFormField(
                value: payment,
                decoration: const InputDecoration(labelText: 'Paiement'),
                items: const [
                  DropdownMenuItem(
                    value: 'Carte',
                    child: Text('Carte bancaire'),
                  ),
                  DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
                  DropdownMenuItem(
                    value: 'Cash',
                    child: Text('À la livraison'),
                  ),
                ],
                onChanged: (v) => setState(() => payment = v!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Confirmer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
