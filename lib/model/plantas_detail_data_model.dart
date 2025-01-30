class PlantasDetailData {
  final Species? species;
  final Family? family;
  final Genus? genus;
  final List<String>? projects;
  final List<String>? commonNames;
  final List<String>? synonyms;
  final List<String>? links;
  final PlantImages? images;
  final int? imagesCount;
  final int? observationsCount;
  final List<SynonymDetails>? synonymsDetails;
  final List<Uses>? uses;
  final Gbif? gbif;
  final Powo? powo;
  final Eppo? eppo;
  final String? map;

  PlantasDetailData({
    this.species,
    this.family,
    this.genus,
    this.projects,
    this.commonNames,
    this.synonyms,
    this.links,
    this.images,
    this.imagesCount,
    this.observationsCount,
    this.synonymsDetails,
    this.uses,
    this.gbif,
    this.powo,
    this.eppo,
    this.map,
  });

  factory PlantasDetailData.fromJson(Map<String, dynamic> json) {
    return PlantasDetailData(
      species: Species.fromJson(json['species']),
      family: Family.fromJson(json['family']),
      genus: Genus.fromJson(json['genus']),
      projects: List<String>.from(json['projects'] ?? []),
      commonNames: List<String>.from(json['commonNames'] ?? []),
      synonyms: List<String>.from(json['synonyms'] ?? []),
      links: List<String>.from(json['links'] ?? []),
      images:
          json['images'] != null ? PlantImages.fromJson(json['images']) : null,
      imagesCount: json['imagesCount'] as int,
      observationsCount: json['observationsCount'] as int,
      synonymsDetails: (json['synonymsDetails'] as List<dynamic>)
          .map((item) => SynonymDetails.fromJson(item))
          .toList(),
      uses: json.containsKey('fruit')
          ? (json['uses'] as List<dynamic>)
              .map((item) => Uses.fromJson(item))
              .toList()
          : [],
      gbif: json['gbif'] != null ? Gbif.fromJson(json['gbif']) : null,
      powo: json['powo'] != null ? Powo.fromJson(json['powo']) : null,
      eppo: json['eppo'] != null ? Eppo.fromJson(json['eppo']) : null,
      map: json['map'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'species': species?.toJson(),
      'family': family?.toJson(),
      'genus': genus?.toJson(),
      'projects': projects,
      'commonNames': commonNames,
      'synonyms': synonyms,
      'links': links,
      'images': images?.toJson(),
    };
  }
}

class Family {
  final String? name;
  final String? author;

  Family({this.name, this.author});

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      name: json['name'] as String?,
      author: json['author'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
    };
  }
}

class Genus {
  final String? name;
  final String? author;

  Genus({this.name, this.author});

  factory Genus.fromJson(Map<String, dynamic> json) {
    return Genus(
      name: json['name'] as String?,
      author: json['author'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
    };
  }
}

class Species {
  final String? name;
  final String? author;

  Species({this.name, this.author});

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      name: json['name'] as String?,
      author: json['author'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
    };
  }
}

class PlantImages {
  final List<PlantImage>? fruit;
  final List<PlantImage>? flower;
  final List<PlantImage>? leaf;
  final List<PlantImage>? bark;
  final List<PlantImage>? other;
  final List<PlantImage>? habit;

  PlantImages(
      {this.fruit, this.flower, this.leaf, this.bark, this.other, this.habit});

  factory PlantImages.fromJson(Map<String, dynamic> json) {
    return PlantImages(
      fruit: _getListFromJson(json, 'fruit', 80),
      flower: _getListFromJson(json, 'flower', 90),
      leaf: _getListFromJson(json, 'leaf', 70),
      bark: _getListFromJson(json, 'bark', 60),
      other: _getListFromJson(json, 'other', 40),
      habit: _getListFromJson(json, 'habit', 50),
    );
  }

  static List<PlantImage> _getListFromJson(
      Map<String, dynamic> json, String key, int limit) {
    if (json.containsKey(key) && json[key] != null) {
      List<dynamic> list = json[key];
      if (list.length > limit) {
        list = list.sublist(0, limit);
      }
      return list.map((item) => PlantImage.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'fruit': fruit!.map((image) => image.toJson()).toList(),
      'flower': flower!.map((image) => image.toJson()).toList(),
      'leaf': leaf!.map((image) => image.toJson()).toList(),
      'bark': bark!.map((image) => image.toJson()).toList(),
      'other': other!.map((image) => image.toJson()).toList(),
      'habit': habit!.map((image) => image.toJson()).toList(),
    };
  }
}

class PlantImage {
  final String? id;
  final String? o; // Original size URL
  final String? m; // Medium size URL
  final String? s; // Small size URL
  final String? author;
  final String? license;
  final String? date;
  final Map<String, dynamic>? plus; // Optional field
  final String? observationId;

  PlantImage({
    this.id,
    this.o,
    this.m,
    this.s,
    this.author,
    this.license,
    this.date,
    this.plus,
    this.observationId,
  });

  factory PlantImage.fromJson(Map<String, dynamic> json) {
    return PlantImage(
      id: json['id'] as String,
      o: json['o'] as String,
      m: json['m'] as String,
      s: json['s'] as String,
      author: json['author'] as String,
      license: json['license'] as String,
      date: json['date'] as String,
      plus: json['plus'] != null
          ? Map<String, dynamic>.from(json['plus']!)
          : null,
      observationId: json['observationId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'o': o,
      'm': m,
      's': s,
      'author': author,
      'license': license,
      'date': date,
      'plus': plus,
      'observationId': observationId,
    };
  }
}

class SynonymDetails {
  final String name;
  final String author;

  SynonymDetails({
    required this.name,
    required this.author,
  });

  factory SynonymDetails.fromJson(Map<String, dynamic> json) {
    return SynonymDetails(
      name: json['name'] as String,
      author: json['author'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
    };
  }
}

class Uses {
  final String category;
  final List<String> types;

  Uses({required this.category, required this.types});

  factory Uses.fromJson(Map<String, dynamic> json) {
    return Uses(
      category: json['category'] as String,
      types: List<String>.from(json['types'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'types': types,
    };
  }
}

class Gbif {
  final String id;

  Gbif({required this.id});

  factory Gbif.fromJson(Map<String, dynamic> json) {
    return Gbif(
      id: json['id'] as String,
    );
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
    return Powo(
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class Eppo {
  final String code;

  Eppo({required this.code});

  factory Eppo.fromJson(Map<String, dynamic> json) {
    return Eppo(
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
    };
  }
}
