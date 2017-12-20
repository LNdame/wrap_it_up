package awesome.shizzle.wrapitup;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(saved`InstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
