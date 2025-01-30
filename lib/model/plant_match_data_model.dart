class PlantasMatchData {
  final Query? query;
  final String? language;
  final String? preferedReferential;
  final String? bestMatch;
  final List<Result>? results;

  PlantasMatchData({
    this.query,
    this.language,
    this.preferedReferential,
    this.bestMatch,
    this.results,
  });

  factory PlantasMatchData.fromJson(Map<String, dynamic> json) {
    return PlantasMatchData(
      query: Query.fromJson(json['query']),
      language: json.containsKey('language') ? json['language'] as String : '',
      preferedReferential: json['preferedReferential'] as String,
      bestMatch: json['bestMatch'] as String,
      results: (json['results'] as List<dynamic>)
          .map((item) => Result.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query!.toJson(),
      'language': language,
      'preferedReferential': preferedReferential,
      'bestMatch': bestMatch,
      'results': results!.map((result) => result.toJson()).toList(),
    };
  }
}

class Query {
  final String? project;
  final List<String>? images;
  final List<String>? organs;
  final bool? includeRelatedImages;
  final bool? noReject;

  Query({
    required this.project,
    required this.images,
    required this.organs,
    required this.includeRelatedImages,
    required this.noReject,
  });

  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      project: json['project'] as String,
      images: List<String>.from(json['images'] as List<dynamic>),
      organs: List<String>.from(json['organs'] as List<dynamic>),
      includeRelatedImages: json['includeRelatedImages'] as bool,
      noReject: json['noReject'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project': project,
      'images': images,
      'organs': organs,
      'includeRelatedImages': includeRelatedImages,
      'noReject': noReject,
    };
  }
}

class Result {
  final double score;
  final Species species;
  final List<PlantImage> images;
  final Gbif? gbif;
  final Powo? powo;
  final Iucn? iucn;

  Result({
    required this.score,
    required this.species,
    required this.images,
    this.gbif,
    this.powo,
    this.iucn,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      score: json['score'].toDouble(),
      species: Species.fromJson(json['species']),
      images: (json['images'] as List<dynamic>)
          .map((item) => PlantImage.fromJson(item))
          .toList(),
      gbif: json['gbif'] != null ? Gbif.fromJson(json['gbif']) : null,
      powo: json['powo'] != null ? Powo.fromJson(json['powo']) : null,
      iucn: json['iucn'] != null ? Iucn.fromJson(json['iucn']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'species': species.toJson(),
      'images': images.map((image) => image.toJson()).toList(),
      'gbif': gbif?.toJson(),
      'powo': powo?.toJson(),
      'iucn': iucn?.toJson(),
    };
  }
}

class Species {
  final String scientificNameWithoutAuthor;
  final String scientificNameAuthorship;
  final Genus genus;
  final Family family;
  final List<String> commonNames;
  final String scientificName;

  Species({
    required this.scientificNameWithoutAuthor,
    required this.scientificNameAuthorship,
    required this.genus,
    required this.family,
    required this.commonNames,
    required this.scientificName,
  });

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      scientificNameWithoutAuthor: json['scientificNameWithoutAuthor'],
      scientificNameAuthorship: json['scientificNameAuthorship'],
      genus: Genus.fromJson(json['genus']),
      family: Family.fromJson(json['family']),
      commonNames: (json['commonNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scientificName: json['scientificName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scientificNameWithoutAuthor': scientificNameWithoutAuthor,
      'scientificNameAuthorship': scientificNameAuthorship,
      'genus': genus.toJson(),
      'family': family.toJson(),
      'commonNames': commonNames,
      'scientificName': scientificName,
    };
  }
}

class Genus {
  final String scientificNameWithoutAuthor;
  final String scientificNameAuthorship;
  final String scientificName;

  Genus({
    required this.scientificNameWithoutAuthor,
    required this.scientificNameAuthorship,
    required this.scientificName,
  });

  factory Genus.fromJson(Map<String, dynamic> json) {
    return Genus(
      scientificNameWithoutAuthor: json['scientificNameWithoutAuthor'],
      scientificNameAuthorship: json['scientificNameAuthorship'],
      scientificName: json['scientificName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scientificNameWithoutAuthor': scientificNameWithoutAuthor,
      'scientificNameAuthorship': scientificNameAuthorship,
      'scientificName': scientificName,
    };
  }
}

class Family {
  final String scientificNameWithoutAuthor;
  final String scientificNameAuthorship;
  final String scientificName;

  Family({
    required this.scientificNameWithoutAuthor,
    required this.scientificNameAuthorship,
    required this.scientificName,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      scientificNameWithoutAuthor: json['scientificNameWithoutAuthor'],
      scientificNameAuthorship: json['scientificNameAuthorship'],
      scientificName: json['scientificName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scientificNameWithoutAuthor': scientificNameWithoutAuthor,
      'scientificNameAuthorship': scientificNameAuthorship,
      'scientificName': scientificName,
    };
  }
}

class PlantImage {
  final String organ;
  final String author;
  final String license;
  final ImageDate date;
  final Url url;
  final String citation;

  PlantImage({
    required this.organ,
    required this.author,
    required this.license,
    required this.date,
    required this.url,
    required this.citation,
  });

  factory PlantImage.fromJson(Map<String, dynamic> json) {
    return PlantImage(
      organ: json['organ'],
      author: json['author'],
      license: json['license'],
      date: ImageDate.fromJson(json['date']),
      url: Url.fromJson(json['url']),
      citation: json['citation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organ': organ,
      'author': author,
      'license': license,
      'date': date.toJson(),
      'url': url.toJson(),
      'citation': citation,
    };
  }
}

class ImageDate {
  final int timestamp;
  final String string;

  ImageDate({
    required this.timestamp,
    required this.string,
  });

  factory ImageDate.fromJson(Map<String, dynamic> json) {
    return ImageDate(
      timestamp: json['timestamp'],
      string: json['string'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'string': string,
    };
  }
}

class Url {
  final String? o;
  final String? m;
  final String? s;

  Url({
    this.o,
    this.m,
    this.s,
  });

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
      o: json['o'],
      m: json['m'],
      s: json['s'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'o': o,
      'm': m,
      's': s,
    };
  }
}

class Gbif {
  final String id;

  Gbif({required this.id});

  factory Gbif.fromJson(Map<String, dynamic> json) {
    return Gbif(id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class Powo {
  final String id;

  Powo({required this.id});

  factory Powo.fromJson(Map<String, dynamic> json) {
    return Powo(id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class Iucn {
  final String id;
  final String category;

  Iucn({
    required this.id,
    required this.category,
  });

  factory Iucn.fromJson(Map<String, dynamic> json) {
    return Iucn(
      id: json['id'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
    };
  }
}
