object CoroutineScopesModule {    
    private var scope: CoroutineScope? = null

    fun providesCoroutineScope(dispatcher: CoroutineDispatcher): CoroutineScope {
        return scope ?: createAndStoreScope(dispatcher)
    }

    private fun createAndStoreScope(dispatcher: CoroutineDispatcher): CoroutineScope {
        val newScope = CoroutineScope(SupervisorJob() + dispatcher)
        scope = newScope
        return newScope
    }
}