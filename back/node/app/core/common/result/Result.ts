type Result<T> = SuccessRes<T> | ErrorRes | NotFound;

type SuccessRes<T> = {
    type: "success";
    data: T;
}

type ErrorRes = {
    readonly type: "error";
    readonly exception: any;
}

type NotFound = {
    readonly type: "notFound";
}

const success = <T>(data: T): SuccessRes<T> => ({ type: "success", data });
const error = (exception: any): ErrorRes => ({ type: "error", exception });
const notFound: NotFound = { type: "notFound" };