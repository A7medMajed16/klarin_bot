class TextHelper {
  static String rewriteReminderMessage(
    String apiMessage, {
    String? reviewerName,
    String? clinicName,
    String? clinicAddress,
    String? visitDate,
  }) {
    if (apiMessage.isEmpty) return apiMessage;

    final Map<String, String?> values = {
      'reviewer_name': reviewerName,
      'clinic_name': clinicName,
      'clinic_address': clinicAddress,
      'visit_date': visitDate,
    };

    final RegExp regex = RegExp(r'\$\{\s*([^}]+?)\s*\}');

    String normalizeVar(String name) {
      return name
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'[\s\-]+'), '_')
          .replaceAll(RegExp(r'[^a-z0-9_]+'), '');
    }

    String? canonicalFor(String normalized) {
      const Map<String, String> synonyms = {
        // Reviewer name
        'reviewer_name': 'reviewer_name',
        'reviewer': 'reviewer_name',
        'reviewername': 'reviewer_name',
        'full_name': 'reviewer_name',
        'fullname': 'reviewer_name',
        'name': 'reviewer_name',
        'patient': 'reviewer_name',
        'patient_name': 'reviewer_name',

        // Clinic name (handle common "cilinc" typo)
        'clinic_name': 'clinic_name',
        'clinicname': 'clinic_name',
        'clinic': 'clinic_name',
        'cilinc_name': 'clinic_name',
        'cilincname': 'clinic_name',
        'cilinc': 'clinic_name',
        'clinic_title': 'clinic_name',
        'clinictitle': 'clinic_name',

        // Clinic address
        'clinic_address': 'clinic_address',
        'clinicaddress': 'clinic_address',
        'address': 'clinic_address',
        'address_line': 'clinic_address',
        'addressline': 'clinic_address',
        'location': 'clinic_address',
        'cilinc_address': 'clinic_address',
        'cilincaddress': 'clinic_address',

        // Visit date
        'visit_date': 'visit_date',
        'visitdate': 'visit_date',
        'next_visit_date': 'visit_date',
        'nextvisitdate': 'visit_date',
        'next_visit': 'visit_date',
        'nextvisit': 'visit_date',
        'appointment_date': 'visit_date',
        'appointmentdate': 'visit_date',
        'appointment': 'visit_date',
        'date': 'visit_date',
        'visit_time': 'visit_date',
        'appointment_time': 'visit_date',
        'time': 'visit_date',
      };
      return synonyms[normalized];
    }

    return apiMessage.replaceAllMapped(regex, (match) {
      final rawVar = match.group(1)!; // content inside ${...}
      final normalized = normalizeVar(rawVar);
      final canonical = canonicalFor(normalized);
      final replacement = (canonical != null
          ? values[canonical]
          : values[normalized]);

      if (replacement == null || replacement.isEmpty) {
        return match.group(0)!;
      }
      return replacement;
    });
  }
}
