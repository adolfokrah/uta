// To parse this JSON data, do
//
//     final songModel = songModelFromJson(jsonString);

import 'dart:convert';

SongModel songModelFromJson(String str) => SongModel.fromJson(json.decode(str));

String songModelToJson(SongModel data) => json.encode(data.toJson());

class SongModel {
  SongModel({
    this.status,
    this.metadata,
    this.resultType,
    this.costTime,
  });

  Status? status;
  Metadata? metadata;
  int? resultType;
  double? costTime;

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
    status: Status.fromJson(json["status"]),
    metadata: Metadata.fromJson(json["metadata"]),
    resultType: json["result_type"],
    costTime: json["cost_time"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "status": status?.toJson(),
    "metadata": metadata?.toJson(),
    "result_type": resultType,
    "cost_time": costTime,
  };
}

class Metadata {
  Metadata({
    this.music,
    this.timestampUtc,
  });

  List<Music>? music;
  DateTime? timestampUtc;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    music: List<Music>.from(json["music"].map((x) => Music.fromJson(x))),
    timestampUtc: DateTime.parse(json["timestamp_utc"]),
  );

  Map<String, dynamic> toJson() => {
    "music": List<dynamic>.from(music!.map((x) => x.toJson())),
    "timestamp_utc": timestampUtc!.toIso8601String(),
  };
}

class Music {
  Music({
    this.externalIds,
    this.artists,
    this.durationMs,
    this.label,
    this.genres,
    this.title,
    this.resultFrom,
    this.album,
    this.playOffsetMs,
    this.acrid,
    this.externalMetadata,
    this.releaseDate,
    this.score,
  });

  ExternalIds? externalIds;
  List<Album>? artists;
  int? durationMs;
  String? label;
  List<Album>? genres;
  String? title;
  int? resultFrom;
  Album? album;
  int? playOffsetMs;
  String? acrid;
  ExternalMetadata? externalMetadata;
  DateTime? releaseDate;
  int? score;

  factory Music.fromJson(Map<String, dynamic> json) => Music(
    externalIds: ExternalIds.fromJson(json["external_ids"]),
    artists: List<Album>.from(json["artists"].map((x) => Album.fromJson(x))),
    durationMs: json["duration_ms"],
    label: json["label"],
    genres: List<Album>.from(json["genres"].map((x) => Album.fromJson(x))),
    title: json["title"],
    resultFrom: json["result_from"],
    album: Album.fromJson(json["album"]),
    playOffsetMs: json["play_offset_ms"],
    acrid: json["acrid"],
    externalMetadata: ExternalMetadata.fromJson(json["external_metadata"]),
    releaseDate: DateTime.parse(json["release_date"]),
    score: json["score"],
  );

  Map<String, dynamic> toJson() => {
    "external_ids": externalIds!.toJson(),
    "artists": List<dynamic>.from(artists!.map((x) => x.toJson())),
    "duration_ms": durationMs,
    "label": label,
    "genres": List<dynamic>.from(genres!.map((x) => x.toJson())),
    "title": title,
    "result_from": resultFrom,
    "album": album!.toJson(),
    "play_offset_ms": playOffsetMs,
    "acrid": acrid,
    "external_metadata": externalMetadata!.toJson(),
    "release_date": "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
    "score": score,
  };
}

class Album {
  Album({
    this.name,
  });

  String? name;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

class ExternalIds {
  ExternalIds({
    this.isrc,
    this.upc,
  });

  String? isrc;
  String? upc;

  factory ExternalIds.fromJson(Map<String, dynamic> json) => ExternalIds(
    isrc: json["isrc"],
    upc: json["upc"],
  );

  Map<String, dynamic> toJson() => {
    "isrc": isrc,
    "upc": upc,
  };
}

class ExternalMetadata {
  ExternalMetadata({
    this.spotify,
    this.deezer,
  });

  Deezer? spotify;
  Deezer? deezer;

  factory ExternalMetadata.fromJson(Map<String, dynamic> json) => ExternalMetadata(
    spotify: Deezer.fromJson(json["spotify"]),
    deezer: Deezer.fromJson(json["deezer"]),
  );

  Map<String, dynamic> toJson() => {
    "spotify": spotify!.toJson(),
    "deezer": deezer!.toJson(),
  };
}

class Deezer {
  Deezer({
    this.album,
    this.artists,
    this.track,
  });

  Album? album;
  List<Album>? artists;
  Track? track;

  factory Deezer.fromJson(Map<String, dynamic> json) => Deezer(
    album: Album.fromJson(json["album"]),
    artists: List<Album>.from(json["artists"].map((x) => Album.fromJson(x))),
    track: Track.fromJson(json["track"]),
  );

  Map<String, dynamic> toJson() => {
    "album": album!.toJson(),
    "artists": List<dynamic>.from(artists!.map((x) => x.toJson())),
    "track": track!.toJson(),
  };
}

class Track {
  Track({
    this.name,
    this.id,
  });

  String? name;
  String? id;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}

class Status {
  Status({
    this.code,
    this.version,
    this.msg,
  });

  int? code;
  String? version;
  String? msg;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    code: json["code"],
    version: json["version"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "version": version,
    "msg": msg,
  };
}
