import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/response/status.dart';
import 'package:shopping_list/screen/new_item.dart';
import 'package:shopping_list/view_model/delete_view_model.dart';

import '../model/grocery_item.dart';
import '../view_model/get_view_model.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  void initState() {
    super.initState();
    Provider.of<GetViewModel>(context, listen: false).getGroceryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const NewItem()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<GetViewModel>(context, listen: false)
              .getGroceryList();
        },
        child: Consumer<GetViewModel>(
          builder: (context, value, child) {
            switch (value.groceryList.status) {
              case Status.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case Status.error:
                return Center(
                  child: Text(value.groceryList.message.toString()),
                );
              case Status.complete:
                final List<GroceryItem> loadedItems = [];
                for (final item in value.groceryList.data!.entries) {
                  final category = categories.entries
                      .firstWhere((element) =>
                          element.value.title == item.value["category"])
                      .value;
                  loadedItems.add(GroceryItem(
                      id: item.key,
                      name: item.value["name"],
                      quantity: item.value["quantity"],
                      category: category));
                }
                return loadedItems.isEmpty
                    ? const Center(
                        child: Text('No items added yet.'),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ValueKey(loadedItems[index].id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              Provider.of<DeleteViewModel>(context,
                                      listen: false)
                                  .deleteGrocery(loadedItems[index]);
                              await value.getGroceryList();
                            },
                            child: ListTile(
                              title: Text(loadedItems[index].name),
                              leading: Container(
                                width: 24,
                                height: 24,
                                color: loadedItems[index].category.color,
                              ),
                              trailing: Text(
                                loadedItems[index].quantity.toString(),
                              ),
                            ),
                          );
                        },
                        itemCount: loadedItems.length,
                      );

              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
