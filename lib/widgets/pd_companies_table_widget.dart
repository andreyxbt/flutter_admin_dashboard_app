import 'package:flutter/material.dart';
import '../entities/pd_company.dart';
import 'package:data_table_2/data_table_2.dart';

class PDCompaniesTableWidget extends StatelessWidget {
  final List<PDCompany> pdCompanies;
  final Function(String) onDelete;
  final Function(PDCompany) onEdit;

  const PDCompaniesTableWidget({
    super.key,
    required this.pdCompanies,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columns: const [
        DataColumn2(label: Text('Name'), size: ColumnSize.L),
        DataColumn2(label: Text('Description'), size: ColumnSize.L),
        DataColumn2(label: Text('Users'), size: ColumnSize.S),
        DataColumn2(label: Text('Courses'), size: ColumnSize.S),
        DataColumn2(label: Text('Reports'), size: ColumnSize.S),
        DataColumn2(label: Text('Last Updated'), size: ColumnSize.M),
        DataColumn2(label: Text('Actions'), size: ColumnSize.S),
      ],
      rows: pdCompanies.map((company) {
        return DataRow(
          cells: [
            DataCell(Text(company.name)),
            DataCell(Text(company.description)),
            DataCell(Text(company.users)),
            DataCell(Text(company.courses)),
            DataCell(Text(company.reports)),
            DataCell(Text(company.lastUpdated)),
            DataCell(Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onEdit(company),
                  color: Colors.blue,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete(company.id),
                  color: Colors.red,
                ),
              ],
            )),
          ],
        );
      }).toList(),
    );
  }
}