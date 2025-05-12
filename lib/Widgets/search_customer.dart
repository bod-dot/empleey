import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Views/Pages/Widgets/data_table_report.dart';
import '../cubit/home_cubit/home_cubit.dart';
import '../helper/constans.dart';

class SearchCustomer extends SearchDelegate<String?> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: kColorFoured),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: kColorPrimer,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  TextStyle? get searchFieldStyle => const TextStyle(color: Colors.white);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      InkWell(
        onTap: () => query = '',
        child: const Icon(Icons.clear, color: Colors.white),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // عرض الاقتراحات أثناء الكتابة باستخدام contains
    final customers = BlocProvider.of<HomeCubit>(context).customers;
    final suggestions = query.isEmpty
        ? customers
        : customers
            .where((c) => c.customerName.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return Container(
      color: kColorFoured.withOpacity(0.3),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: suggestions.length,
        itemBuilder: (context, i) {
          final customer = suggestions[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // تحديث query إلى النص المطبوع في الاقتراح
                query = customer.customerName;
                // عرض النتائج بناءً على القيمة الجديدة
                showResults(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: kColorPrimer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        customer.customerName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kColorSecond,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // جلب كامل القائمة من الـ Bloc
    final allCustomers = BlocProvider.of<HomeCubit>(context).customers;

    // إذا وُجد تطابق تام للاسم مع query نُظهر النتائج المطابقة بدقة
    final exactMatches = allCustomers
        .where((c) => c.customerName == query)
        .toList();

    // وإلا نُظهر جميع العملاء الذين يحتوي اسمهم على query
    final matches = exactMatches.isNotEmpty
        ? exactMatches
        : allCustomers
            .where((c) => c.customerName.contains(query))
            .toList();

    return DataTableReport(customer: matches);
  }
}

