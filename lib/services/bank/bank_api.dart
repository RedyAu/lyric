import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../data/bank/bank.dart';
import '../../data/log/logger.dart';
import '../../data/song/song.dart';
import '../error/app_error.dart';

class BankApi {
  final Dio dio;

  const BankApi(this.dio);

  Object? _decodeJsonBody(Object? body) {
    if (body is String) {
      return jsonDecode(body);
    }

    return body;
  }

  Future<List<ProtoSong>> getProtoSongs(Bank bank, {DateTime? since}) async {
    final queryParameters = <String, dynamic>{};
    if (since != null) {
      queryParameters['c'] = DateFormat('yyyy-MM-dd+HH:mm').format(since);
    }

    final source = Uri.parse('${bank.baseUrl}/songs/').replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    final resp = await dio.getUri(source);
    final jsonList = (_decodeJsonBody(resp.data) ?? const <dynamic>[]) as List;

    return jsonList
        .map((e) => ProtoSong.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Song>> getDetailsForSongs(Bank bank, List<String> uuids) async {
    final source = Uri.parse('${bank.baseUrl}/song/${uuids.join(',')}/');

    final resp = await dio.getUri(source);
    try {
      final songsJson = _decodeJsonBody(resp.data);
      if (songsJson is List) {
        List<Song> songs = [];
        for (Map songJson in songsJson) {
          songs.add(
            Song.fromBankApiJson(
              songJson as Map<String, dynamic>,
              sourceBank: bank,
            ),
          );
        }
        return songs;
      } else {
        var song = Song.fromBankApiJson(
          songsJson as Map<String, dynamic>,
          sourceBank: bank,
        );
        return [song];
      }
    } catch (e, s) {
      throw AppError.from(
        e,
        stackTrace: s,
        userMessage: 'Hiba történt néhány dal feldolgozása közben.',
        technicalMessage: 'Error while updating songs with uuids $uuids\n$e',
      );
    }
  }

  Future<DateTime?> getRemoteLastUpdated(Bank bank) async {
    try {
      final resp = await dio.getUri(Uri.parse('${bank.baseUrl}/about/'));
      final jsonData =
          (_decodeJsonBody(resp.data) ?? const <String, dynamic>{})
              as Map<String, dynamic>;

      if (jsonData.containsKey('lastUpdated')) {
        return DateTime.parse(jsonData['lastUpdated'] as String);
      }
      return null;
    } catch (e, s) {
      log.warning(
        'Nem sikerült lekérni a tár távoli frissítési idejét: ${bank.name}',
        e,
        s,
      );
      return null;
    }
  }
}
