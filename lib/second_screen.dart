import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'order_model.dart';
class SecondScreen extends StatefulWidget {
  final inputbox? existingInput;
  final int? index;
  SecondScreen({this.existingInput, this.index});
  @override
  _SecondScreenState createState() => _SecondScreenState();
}
class _SecondScreenState extends State<SecondScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _longDescController = TextEditingController();
  final _dateController = TextEditingController();
  String _statusValue = 'In Progress';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    if (widget.existingInput != null) {
      _titleController.text = widget.existingInput!.title;
      _shortDescController.text = widget.existingInput!.shortdescription;
      _longDescController.text = widget.existingInput!.longdescription;
      _dateController.text = widget.existingInput!.Date;
      _statusValue = widget.existingInput!.status;
      if (widget.existingInput!.imagePath != null) {
        _selectedImage = File(widget.existingInput!.imagePath!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _shortDescController.dispose();
    _longDescController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? icon,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          widget.existingInput == null ? "Add Research Item" : "Edit Research Item",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (widget.existingInput != null)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Item'),
                    content: Text('Are you sure you want to delete this item?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  Navigator.pop(context, {
                    'delete': true,
                    'index': widget.index ?? -1,
                  });
                }
              },
            ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField(
                label: "Title",
                controller: _titleController,
                icon: Icons.title,
              ),
              _buildInputField(
                label: "Short Description",
                controller: _shortDescController,
                icon: Icons.short_text,
                maxLines: 2,
              ),
              _buildInputField(
                label: "Long Description",
                controller: _longDescController,
                icon: Icons.description,
                maxLines: 4,
              ),
              _buildInputField(
                label: "Date",
                controller: _dateController,
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _dateController.text =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
                },
                icon: Icons.calendar_today,
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonFormField<String>(
                  value: _statusValue,
                  decoration: InputDecoration(
                    labelText: "Status",
                    prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: ['In Progress', 'Completed', 'Pending']
                      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),

                  onChanged: (value) {
                    setState(() {
                      _statusValue = value!;
                    });
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Image", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      _selectedImage != null
                          ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _selectedImage = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                          : Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: Text("No image selected")),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.image),
                          label: Text("Browse Image"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newInput = inputbox(
                      title: _titleController.text.trim(),
                      shortdescription: _shortDescController.text.trim(),
                      longdescription: _longDescController.text.trim(),
                      Date: _dateController.text.trim(),
                      status: _statusValue,
                      imagePath: _selectedImage?.path,
                    );
                    Navigator.pop(context, {
                      'inputbox': newInput,
                      'index': widget.index ?? -1,
                    });
                  }
                },
                icon: Icon(widget.existingInput == null ? Icons.save : Icons.update),
                label: Text(widget.existingInput == null ? "Save" : "Update"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
