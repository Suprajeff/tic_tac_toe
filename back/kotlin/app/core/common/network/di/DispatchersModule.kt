object DispatchersProvider {
    fun provideIODispatcher(): CoroutineDispatcher = Dispatchers.IO

    fun provideDefaultDispatcher(): CoroutineDispatcher = Dispatchers.Default
}