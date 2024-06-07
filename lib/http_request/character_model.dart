class ListCharacterModel {
  final Info? info;
  final List<Results>? results;

  ListCharacterModel({
    this.info,
    this.results,
  });

  ListCharacterModel.fromJson(Map<String, dynamic> json)
      : info = (json['info'] as Map<String,dynamic>?) != null ? Info.fromJson(json['info'] as Map<String,dynamic>) : null,
        results = (json['results'] as List?)?.map((dynamic e) => Results.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'info' : info?.toJson(),
    'results' : results?.map((e) => e.toJson()).toList()
  };
}

class Info {
  final int? count;
  final int? pages;
  final String? next;
  final dynamic prev;

  Info({
    this.count,
    this.pages,
    this.next,
    this.prev,
  });

  Info.fromJson(Map<String, dynamic> json)
      : count = json['count'] as int?,
        pages = json['pages'] as int?,
        next = json['next'] as String?,
        prev = json['prev'];

  Map<String, dynamic> toJson() => {
    'count' : count,
    'pages' : pages,
    'next' : next,
    'prev' : prev
  };
}

class Results {
  final int? id;
  final String? name;
  final String? status;
  final String? species;
  final String? type;
  final String? gender;
  final Origin? origin;
  final Location? location;
  final String? image;
  final List<String>? episode;
  final String? url;
  final String? created;

  Results({
    this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.origin,
    this.location,
    this.image,
    this.episode,
    this.url,
    this.created,
  });

  Results.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        status = json['status'] as String?,
        species = json['species'] as String?,
        type = json['type'] as String?,
        gender = json['gender'] as String?,
        origin = (json['origin'] as Map<String,dynamic>?) != null ? Origin.fromJson(json['origin'] as Map<String,dynamic>) : null,
        location = (json['location'] as Map<String,dynamic>?) != null ? Location.fromJson(json['location'] as Map<String,dynamic>) : null,
        image = json['image'] as String?,
        episode = (json['episode'] as List?)?.map((dynamic e) => e as String).toList(),
        url = json['url'] as String?,
        created = json['created'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'status' : status,
    'species' : species,
    'type' : type,
    'gender' : gender,
    'origin' : origin?.toJson(),
    'location' : location?.toJson(),
    'image' : image,
    'episode' : episode,
    'url' : url,
    'created' : created
  };
}

class Origin {
  final String? name;
  final String? url;

  Origin({
    this.name,
    this.url,
  });

  Origin.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        url = json['url'] as String?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'url' : url
  };
}

class Location {
  final String? name;
  final String? url;

  Location({
    this.name,
    this.url,
  });

  Location.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        url = json['url'] as String?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'url' : url
  };
}