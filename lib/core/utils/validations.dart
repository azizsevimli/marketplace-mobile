class Validations {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresi boş bırakılamaz';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Geçerli bir e-posta adresi giriniz';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Şifre boş bırakılamaz';
    }

    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+.,<>?])[A-Za-z\d!@#$%^&*()_+.,<>?]{8,}$',
    );

    if (!passwordRegex.hasMatch(value.trim())) {
      return 'Şifre en az 8 karakter olmalı ve büyük harf, küçük harf, sayı ve özel karakter içermelidir';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan boş bırakılamaz';
    }

    final text = value.trim();

    if (text.length < 3) {
      return 'En az 3 karakter olmalıdır';
    }

    return null;
  }
}
