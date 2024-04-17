const withErrorHandling = async <T>(operation: () => Promise<T>): Promise<T> => {
return operation()
        .catch(error => {
            console.error('An error occurred:', error);
            throw error; 
        }); 
}

export {withErrorHandling}