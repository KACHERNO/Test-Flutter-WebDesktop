part of 'auth_bloc.dart';

const linkAPI = 'https://hoqdughzdgcwvqwmdviq.hasura.ap-south-1.nhost.run/v1/graphql';

//
// STATE: [ Authenticated, NotAuthenticated, Loading ]
//
class AuthState {  

    Map<String,dynamic>? _session;
    String?   _errorMessage;
    Link      _authlink  = HttpLink(linkAPI);
    final HttpLink _httpLink  = HttpLink(linkAPI);
    GraphQLClient _client = GraphQLClient( link: HttpLink(linkAPI), cache: GraphQLCache(), );

   get getSession      => _session;
   String? get getError        => _errorMessage;
   String? get getAccessToken  => _session?['accessToken'];
   String? get getRefreshToken => _session?['refreshToken'];
   GraphQLClient get getClient       => _client;
   String? get getDisplayName  => _session?['user']['displayName'];
   String? get getDefautRole   => _session?['user']['defaultRole'];
   String? get getEmail        => _session?['user']['email'];

/*
"user": {
            "avatarUrl": "https://www.gravatar.com/avatar/d99c9093443e7bfc295ac857adcfa11f?d=blank&r=g",
            "createdAt": "2024-11-13T10:38:51.571191Z",
            "defaultRole": "user",
            "displayName": "Ivan Ivanov",
*/


   void changeAuthLink() {
     AuthLink alink = AuthLink(getToken: () async => 'Bearer $getAccessToken');
     _authlink = alink.concat(_httpLink);
   }

   void clearAuthLink() {
     _authlink = HttpLink(linkAPI);
   }

   Link getClientLink() {
     return getAccessToken != null ? _authlink : _httpLink;
   }

   void changeClient() {
    _client = 
      GraphQLClient(
        link: getClientLink(),
        cache: GraphQLCache(),
      );
    
   }




}
class NotAuthenticated  extends AuthState {
  NotAuthenticated(){
    clearAuthLink();
    changeClient();
  }
}
class AuthLoading       extends AuthState {}
class Authenticated     extends AuthState {
  String? currentUser;
  Authenticated(Map<String,dynamic> session){
    super._session = session;
    currentUser = session['user']['displayName'];
    changeAuthLink();
    changeClient();
  }
}
class AuthFailure extends AuthState {
  AuthFailure(String err) {
    super._errorMessage = err;
    clearAuthLink();
    changeClient();
  }
}
