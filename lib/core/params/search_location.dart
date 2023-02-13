class SearchLocationParams {
  final String keyword;
  final int page;
  final SearchLocationCountry country;
  final double latitude;
  final double longitude;

  SearchLocationParams({
    required this.keyword,
    required this.page,
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}

enum SearchLocationCountry { korea, other }
