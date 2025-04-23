//
// import 'package:googleapis_auth/auth_io.dart';
//
// class ServerKey {
//   static Future<String> server_token() async {
//     final scopes = [
//       'https://www.googleapis.com/auth/userinfo.email',
//       'https://www.googleapis.com/auth/firebase.database',
//       'https://www.googleapis.com/auth/firebase.messaging',
//     ];
//     final client = await clientViaServiceAccount(
//         ServiceAccountCredentials.fromJson({
//           "type": "service_account",
//           "project_id": "yunusco-system",
//           "private_key_id": "b5b0231bb6ec7fce0aee8f962d5fc1fb5a07d351",
//           "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDD1AZItGzqRtec\nRqYM6rqwUa5bMIfYGLwGnJsgROk1yI3BTH5+a8sA2J76uV0lvfLMA+uNdzhIeRdV\nAFF6o5WwpIjv6dzA7wgV1hJ9XhMs2k8j70bE/BJ0dx/BM9MRvanb7kwbXSoyvEJ6\nEcRVLxPFHrmWZ/U964tGaU5S9mcbGA9Kr3Gawta179z3peCnA4Pygx8qpAgA8UZr\n65epMVm5T+IK56QXGuOzygTwulwplLNyDMPuZ3t/zWtNnnQkz9e/NiVih6Ip6FnY\nQhascpTdiu1gjWmuOR9sSTHpsXNjlBnY0t3N9KFG9n2zKz5TdiA296MrRo4zrxE5\nc0BdXa3PAgMBAAECggEANHMIT9bLSSA6RWgCt3jzEaB+83uXFsDhM2AkiEsMr1QM\n65XiV1flok9inUKieSZb7lqqb1RcJcURA7o3GILR5+LZrnBTqPUclESm5R8aQawj\nADvpF39wLfNt9OA9iwXihb5YcgfM8pPLtkgl7q7SO7yT9n3XiIMa5Xv093F5gh7B\n0vD/P3PQCGNbVi1rhx7qZA4PlzRr+DY8r8BOEmRycy0UOZhO/37NdmDaTyds8JlG\nK6C07V4NSbfJMjE0rO9sarlb2NudnobmP7Mc7fiT3vBegAYd0f+B8m9RSzxLpjoM\nsmz93SkK9nWbGV7G5zUITzOxzHqqBRdBrMvz0tVSmQKBgQD7a4YpycuqJ3euWmdE\n7CwPyjwKVzmv2udHzcocWQbVGJXYJlDKV2lxIcL2s+X3tjCQvY67PlMlCp0weVc7\nD0LRcJgp2wkvetefLWupwR3jvwonbLJcUiXzODoJpy9KegsssGUwxlY1SGAjKy6t\nPm9icf0DQrDuI/o9KLdPmDJD/QKBgQDHZUC6v9exnyX5TOrPhpgEypD4meTz7g+j\n5yPy9BKWXjMVVPRMfLW8aJpvgDphNnCYETFMHERPk8kPna7VHuIpye53LDQTPc9W\nAvr+dK3oLqxydzkUgR1PQ91mNM4aO5OWtZDziwpNBkPXbq84vqEYVc1TUsRJvWcN\nnVkI3eNUuwKBgA50iCou5/7IdiEYIYfc7EucHQebLD3oIBQIyO4IUFRALZ1X1p1L\nmUxf3I3Cmh47417vBx3M34rpqU/4KgPDRNw11QnTBhwsu+jy+5Wu/MDzYuoRXc/h\nCT2KpguYCSgHDE1tduPvA1Xc62oaOXzMcir+0sU1OGb4upJ5nNB+t6UhAoGASh/G\n52Wn3n0GVd4VMF6dprJTIEe9iDzIjarAf3HicwnDvbteMgzuVoMgXjDyAu+E/dLu\nW5fqgRa0WNzKgKnBc72Aq8a/+SMyL4xeGDfx6m1naAoQKyIwbiYRaQxaTgA1xoHq\nx865Xpbko3KfKt4a7vv+n2oWVD9XzwTec2BhQT8CgYAGQcdm8ou7hQvSFbCB6G1W\nIWpT6ZlITMTgsw4e5DY2eNn9nUqgB5cHJbGc4aASe1rwxAAJozdOWhKr1gSVDLhR\noM/jFdzHdfnuAn347j1V8Z9ifgWZPCFRJNhWwidLFCFcbKqj80xERiN0MYnH2Y6E\n71ax7Ik315ye1oYUZachYA==\n-----END PRIVATE KEY-----\n",
//           "client_email": "firebase-adminsdk-fbsvc@yunusco-system.iam.gserviceaccount.com",
//           "client_id": "116324191505570325990",
//           "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//           "token_uri": "https://oauth2.googleapis.com/token",
//           "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//           "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40yunusco-system.iam.gserviceaccount.com",
//           "universe_domain": "googleapis.com"
//         }
//         ),
//         scopes);
//     final accessserverkey = client.credentials.accessToken.data;
//     return accessserverkey;
//   }
// }