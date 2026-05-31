package com.edu.classmate

import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.classmate.app/credentials"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveCredentials" -> {
                        val id = call.argument<String>("id")
                        val username = call.argument<String>("username")
                        val password = call.argument<String>("password")

                        if (id != null && username != null && password != null) {
                            saveCredentials(id, username, password)
                            result.success(null)
                        } else {
                            result.error("INVALID_ARGS", "Missing required arguments", null)
                        }
                    }
                    "getCredentials" -> {
                        val id = call.argument<String>("id")
                        if (id != null) {
                            val credentials = getCredentials(id)
                            result.success(credentials)
                        } else {
                            result.error("INVALID_ARGS", "Missing id argument", null)
                        }
                    }
                    "deleteCredentials" -> {
                        val id = call.argument<String>("id")
                        if (id != null) {
                            deleteCredentials(id)
                            result.success(null)
                        } else {
                            result.error("INVALID_ARGS", "Missing id argument", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun saveCredentials(id: String, username: String, password: String) {
        val prefs: SharedPreferences = getSharedPreferences("classmate_creds", Context.MODE_PRIVATE)
        prefs.edit().apply {
            putString("${id}_username", username)
            putString("${id}_password", password)
            apply()
        }
    }

    private fun getCredentials(id: String): Map<String, String>? {
        val prefs: SharedPreferences = getSharedPreferences("classmate_creds", Context.MODE_PRIVATE)
        val username = prefs.getString("${id}_username", null)
        val password = prefs.getString("${id}_password", null)

        return if (username != null && password != null) {
            mapOf(
                "username" to username,
                "password" to password
            )
        } else {
            null
        }
    }

    private fun deleteCredentials(id: String) {
        val prefs: SharedPreferences = getSharedPreferences("classmate_creds", Context.MODE_PRIVATE)
        prefs.edit().apply {
            remove("${id}_username")
            remove("${id}_password")
            apply()
        }
    }
}
