import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/models/Departments.dart';

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
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 3.0),
                          child: Card(
                            color: theme.primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 15.0),
                              child: Column(children: [
                                Text(
                                  depts[index].slug.toUpperCase(),
                                  style: theme.textTheme.headline5
                                      ?.copyWith(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  depts[index].name,
                                  style: theme.textTheme.headline6
                                      ?.copyWith(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                            ),
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
