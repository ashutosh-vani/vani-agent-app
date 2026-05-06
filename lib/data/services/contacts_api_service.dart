import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/network/api_endpoints.dart';
import 'package:vani_app/core/network/dio_client.dart';
import 'package:vani_app/models/contact_model.dart';

class ContactsApiService {
  final DioClient _dioClient;

  ContactsApiService(this._dioClient);

  Future<ContactsResponse> getContacts({
    int page = 1,
    int limit = 20,
    String? search,
    String? leadStatus,
    String? source,
    bool? hasCalls,
    bool? hasNotes,
    String? tags,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.contacts,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (leadStatus != null && leadStatus.isNotEmpty) 'lead_status': leadStatus,
        if (source != null && source.isNotEmpty) 'source': source,
        if (hasCalls != null) 'has_calls': hasCalls,
        if (hasNotes != null) 'has_notes': hasNotes,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
      },
    );
    return ContactsResponse.fromJson(response.data);
  }

  Future<Contact> updateContactStatus({
    required String phoneNumber,
    required String leadStatus,
  }) async {
    final response = await _dioClient.patch(
      ApiEndpoints.updateContactStatus(phoneNumber),
      data: {
        'lead_status': leadStatus,
      },
    );
    return Contact.fromJson(response.data);
  }
}

// Provider
final contactsApiServiceProvider = Provider<ContactsApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ContactsApiService(dioClient);
});
