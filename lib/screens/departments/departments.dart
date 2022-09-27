import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/models/Departments.dart';
import 'package:plandroid/routes/routeconst.dart';

class Departments extends StatefulWidget {
  const Departments({Key? key}) : super(key: key);

  @override
  State<Departments> createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  List<Department> depts = List<Department>.empty(growable: true);
  bool _isLoading = false;

  Future<void> getDepartments() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await Api().dio.get('/departments');

      if (response.data != null) {
        DepartmentData deptData = DepartmentData.fromJson(response.data);

        setState(() {
          depts.clear();
          depts.addAll(deptData.data);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = false;
      depts.clear();
      getDepartments();
    });
  }

  @override
  void initState() {
    getDepartments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        opacity: 0.5,
        child: RefreshIndicator(
          onRefresh: () {
            return _refresh();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  height: 40.0,
                  child: Center(
                      child: Text(
                    'Departments',
                    style: theme.textTheme.headline5,
                  )),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: depts.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (kDebugMode) {
                            print(depts[index].slug);
                          }

                          Get.toNamed(
                            "$levelTermsPage/${depts[index].slug.toString()}",
                          );
                        },
                        child: Container(
                          color: theme.cardColor,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(7.0)),
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Center(
                                child: Text(
                                  depts[index].slug.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            title: Text(depts[index].name),
                            subtitle: Text(
                                "Accessible to: ${depts[index].canBeAccessedBy.toUpperCase()}"),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
