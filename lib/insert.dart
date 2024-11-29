import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crud_perpustakaan/home_page.dart';

// Widget untuk halaman menambah buku
class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey untuk validasi form

  // Controller untuk masing-masing input form
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false; // To manage the loading state

  // Fungsi untuk menambah buku ke database Supabase
  Future<void> _addBook() async {
    if (_formKey.currentState!.validate()) { // Memastikan form sudah valid sebelum data dikirim
      final title = _titleController.text; // Mendapatkan judul buku
      final author = _authorController.text; // Mendapatkan penulis buku
      final description = _descriptionController.text; // Mendapatkan deskripsi buku

      setState(() {
        _isLoading = true; // Set loading state to true while processing the request
      });

      try {
        final response = await Supabase.instance.client // Mengirim data ke Supabase dengan kolom yang sesuai dengan nama tabel 'buku'
            .from('books') // Nama tabel di Supabase
            .insert({
              'judul': title, // Nama kolom sesuai dengan tabel di Supabase
              'penulis': author, // Nama kolom sesuai dengan tabel di Supabase
              'deskripsi': description,
            }).select(); // Memastikan data dikirim

        ScaffoldMessenger.of(context).showSnackBar( // Jika berhasil, tampilkan pesan sukses
          const SnackBar(content: Text('Buku berhasil ditambahkan')),
        );

        // Kosongkan input field setelah data berhasil dikirim
        _titleController.clear();
        _authorController.clear();
        _descriptionController.clear();

        Navigator.pushReplacement( // Navigasi kembali ke halaman utama (HomePage)
          context,
          MaterialPageRoute(builder: (context) => const BookListPage()), // Navigasi ke halaman daftar buku
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar( // Jika terjadi error, tampilkan pesan error
          SnackBar(
            content: Text('Error occurred: $e'), // Menampilkan error jika terjadi masalah
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Set loading state to false when the request is complete
        });
      }}
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'), // Judul halaman
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding di sekitar form
        child: Form(
          key: _formKey, // GlobalKey untuk form validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Menjaga lebar form full
            children: [
              TextFormField( // Input field untuk judul buku
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'), // Label untuk input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Book title cannot be blank'; // Validasi jika judul kosong
                  }
                  return null;
                }),
              TextFormField( // Input field untuk penulis buku
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'), // Label untuk input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The author of the book must not be empty'; // Validasi jika penulis kosong
                  }
                  return null;
                }),
              TextFormField( // Input field untuk deskripsi buku
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'), // Label untuk input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Book description must not be empty'; // Validasi jika deskripsi kosong
                  }
                  return null;
                }),
              const SizedBox(height: 20), // Jarak antara input dan tombol
              ElevatedButton( // Tombol untuk menyimpan buku
                onPressed: _isLoading ? null : _addBook, // Disable button when loading
                child: _isLoading // Show loading indicator if loading is true
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Tambah Data'),
              )],
          )),
      ));
    }}
