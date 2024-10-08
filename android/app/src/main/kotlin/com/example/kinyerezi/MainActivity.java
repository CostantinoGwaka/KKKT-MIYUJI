package app.miyuji;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

import android.view.WindowManager; 
import android.view.WindowManager.LayoutParams;
import android.os.Bundle; // required for onCreate parameter

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        //GeneratedPluginRegistrant.registerWith(flutterEngine);
    super.configureFlutterEngine(flutterEngine);
    }

    @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);
  }
}

