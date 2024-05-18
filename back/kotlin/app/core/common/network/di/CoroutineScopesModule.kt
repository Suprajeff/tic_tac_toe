package core.common.network.di

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.CoroutineDispatcher


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