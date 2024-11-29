// Import library utama Flutter untuk membuat UI.
import 'package:crud_perpustakaan/insert.dart'; // Mengimport halaman untuk menambah buku.
import 'package:flutter/material.dart'; // Mengimport library Flutter untuk widget UI.

// Import library Supabase untuk mengintegrasikan backend menggunakan Supabase.
import 'package:supabase_flutter/supabase_flutter.dart'; // Mengimport library Supabase untuk menghubungkan dengan database.

// Membuat kelas BookListPage yang merupakan StatefulWidget,
class BookListPage extends StatefulWidget { // digunakan untuk menampilkan daftar buku.
  const BookListPage({super.key}); // Konstruktor dengan kunci untuk widget ini.

  @override
  _BookListPageState createState() => _BookListPageState(); // Membuat state untuk widget ini.
}

class _BookListPageState extends State<BookListPage> { // Kelas state untuk BookListPage yang berisi logika dan data.
  List<Map<String, dynamic>> books = []; // Buat variabel untuk menyimpan daftar buku

  // Method ini dipanggil ketika widget pertama kali dibuat.
  @override
  void initState() {
    super.initState(); // Memanggil implementasi initState bawaan StatefulWidget.
    fetchBooks(); // Panggil fungsi untuk mengambil data buku dari Supabase.
  }

  // Fungsi untuk mengambil data buku dari Supabase
  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client
        .from('books') // Mengambil data dari tabel 'buku'.
        .select(); // Query untuk mengambil semua data.

    setState(() {
      books = List<Map<String, dynamic>>.from(response); // Menyimpan hasil query ke dalam list buku.
    });
  }

  // Method untuk membangun UI tampilan.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'), // Menampilkan judul aplikasi di app bar.
        actions: [
          IconButton( // Tombol untuk me-refresh data buku.
            icon: const Icon(Icons.refresh), // Ikon refresh.
            onPressed: fetchBooks, // Tombol untuk refresh, memanggil fetchBooks.
          ),
        ]),
      body: books.isEmpty // Menampilkan data buku jika ada, jika kosong akan menampilkan loading.
          ? const Center(child: CircularProgressIndicator()) // Menampilkan indikator loading saat data belum ada.
          : ListView.builder( // Menggunakan ListView.builder untuk menampilkan daftar buku.
              itemCount: books.length, // Menentukan jumlah item berdasarkan panjang data buku.
              itemBuilder: (context, index) {
                final book = books[index]; // Mengambil data buku berdasarkan index.
                return ListTile(
                  title: Text(
                    book['title'] ?? 'No Title', // Menampilkan judul buku atau 'No Title' jika kosong.
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Menyusun elemen subtitle secara vertikal.
                    children: [
                      Text(
                        book['author'] ?? 'No Author', // Menampilkan penulis atau 'No Author' jika kosong.
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14.0,
                        )),
                      Text(
                        book['description'] ?? 'No Description', // Menampilkan deskripsi atau 'No Description' jika kosong.
                        style: TextStyle(
                          fontSize: 12.0,
                        )),
                    ]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // Menyusun tombol edit dan delete secara horizontal.
                    children: [
                      IconButton( // Tombol untuk mengedit buku.
                        icon: const Icon(Icons.edit, color: Colors.blue), // Ikon edit.
                        onPressed: () {
                          // Arahkan ke halaman EditBooks untuk mengedit buku (dalam kode ini tombol belum berfungsi).
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EditBookPage(book: book),
                          //   ),
                          // ).then((_) {
                          //   fetchBooks(); // Refresh data setelah kembali dari halaman edit.
                          // });
                        }),
                      IconButton( // Tombol untuk menghapus buku.
                        icon: const Icon(Icons.delete, color: Colors.red), // Ikon delete.
                        onPressed: () {
                          showDialog( // Menampilkan dialog konfirmasi untuk menghapus buku.
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Book'), // Judul dialog.
                                content: const Text('Are you sure you want to delete this book?'), // Pesan konfirmasi penghapusan.
                                actions: [
                                  TextButton( // Tombol untuk membatalkan penghapusan.
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Menutup dialog jika tombol 'Cancel' ditekan.
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton( // Tombol untuk mengonfirmasi penghapusan.
                                    onPressed: () async {
                                      // Fungsi penghapusan buku (belum diimplementasikan).
                                      // await deletedBook(book['id']);
                                      Navigator.of(context).pop(); // Menutup dialog setelah penghapusan.
                                    },
                                    child: const Text('Delete'),
                              )]);
                            });
                          },
                        )],
                      ));
                    }),
      floatingActionButton: FloatingActionButton( // FloatingActionButton untuk menambahkan buku baru.
        onPressed: () {
          Navigator.push( // Navigasi ke halaman AddBookPage untuk menambah buku baru.
            context,
            MaterialPageRoute(
              builder: (context) => AddBookPage(),
            ));
          },
        child: const Icon(Icons.add), // Ikon untuk menambah buku.
        tooltip: 'Add Book', // Tooltip untuk tombol tambah buku.
     ));
 }}