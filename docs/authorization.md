# Authorization

Each client (Winnitron or Game) is given an API key and secret. As the name suggests, don't share your secret. 😅

## Unsigned Requests

Most API requests do not require the additional security of being signed with your secret; you only need to send your API key. There are two options:

### In the query string/POST request body

Example:

`GET /api/v1/playlists?api_key=89affecb193650e491b653541461dbc4`

### In the `Authorization` http header

```
Authorization: Token 89affecb193650e491b653541461dbc4
GET /api/v1/playlists
```


## Signed Requests

To prove that it really is you sending the request, and that arbitrary data can't be sent without your secret, some endpoint require a signature. Sending a correctly-signed request to an endpoing that does not require it will still work.

### The `Authorization` http request header

Format the Authorization value as `Winnitron API_KEY:SIGNATURE`

```
Authorization: Winnitron 89affecb193650e491b653541461dbc4:90ec5644bc17666a5f065c94141
GET /api/v1/playlists
```

### Generating the signature

1. Take all parameters being sent in the request
2. Convert to query string format, alphabetized by key
3. Generate a hexadecimal SHA256 hash, salted with your API secret
  - i.e. SHA256(alphabetized_query_string + api_secret)

#### Example

So you want to send a new high score. The information you've got is:

API key: 89affecb193650e491b653541461dbc4
API secret: 2f9f56f11bb6cc683c845b09ce84bd76
score: 10321
name: Tilly
winnitron_id: winnitron-1000

As a query string:

`score=10321&name=Tilly&winnitron_id=winnitron-1000`

But it must first be alphabetized by key:

`name=Tilly&score=10321&winnitron_id=winnitron-1000`

Almost done! Just gotta salt that hash:

```
SHA256(alphbetized_query_string + api_secret)

 =

SHA256("name=Tilly&score=10321&winnitron_id=winnitron-10002f9f56f11bb6cc683c845b09ce84bd76")

 =

8d41801c4ab4dabc13d4f4105590070a1589306b25bd7332da2e065cce3bd330
```

There you go. Include that final value as the second component in the `Authorization` header as described above.
