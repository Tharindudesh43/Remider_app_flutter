class Validation {
  final RegExp passwordRegEx =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
  final RegExp emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp phoneRegEx = RegExp(r'^\d{10}$');

  checkvalidation({required String FieldValue, required int Fieldnumber}) {
    //Empty Check
    if (FieldValue.isEmpty && Fieldnumber == 1) {
      return "Please fill the name field";
    } else if (FieldValue.isEmpty && Fieldnumber == 2) {
      return "Please fill the e-mail field";
    } else if (FieldValue.isEmpty && Fieldnumber == 3) {
      return "Please fill the mobile number field";
    } else if (FieldValue.isEmpty && Fieldnumber == 4) {
      return "Please fill the password field";
    } else {
      if (!emailRegEx.hasMatch(FieldValue) && Fieldnumber == 2) {
        return "• Contain only letters, digits or hyphens before @.\n• Contain a valid domain with letters or hyphens after @.\n• At least two characters for the domain extension.";
      }
      if (!passwordRegEx.hasMatch(FieldValue) && Fieldnumber == 4) {
        return "• At least one letter (either lowercase or uppercase).\n• At least one digit.\n• At least one special character (@\$!%*#?&).\n• Minimum length of 8 characters.";
      }
      if (!phoneRegEx.hasMatch(FieldValue) && Fieldnumber == 3) {
        return "• Ensures the phone number contains exactly 10 digits.\n• Contain only numbers";
      } else {
        return null;
      }
    }
  }
}
