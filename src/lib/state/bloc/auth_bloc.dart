// ignore_for_file: unused_field, prefer_final_fields

//import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';


part 'auth_event.dart';
part 'auth_state.dart';
//
//
//
const authGQL = 
r'''
query login($email: String!, $password: String!) {
  loginNhost(credentials: {email: $email, password: $password }) {
    session {
      accessToken
      user {
        roles
        defaultRole
        displayName
        createdAt
        email
      }
    }
  }
}
'''
;
//
//
//
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //
  QueryResult? _authResult;
  //
  AuthBloc() : super(NotAuthenticated())
  {

    on<SignOut>((event, emit) {
      emit(NotAuthenticated());
    });


    on<SignIn>((event, emit) async {
      String errMessage = '';
      _authResult = await signIn(event.email, event.password);
      //
      if (_authResult!.hasException) {
        if (_authResult!.exception?.linkException != null) {
          errMessage = '${_authResult!.exception?.linkException.toString()}';
        } else if (_authResult!.exception?.graphqlErrors != null) {
          errMessage = '${_authResult!.exception?.graphqlErrors.first.message}';
        } else {
          errMessage = 'ERROR';
        }
        emit(AuthFailure(errMessage));
      } else if (_authResult!.isLoading) {
        emit(AuthLoading());
      } else {
        Map<String,dynamic> session = _authResult!.data?['loginNhost']['session'];
        emit(Authenticated(session));
      }
    } ,
    );
  }
//
//
//
Future<QueryResult>? signIn(email, password) async {
  final GraphQLClient client  = state.getClient;
  final QueryOptions  options = QueryOptions(
    document: gql(authGQL),
    variables: { 'email': email, 'password': password },
  );
  QueryResult result = await client.query(options);
  return result;
  }

}