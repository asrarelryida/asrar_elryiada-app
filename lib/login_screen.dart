import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

// تخزين بيانات المشرفين (لكل أدمن: الباسورد، التخصصات، وحالة التفعيل)
class AdminStorage {
  static final Map<String, Map<String, dynamic>> accounts = {};
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String _selectedAccount = 'Admin';
  
  final List<String> _accounts = [
    'Admin',
    'Admin 1',
    'Admin 2',
    'Admin 3',
    'Admin 4',
    'Admin 5',
    'Admin 6',
    'Admin 7',
    'Admin 8',
    'Admin 9',
    'Admin 10',
  ];

  // تخصصات المشرفين مع إضافة قسم المحترفون الجديد
  final List<String> _allSpecialties = [
    'الأخبار المحلية',
    'الأخبار العالمية',
    'المحترفون',
    'المباريات والنتائج',
    'المقالات والتحليلات',
    'فريق الدوري',
    'دوريات أخرى'
  ];
  final List<String> _selectedSpecialties = [];

  void _handleLogin() {
    String password = _passwordController.text.trim();

    if (_selectedAccount == 'Admin') {
      if (password == '125587') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen(isAdminMaster: true)),
        );
      } else {
        _showError('كلمة المرور للأدمن الرئيسي غير صحيحة');
      }
    } else {
      if (password.isEmpty) {
        _showError('يرجى إدخال كلمة المرور');
        return;
      }

      // إذا كان الحساب غير مسجل مسبقاً، نسجله بالبيانات الجديدة
      if (!AdminStorage.accounts.containsKey(_selectedAccount)) {
        if (_selectedSpecialties.isEmpty) {
          _showError('يرجى اختيار تخصص واحد على الأقل');
          return;
        }
        AdminStorage.accounts[_selectedAccount] = {
          'password': password,
          'specialties': List.from(_selectedSpecialties),
          'approved': false,
          'fullAccess': false,
        };
        _showMsg('تم إرسال طلب تفعيل الحساب للأدمن الرئيسي بنجاح!', Colors.green);
        return;
      }

      var account = AdminStorage.accounts[_selectedAccount]!;
      if (account['password'] == password) {
        if (account['approved'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen(isAdminMaster: false, adminName: _selectedAccount)),
          );
        } else {
          _showMsg('حسابك بانتظار موافقة الأدمن الرئيسي (Master)', Colors.orange);
        }
      } else {
        _showError('كلمة المرور غير صحيحة');
      }
    }
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  void _showError(String msg) {
    _showMsg(msg, Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings, size: 64, color: Color(0xFFB71C1C)),
                const SizedBox(height: 16),
                const Text(
                  'تسجيل دخول لوحة التحكم',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                ),
                const SizedBox(height: 8),
                const Text('أسرار الرياضة - بوابة الإدارة', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 24),

                // اختيار الحساب من القائمة المنسدلة
                const Align(alignment: Alignment.centerRight, child: Text('اختر الحساب', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedAccount,
                      isExpanded: true,
                      items: _accounts.map((String account) {
                        return DropdownMenuItem<String>(
                          value: account,
                          child: Text(account),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedAccount = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // حقل كلمة المرور
                const Align(alignment: Alignment.centerRight, child: Text('كلمة المرور الخاصة بك', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFFB71C1C)),
                    hintText: 'اكتب كلمة المرور',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),

                // اختيار التخصصات لو المشرف بيسجل لأول مرة
                if (_selectedAccount != 'Admin') ...[
                  const SizedBox(height: 16),
                  const Align(alignment: Alignment.centerRight, child: Text('اختر تخصصاتك المطلوبة:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)))),
                  const SizedBox(height: 8),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: ListView.builder(
                      itemCount: _allSpecialties.length,
                      itemBuilder: (context, index) {
                        String specialty = _allSpecialties[index];
                        bool isSelected = _selectedSpecialties.contains(specialty);
                        return CheckboxListTile(
                          title: Text(specialty, style: const TextStyle(fontSize: 12)),
                          value: isSelected,
                          activeColor: const Color(0xFFB71C1C),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedSpecialties.add(specialty);
                              } else {
                                _selectedSpecialties.remove(specialty);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // زر الدخول / إرسال الطلب
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _handleLogin,
                    child: const Text('تسجيل الدخول / إرسال الطلب', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}