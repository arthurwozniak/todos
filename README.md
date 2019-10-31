# README

Really simple ToDo API with no real-world use case. Visit https://kamilovo.herokuapp.com/ to see the demo.

###Routes
| Path  | Request type | Description |
| ------------- | ------------- | ------------- | 
| /  | GET  | 42 |
| /to_dos| GET  | List users ToDos  |
| /to_dos| POST  | Create new users ToDo  |
| /to_dos/:id| GET  | Show specific ToDo  |
| /to_dos/:id| PUT  | Update specific ToDo  |
| /to_dos/:id| DELETE  | Destroy specific ToDo  |

### Requests
All resquests aiming to `/to_dos` route are supposed to contain `Authorization` header with users token.