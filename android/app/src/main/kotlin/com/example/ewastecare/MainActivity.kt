package com.example.ewastecare

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	companion object {
		private const val DOWNLOADS_CHANNEL = "ewastecare/downloads"
	}

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DOWNLOADS_CHANNEL)
			.setMethodCallHandler { call, result ->
				if (call.method == "saveFileToDownloads") {
					val fileName = call.argument<String>("fileName")
					val mimeType = call.argument<String>("mimeType")
					val bytes = call.argument<ByteArray>("bytes")

					if (fileName.isNullOrBlank() || mimeType.isNullOrBlank() || bytes == null) {
						result.error("INVALID_ARGS", "fileName, mimeType, and bytes are required", null)
						return@setMethodCallHandler
					}

					val uri = saveFileToDownloads(fileName, mimeType, bytes)
					if (uri != null) {
						result.success(uri)
					} else {
						result.error("SAVE_FAILED", "Failed to save file to Downloads", null)
					}
				} else {
					result.notImplemented()
				}
			}
	}

	private fun saveFileToDownloads(fileName: String, mimeType: String, bytes: ByteArray): String? {
		val resolver = applicationContext.contentResolver
		val values = ContentValues().apply {
			put(MediaStore.Downloads.DISPLAY_NAME, fileName)
			put(MediaStore.Downloads.MIME_TYPE, mimeType)
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
				put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
				put(MediaStore.Downloads.IS_PENDING, 1)
			}
		}

		val itemUri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values) ?: return null

		return try {
			resolver.openOutputStream(itemUri)?.use { stream ->
				stream.write(bytes)
			} ?: return null

			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
				val completeValues = ContentValues().apply {
					put(MediaStore.Downloads.IS_PENDING, 0)
				}
				resolver.update(itemUri, completeValues, null, null)
			}

			itemUri.toString()
		} catch (e: Exception) {
			resolver.delete(itemUri, null, null)
			null
		}
	}
}
