package types

type Informational int

const (
	Continue           Informational = 100
	SwitchingProtocols Informational = 101
	Processing         Informational = 102
)

type Success int

const (
	Ok Success = 200
	Created Success = 201
	Accepted                    Success = 202
	NonAuthoritativeInformation Success = 203
	NoContent       Success = 204
	ResetContent   Success = 205
	PartialContent   Success = 206
	MultiStatus     Success = 207
	AlreadyReported Success = 208
	ImUsed          Success = 226
)

type Redirection int

const (
	MultipleChoices  Redirection = 300
	MovedPermanently Redirection = 301
	FOUND        Redirection = 302
	SeeOther    Redirection = 303
	NotModified        Redirection = 304
	UseProxy           Redirection = 305
	TemporaryRedirect Redirection = 307
	PermanentRedirect Redirection = 308
)

type ClientError int

const (
	BadRequest   ClientError = 400
	Unauthorized    ClientError = 401
	PaymentRequired ClientError = 402
	Forbidden          ClientError = 403
	NotFound         ClientError = 404
	MethodNotAllowed              ClientError = 405
	NotAcceptable               ClientError = 406
	ProxyAuthenticationRequired ClientError = 407
	RequestTimeout              ClientError = 408
	Conflict                    ClientError = 409
	Gone                ClientError = 410
	LengthRequired     ClientError = 411
	PreconditionFailed ClientError = 412
	PayloadTooLarge    ClientError = 413
	UriTooLong         ClientError = 414
	UnsupportedMediaType ClientError = 415
	RangeNotSatisfiable  ClientError = 416
	ExpectationFailed      ClientError = 417
	MisdirectedRequest    ClientError = 421
	UnprocessableEntity ClientError = 422
	Locked              ClientError = 423
	FailedDependency ClientError = 424
	UpgradeRequired  ClientError = 426
	PreconditionRequired ClientError = 428
	TooManyRequests      ClientError = 429
	RequestHeaderFieldsTooLarge ClientError = 431
	UnavailableForLegalReasons  ClientError = 451
)

type ServerError int

const (
	InternalServerError ServerError = 500
	NotImplemented      ServerError = 501
	BadGateway         ServerError = 502
	ServiceUnavailable         ServerError = 503
	GatewayTimeout          ServerError = 504
	HttpVersionNotSupported ServerError = 505
	VariantAlsoNegotiates ServerError = 506
	InsufficientStorage ServerError = 507
	LoopDetected                    ServerError = 508
	NotExtended                   ServerError = 510
	NetworkAuthenticationRequired ServerError = 511
)