const withErrorHandling = async <T>(asynchronousOperation: () => Promise<T>): Promise<T> => {
return asynchronousOperation()
        .catch(error => {
            console.error('An error occurred:', error);
            throw error; 
        }); 
}

export {withErrorHandling}