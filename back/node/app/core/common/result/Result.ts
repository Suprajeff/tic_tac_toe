type Result<T> = SuccessRes<T> | ErrorRes | NotFound;

type SuccessRes<T> = {
    type: "success";
    data: T;
}

type ErrorRes = {
    type: "error";
    exception: any;
}

type NotFound = {
    type: "notFound";
}

function success<T>(data: T): SuccessRes<T> {
    return { type: "success", data };
}

function error(exception: any): ErrorRes {
    return { type: "error", exception };
}

const notFound: NotFound = { type: "notFound" };