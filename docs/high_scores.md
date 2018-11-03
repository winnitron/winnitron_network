# High Scores

## Testing sandbox

These endpoints accept a `test` parameter. Creating a high score with `test=1` will create an in-sandbox score. When fetching scores with `test=1`, only scores *created* in the testing sandbox will be returned.

By default (i.e., if there is no `test` param included at all), requests are treated as being live, non-sandbox operations.

## Create a new High Score

*This action requires a signed request.* See 'Authentication' docs.

```
POST http://network.winnitron.com/api/v1/high_scores
```

### Parameters

param   | Description
--------|------------
`name`  | The player's name.
`score` | The player's score (an integer).
`winnitron_id` | Optional. The Winnitron's parameterized name or public API key.
`test`  | Optional. Any value other than blank or 0 is treated as `true`

### Response

A successful response will return a `201 Created` status, along with the high score object in the body:

```json
{
    "id": 123,
    "name": "Beverly",
    "score": 78583,
    "created_at": "2018-08-19T20:27:27.837Z",
    "game": "sumo-topplers",
    "arcade_machine": "winnitron-1000"
}
```

### Errors

Sample error response (in this case, with status `422 Unprocessable Entity`):

```json
{
  "errors": ["Score can't be blank"]
}
```


## Fetching the High Score list

```
GET http://network.winnitron.com/api/v1/high_scores
```

### Parameters

param   | Description
--------|------------
`limit` | Optional (defaults to 10). The player's name.
`winnitron_id` | Optional. A Winnitron's parameterized name or public API key. Limits the returned scores to those made on a single arcade machine.
`test`  | Optional. Any value other than blank or 0 is treated as `true`


### Response

A successful response returns `200 OK` and an array of high score objects:

```json
{
  "high_scores":
    [
      {
        "id": 123,
        "name": "Beverly",
        "score": 78583,
        "created_at": "2018-08-19T20:27:27.837Z",
        "game": "sumo-topplers",
        "arcade_machine": "winnitron-1000"
      },
      {
        "id": 456,
        "name": "Jean-Luc",
        "score": 18583,
        "created_at": "2018-08-13T20:27:27.837Z",
        "game": "sumo-topplers",
        "arcade_machine": "winnitron-1000"
      }
    ]
}
```
