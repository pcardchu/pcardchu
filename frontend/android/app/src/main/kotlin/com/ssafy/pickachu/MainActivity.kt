package com.ssafy.pickachu

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import android.view.WindowManager

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 여기에 onCreate 관련 코드를 추가할 수 있습니다.
    }

    override fun onPause() {
        super.onPause()
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }

    override fun onResume() {
        super.onResume()
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
