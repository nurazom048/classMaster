import 'package:flutter/material.dart';

class DataTAble extends StatefulWidget {
  DataTAble({super.key});

  @override
  State<DataTAble> createState() => _DataTAbleState();
}

class _DataTAbleState extends State<DataTAble> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold with appbar ans body.
      appBar: AppBar(
        title: const Text('Simple Data Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            // Datatable widget that have the property columns and rows.
            columns: const [
              // Set the name of the column
              DataColumn(
                label: Text('ID'),
              ),
              DataColumn(
                label: Text('Name'),
              ),
              DataColumn(
                label: Text('LastName'),
              ),
              DataColumn(
                label: Text('Age'),
              ),
            ], rows: const [
          // Set the values to the columns

          DataRow(cells: [
            DataCell(Text("2")),
            DataCell(Text("John")),
            DataCell(Text("Anderson")),
            DataCell(Text("24")),
          ]),
        ]),
      ),
    );
  }
}
