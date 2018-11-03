# High Scores

## Create a new High Score

*This action requires a signed request.*

```
POST http://network.winnitron.com/api/v1/high_scores
```

### Parameters

param   | Description
--------|------------
`name`  | The player's name.
`score` | The player's score (an integer).
`winnitron_id` | Optional. The Winnitron's parameterized name or public API key.


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
