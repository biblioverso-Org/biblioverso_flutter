import 'package:biblioverso_flutter/viewmodel/reservations_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/libro_viewmodel.dart';
import '../../../viewmodel/favorites_viewmodel.dart';
import '../../../viewmodel/opinion_viewmodel.dart';
import '../../../viewmodel/profile_viewmodel.dart';

class BookDetailScreen extends StatefulWidget {
  final int idLibro;

  const BookDetailScreen({super.key, required this.idLibro});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LibroViewModel>(context, listen: false)
          .fetchLibroDetalle(widget.idLibro);

      // Cargar reseñas
      Provider.of<OpinionViewModel>(context, listen: false)
          .fetchOpiniones(widget.idLibro);
    });
  }

  @override
  Widget build(BuildContext context) {
    final libroVM = Provider.of<LibroViewModel>(context);
    final opinionVM = Provider.of<OpinionViewModel>(context);
    final reservaVM = Provider.of<ReservationsViewModel>(context, listen: false);
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);

    final userId = profileVM.idUsuario ?? 1;

    if (libroVM.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (libroVM.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detalles del Libro")),
        body: Center(child: Text(libroVM.errorMessage!)),
      );
    }

    final book = libroVM.libroDetalle;
    if (book == null) {
      return const Scaffold(
        body: Center(child: Text("Libro no encontrado")),
      );
    }

    final hasStock = book.disponibles > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Libro"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<FavoritesViewModel>(
            builder: (context, favVM, _) {
              final isFav =
              favVM.favoritos.any((f) => f["idLibro"] == book.idLibro);
              return IconButton(
                onPressed: () async {
                  if (isFav) {
                    await favVM.removeFavorito(userId, book.idLibro);
                  } else {
                    await favVM.addFavorito(userId, book.idLibro);
                  }
                },
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📘 Portada
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: book.portada != null
                    ? Image.network(book.portada!, height: 180)
                    : Container(
                  height: 180,
                  width: 120,
                  color: Colors.deepPurple.shade50,
                  child: const Icon(Icons.menu_book,
                      size: 60, color: Colors.deepPurple),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 📖 Título y autor
            Text(book.titulo,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(book.autores ?? "Autor desconocido",
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),

            // ⭐ Rating + año + editorial
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber.shade700, size: 18),
                const SizedBox(width: 4),
                Text("${book.rating ?? 0} (${book.reviews ?? 0} reseñas)"),
              ],
            ),
            const SizedBox(height: 6),
            _InfoRow(
                icon: Icons.date_range,
                text: "${book.fechaPublicacion?.year ?? "N/A"}"),
            _InfoRow(
                icon: Icons.business,
                text: book.editorial ?? "Editorial desconocida"),
            const SizedBox(height: 12),

            // 📦 Disponibilidad
            Text(
              "${book.disponibles} disponibles",
              style: TextStyle(
                color: hasStock ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // 📚 Descripción
            const Text("Descripción",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              book.sinopsis ?? "Sin descripción disponible para este libro.",
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // 📑 Detalles
            const Text("Detalles del libro",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            _DetailRow(label: "ISBN", value: book.isbn ?? "N/A"),
            _DetailRow(label: "Categoría", value: book.categoria ?? "General"),
            _DetailRow(
                label: "Editorial", value: book.editorial ?? "Editorial"),
            const SizedBox(height: 20),

            // 💬 Reseñas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Reseñas",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () => _showReviewDialog(
                      context, opinionVM, userId, book.idLibro),
                  child: const Text("Escribir reseña"),
                ),
              ],
            ),
            if (opinionVM.isLoading)
              const CircularProgressIndicator()
            else if (opinionVM.opiniones.isEmpty)
              const Text("Aún no hay reseñas para este libro")
            else
              Column(
                children: opinionVM.opiniones
                    .map((op) => ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(op["usuario"] ?? "Anon"),
                  subtitle: Text(op["comentario"] ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                          (i) => Icon(
                        i < (op["calificacion"] ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ))
                    .toList(),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      // 🦶 Footer de reservas
      bottomNavigationBar: _ReservationFooter(
        quantity: quantity,
        disponibles: book.disponibles,
        onQuantityChanged: (newQty) {
          // Evita que se seleccione más que el stock
          if (newQty > book.disponibles) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Solo hay ${book.disponibles} copias disponibles de ${book.titulo}"),
              ),
            );
            return;
          }
          setState(() => quantity = newQty);
        },
        onReserve: () async {
          try {
            if (book.disponibles > 0) {
              await reservaVM.reservarLibro(userId, book.idLibro, quantity);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        "Reserva realizada (${quantity} copias de ${book.titulo})")),
              );
            } else {
              await reservaVM.unirseListaEspera(userId, book.idLibro);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Te uniste a la lista de espera")),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Error al reservar: ${e.toString()}")),
            );
          }
        },
      ),
    );
  }

  // ---------------------- Diálogo de Reseña ----------------------
  void _showReviewDialog(
      BuildContext context, OpinionViewModel vm, int userId, int idLibro) {
    final TextEditingController controller = TextEditingController();
    int rating = 0;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Escribir Reseña"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                          (index) => IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                      ),
                    ),
                  ),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Escribe tu reseña...",
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                await vm.agregarOpinion(
                    userId, idLibro, rating, controller.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Reseña publicada con éxito")));
              },
              child: const Text("Publicar"),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------- Widgets auxiliares ----------------------

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black54))),
          Text(value,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

class _ReservationFooter extends StatelessWidget {
  final int quantity;
  final int disponibles;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onReserve;

  const _ReservationFooter({
    required this.quantity,
    required this.disponibles,
    required this.onQuantityChanged,
    required this.onReserve,
  });

  @override
  Widget build(BuildContext context) {
    final hasStock = disponibles > 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4),
      ]),
      child: Row(
        children: [
          // Selector cantidad (solo si hay stock)
          if (hasStock)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed:
                    quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
                  ),
                  Text(quantity.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () => onQuantityChanged(quantity + 1),
                  ),
                ],
              ),
            ),
          if (hasStock) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onReserve,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasStock ? Colors.green : Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                hasStock ? "Reservar" : "Unirme a lista de espera",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
