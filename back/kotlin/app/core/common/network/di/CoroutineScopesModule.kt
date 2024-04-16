object CoroutineScopesModule {    
    private var scope: CoroutineScope? = null
    private val scopeLock = Any()

    fun providesCoroutineScope(dispatcher: CoroutineDispatcher): CoroutineScope {
        synchronized(scopeLock) {
            return scope ?: createAndStoreScope(dispatcher)
        }
    }

    private fun createAndStoreScope(dispatcher: CoroutineDispatcher): CoroutineScope {
        val newScope = CoroutineScope(SupervisorJob() + dispatcher)
        synchronized(scopeLock) {
            scope = newScope
        }
        return newScope
    }
}