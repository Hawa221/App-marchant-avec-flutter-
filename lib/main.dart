import 'package:flutter/material.dart';

void main() => runApp(const PerfumeApp());

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> notes;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.notes,
  });
}

final List<Product> kProducts = [
  const Product(
    id: 'p1',
    name: 'Chanel N°5',
    brand: 'Chanel',
    price: 120,
    imageUrl: 'assets/chanel5.jpg',
    description: 'Icône intemporelle. Bouquet floral aldéhydé élégant et raffiné.',
    notes: ['Aldéhydes', 'Jasmin', 'Rose', 'Ylang-ylang'],
  ),
  const Product(
    id: 'p2',
    name: 'Dior Sauvage',
    brand: 'Dior',
    price: 95,
    imageUrl: 'assets/sauvagedior.jpg',
    description: 'Fraîcheur brute et noble. Bergamote vive et ambroxan puissant.',
    notes: ['Bergamote', 'Ambroxan', 'Poivre', 'Lavande'],
  ),
  const Product(
    id: 'p3',
    name: 'YSL Libre',
    brand: 'Yves Saint Laurent',
    price: 110,
    imageUrl: 'assets/ysllibre.webp',
    description: 'Contraste audacieux entre lavande et fleur d’oranger.',
    notes: ['Lavande', 'Fleur d’oranger', 'Vanille', 'Mandarine'],
  ),
  const Product(
    id: 'p4',
    name: 'Bleu de Chanel',
    brand: 'Chanel',
    price: 115,
    imageUrl: 'assets/bleuchanel.jpg',
    description: 'Boisé aromatique. Élégance et force tranquille.',
    notes: ['Agrumes', 'Bois de cèdre', 'Santal', 'Encens'],
  ),
  const Product(
    id: 'p5',
    name: 'La Vie Est Belle',
    brand: 'Lancôme',
    price: 105,
    imageUrl: 'assets/lancome.webp',
    description: 'Un parfum lumineux et joyeux, symbole du bonheur.',
    notes: ['Iris', 'Patchouli', 'Vanille', 'Fleurs blanches'],
  ),
  const Product(
    id: 'p6',
    name: 'Black Opium',
    brand: 'Yves Saint Laurent',
    price: 99,
    imageUrl: 'assets/blackopium.webp',
    description: 'Un parfum gourmand et addictif, café intense et vanille sensuelle.',
    notes: ['Café', 'Vanille', 'Fleur d’oranger', 'Cèdre'],
  ),
  const Product(
    id: 'p7',
    name: 'Light Blue',
    brand: 'Dolce & Gabbana',
    price: 89,
    imageUrl: 'assets/lightblue.webp',
    description: 'Fraîcheur méditerranéenne, citron sicilien et pomme verte pétillante.',
    notes: ['Citron', 'Pomme verte', 'Cèdre', 'Musc'],
  ),
  const Product(
    id: 'p8',
    name: 'Flowerbomb',
    brand: 'Viktor & Rolf',
    price: 115,
    imageUrl: 'assets/flowerbomb.webp',
    description: 'Explosion florale, un bouquet opulent et sensuel.',
    notes: ['Jasmin', 'Rose', 'Orchidée', 'Patchouli'],
  ),
];

class PerfumeApp extends StatelessWidget {
  const PerfumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boutique de Parfums',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final Map<String, int> _cart = {};

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

  void clearCart() => setState(() => _cart.clear());

  @override
  Widget build(BuildContext context) {
    return HomePage(
      cartItemCount: cartItemCount,
      onOpenCart: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CartPage(
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
                  clearCart();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Commande confirmée')));
                }
              },
            ),
          ),
        );
      },
      onOpenDetails: (product) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(
              product: product,
              onAddToCart: () => addToCart(product),
              onBuyNow: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CheckoutForm(total: product.price)),
              ),
            ),
          ),
        );
      },
      onAddQuick: addToCart,
    );
  }
}

class HomePage extends StatelessWidget {
  final int cartItemCount;
  final VoidCallback onOpenCart;
  final void Function(Product) onOpenDetails;
  final void Function(Product) onAddQuick;

  const HomePage({
    super.key,
    required this.cartItemCount,
    required this.onOpenCart,
    required this.onOpenDetails,
    required this.onAddQuick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique de Parfums'),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: onOpenCart),
          if (cartItemCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text('$cartItemCount',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: kProducts.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = kProducts[index];
              return Card(
                elevation: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onOpenDetails(product),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(product.imageUrl, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    Text(product.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${product.price} €'),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => onAddQuick(product),
                          child: const Text('Ajouter', style: TextStyle(fontSize: 12)),
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutForm(total: product.price),
                            ),
                          ),
                          child: const Text('Commander', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

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
            Text('Notes : ${product.notes.join(', ')}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: onAddToCart, child: const Text('Ajouter')),
                ElevatedButton(onPressed: onBuyNow, child: const Text('Commander')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
                            IconButton(icon: const Icon(Icons.remove), onPressed: () => onRemoveOne(product)),
                            IconButton(icon: const Icon(Icons.add), onPressed: () => onAdd(product)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => onRemoveAll(product)),
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
                      Text('Total : ${total.toStringAsFixed(2)} €',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ElevatedButton(onPressed: onCheckout, child: const Text('Passer à la caisse')),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

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
              Text('Total : ${widget.total.toStringAsFixed(2)} €',
                  style: const TextStyle(fontSize: 18)),
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
                  DropdownMenuItem(value: 'Carte', child: Text('Carte bancaire')),
                  DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
                  DropdownMenuItem(value: 'Cash', child: Text('À la livraison')),
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
