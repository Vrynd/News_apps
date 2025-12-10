class FormValidators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final email = value.trim();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);

    if (!hasLetter || !hasNumber) {
      return 'Password harus terdiri dari huruf dan angka';
    }

    return null;
  }
}
