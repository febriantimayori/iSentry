import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/identity_model.dart';
import 'package:isentry/presentation/home/bloc/identity/identity_event.dart';
import 'package:isentry/presentation/home/bloc/identity/identity_state.dart';
import 'package:isentry/services/network_service.dart';

class IdentityBloc extends Bloc<IdentityEvent, IdentityState> {
  IdentityBloc() : super(IdentityInitial()) {
    on<GetAllIdentity>((event, emit) async {
      emit(IdentityLoading());

      try {
        final url = Uri.http(ipAddress, 'api/identities');
        final response = await NetworkService.get(url.toString());
        print("GetAllIdentity response: $response");

        if (response['success']) {
          final allIdentities = (response['data'] as List)
              .map((identity) => IdentityModel.fromJson(identity))
              .toList();
          emit(AllIdentityLoaded(allIdentities));
        } else {
          emit(IdentityFailure(response['message'] ?? 'Failed to load users'));
        }
      } catch (e) {
        emit(IdentityFailure("Failed to fetch user: $e"));
      }
    });

    on<UpdateKey>((event, emit) async {
      emit(IdentityLoading());

      try {
        final url = Uri.http(ipAddress, 'api/identities/${event.id}');
        final response = await NetworkService.patch(url.toString(), body: {
          'key': event.key,
        });

        if (response['success']) {
          emit(KeyUpdated(id: event.id, key: event.key));
        } else {
          emit(IdentityFailure(response['message']));
        }
      } catch (e) {
        emit(IdentityFailure("Failed to fetch user: $e"));
      }
    });

    on<GetIdentityById>((event, emit) async {
      emit(IdentityLoading());

      try {
        final url = Uri.http(ipAddress, 'api/identities/${event.id}');
        final response = await NetworkService.get(url.toString());
        print("GetIdentityById response: $response");

        if (response['success']) {
          IdentityModel identities = IdentityModel.fromJson(response['data']);
          emit(IdentityLoaded(identities));
        } else {
          emit(IdentityFailure(response['message']));
        }
      } catch (e) {
        emit(IdentityFailure("Failed to fetch user: $e"));
      }
    });

    on<DeleteIdentity>((event, emit) async {
      emit(IdentityLoading());

      try {
        final url = Uri.http(ipAddress, 'api/identities/${event.id}');
        final response = await NetworkService.delete(url.toString());

        if (response['success']) {
          emit(IdentityDeleted());
          add(GetAllIdentity());
        } else {
          emit(IdentityFailure(response['message']));
        }
      } catch (e) {
        emit(IdentityFailure("Failed to fetch user: $e"));
      }
    });
  }
}
