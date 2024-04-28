sealed class SData {
    data class Json(val data: Map<String, Any>) : SData()
    data class Html(val data: String) : SData()
}