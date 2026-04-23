import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../pages/exam_page.dart';

class TokenBottomSheet extends StatefulWidget {
  final String examTitle;
  const TokenBottomSheet({super.key, required this.examTitle});

  @override
  State<TokenBottomSheet> createState() => _TokenBottomSheetState();
}

class _TokenBottomSheetState extends State<TokenBottomSheet> {
  final TextEditingController _tokenController = TextEditingController();
  int _currentLength = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 25),
          const Text("Masukkan Token Ujian", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(widget.examTitle, style: const TextStyle(color: Colors.green)),
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0,
                child: TextField(
                  controller: _tokenController,
                  autofocus: true,
                  maxLength: 6,
                  inputFormatters: [UpperCaseTextFormatter()],
                  onChanged: (v) => setState(() => _currentLength = v.length),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  bool isFilled = index < _currentLength;
                  return Container(
                    width: 45, height: 55,
                    decoration: BoxDecoration(
                      color: isFilled ? Colors.green.shade50 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: index == _currentLength ? Colors.green : (isFilled ? Colors.green : Colors.grey.shade300), width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(isFilled ? _tokenController.text[index] : "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _currentLength == 6 ? Colors.green : Colors.grey.shade400, foregroundColor: Colors.white),
              onPressed: _currentLength == 6 ? () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamPage()));
              } : null,
              child: const Text("MULAI UJIAN SEKARANG"),
            ),
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) =>
      TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection);
}