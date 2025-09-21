import 'package:flutter/material.dart';

class CustomeField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;
  final List<String>? suggestions;
  final VoidCallback? onTap;
  final bool showDropDownIcon; // New parameter

  const CustomeField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.readOnly = false,
    this.onTap,
    this.suggestions,
    this.showDropDownIcon = false, // Default is false
  });

  @override
  _CustomeFieldState createState() => _CustomeFieldState();
}

class _CustomeFieldState extends State<CustomeField> {
  List<String> filteredSuggestions = [];
  bool showAllSuggestions = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_filterSuggestions);
  }

  void _filterSuggestions() {
    final input = widget.controller?.text.toLowerCase() ?? '';
    if (input.isNotEmpty && widget.suggestions != null) {
      setState(() {
        filteredSuggestions = widget.suggestions!
            .where((suggestion) => suggestion.toLowerCase().contains(input))
            .toList();
        showAllSuggestions = false;
      });
    } else if (input.isEmpty && !showAllSuggestions) {
      setState(() {
        filteredSuggestions = [];
      });
    }
  }

  void _showAllSuggestions() {
    setState(() {
      filteredSuggestions = widget.suggestions ?? [];
      showAllSuggestions = true;
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_filterSuggestions);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(),
            suffixIcon: widget.showDropDownIcon
                ? IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: _showAllSuggestions,
                  )
                : null, // Show icon only if showDropDownIcon is true

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(30, 215, 96, 1)), // Color when focused
            ),
          ),
          validator: (val) {
            if (val!.trim().isEmpty) {
              return "${widget.hintText} is missing";
            }
            if (widget.suggestions != null &&
                !widget.suggestions!.contains(val.trim())) {
              return "Please select  given list";
            }
            return null;
          },
          obscureText: widget.isObscureText,
        ),
        if (filteredSuggestions.isNotEmpty)
          Container(
            height: 150, // Adjust the height as needed
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
            ),
            child: ListView.builder(
              itemCount: filteredSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredSuggestions[index]),
                  onTap: () {
                    widget.controller?.text = filteredSuggestions[index];
                    setState(() {
                      filteredSuggestions = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';

// class CustomeField extends StatelessWidget {
//   final String hintText;
//   final TextEditingController? controller;
//   final bool isObscureText;
//   final bool readOnly;
//   final List<String>? suggestions; 
//   final VoidCallback? onTap;
//   const CustomeField({
//     super.key,
//     required this.hintText,
//     required this.controller,
//     this.isObscureText = false,
//     this.readOnly =false,
//     this.onTap,
//     this.suggestions
    
//     });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       onTap: onTap,
//       readOnly: readOnly,
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//       ),
//       validator: (val) {
//         if(val!.trim().isEmpty) {
//           return "$hintText is missing";
//         }
//         return null;
//       },
//       obscureText: isObscureText,
//     );
//   }
// }

