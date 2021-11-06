package codes

type Code string

const (
	OK             Code = "ok"
	Created        Code = "created"
	BadParams      Code = "bad_params"
	EmptyBody      Code = "empty_body"
	InvalidRequest Code = "invalid_request"
	Unauthorized   Code = "unauthorized"
	NotFound       Code = "not_found"
	Unprocessable  Code = "unprocessable_entity"
	Internal       Code = "internal_error"
	Forbidden      Code = "forbidden"
	Unknown        Code = "unknown"
)
