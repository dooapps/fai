

String buildQueryParams(Map<String, dynamic> params) {
  if (params.isEmpty) return "";

  final queryString = params.entries
      .where((entry) => entry.value != null && entry.value.toString().isNotEmpty)
      .map((entry) => "${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}")
      .join("&");

  return "?$queryString";
}