package net.net76.mannan.bloodbank.activity;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.Toast;

/**
 * Created by MANNAN on 1/20/2016.
 */
public class PhoneCallActivity extends Activity {
    private static String DEVICE_ID = "";
    String phNumber;
    String mixPanelString = "N/A";
    String ph = "ph";

    public PhoneCallActivity() {
    }

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if(savedInstanceState == null) {
            Bundle extras1 = this.getIntent().getExtras();
            if(extras1 == null) {
                this.phNumber = "03044422122";
            } else {
                this.phNumber = extras1.getString("phNumber");
            }
        } else {
            this.phNumber = (String)savedInstanceState.getSerializable("phNumber");
        }

        this.dialCall(this.phNumber);
    }

    private void dialCall(String phNumber) {
        Intent intent = new Intent("android.intent.action.DIAL");
        intent.setData(Uri.parse("tel:" + phNumber));
        this.startActivity(intent);
        this.finish();
    }

    public void phoneCall(String phoneNum) {
        PhoneCallActivity.PhoneCallListener phoneListener = new PhoneCallActivity.PhoneCallListener();
        TelephonyManager telephonyManager = (TelephonyManager)this.getSystemService("phone");
        telephonyManager.listen(phoneListener, 32);
        Intent make_call_intent = new Intent("android.intent.action.CALL");
        make_call_intent.setData(Uri.parse("tel:" + phoneNum));

        try {
            this.startActivity(make_call_intent);
            this.finish();
        } catch (Exception var6) {
            Toast.makeText(this, "Allow permissions for call in Settings", Toast.LENGTH_SHORT).show();
        }

    }

    private class PhoneCallListener extends PhoneStateListener {
        private boolean isPhoneCalling;
        String LOG_TAG;

        private PhoneCallListener() {
            this.isPhoneCalling = false;
            this.LOG_TAG = "LOGGING 123";
        }

        public void onCallStateChanged(int state, String incomingNumber) {
            if(1 == state) {
                Log.i(this.LOG_TAG, "RINGING, number: " + incomingNumber);
            }

            if(2 == state) {
                Log.i(this.LOG_TAG, "OFFHOOK");
                this.isPhoneCalling = true;
            }

            if(0 == state) {
                Log.i(this.LOG_TAG, "IDLE");
                if(this.isPhoneCalling) {
                    Log.i(this.LOG_TAG, "restart app");
                    Intent i = PhoneCallActivity.this.getBaseContext().getPackageManager().getLaunchIntentForPackage(PhoneCallActivity.this.getBaseContext().getPackageName());
                    i.addFlags(67108864);
                    this.isPhoneCalling = false;
                }
            }

        }
    }
}
