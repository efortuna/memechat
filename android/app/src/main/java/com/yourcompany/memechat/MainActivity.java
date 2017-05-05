package com.yourcompany.memechat;

import android.content.Intent;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.PluginRegistry;

public class MainActivity extends FlutterActivity {
    PluginRegistry pluginRegistry;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        pluginRegistry = new PluginRegistry();
        pluginRegistry.registerAll(this);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
      super.onActivityResult(requestCode, resultCode, data);
      googleSignIn.onActivityResult(requestCode, resultCode, data);
    }
}
