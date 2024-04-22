type Result<T> = SuccessRes<T> | ErrorRes | NotFound;

type SuccessRes<T> = {
    readonly status: "success";
    readonly data: T;
}

type ErrorRes = {
    readonly status: "error";
    readonly exception: any;
}

type NotFound = {
    readonly status: "notFound";
}

const success = <T>(data: T): SuccessRes<T> => ({ status: "success", data });
const error = (exception: any): ErrorRes => ({ status: "error", exception });
const notFound: NotFound = { status: "notFound" };

export {Result, success, error, notFound}