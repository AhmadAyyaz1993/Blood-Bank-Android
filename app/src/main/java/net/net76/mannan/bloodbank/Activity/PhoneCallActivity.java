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

/**
 * Created by MANNAN on 1/20/2016.
 */
public class PhoneCallActivity extends Activity {

    String phNumber;
    String ph = "ph";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        Instrumentation.start("AD-AAB-AAB-UBU", getApplicationContext());
//        Instrumentation.reportMetric("PhoneCall called", 1);

        if (savedInstanceState == null) {
            Bundle extras2 = getIntent().getExtras();
            if(extras2 == null) {
                ph= "0";
            } else {
                ph = extras2.getString("ph");
            }
        }

        TelephonyManager telephonyManager = (TelephonyManager)getSystemService(Context.TELEPHONY_SERVICE);

//        if (mixPanelString.equals("TrackMixPanel")){
//        List<Call> callList = Call.find(Call.class,"type = ? || type = ?","receivedCalls","dialedCalls");
//        }

//        Instrumentation.reportMetric(""+telephonyManager.getDeviceId()+" DeviceID", 1);

        if (savedInstanceState == null) {
            Bundle extras = getIntent().getExtras();
            if(extras == null) {
                phNumber= "03044422122";
            } else {
                phNumber = extras.getString("phNumber");
            }
        } else {
            phNumber = (String) savedInstanceState.getSerializable("phNumber");
        }

//        if (mber == "null"){
//            phoneNumber = "3044422122";
//        }

        cancelNotification(getApplicationContext(), getIntent(), ph);

//        phoneCall("77"+phNumber);
        phoneCall(phNumber);

    }

    public void cancelNotification(Context context, Intent intent, String ph){
        NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        ph = intent.getExtras().getString("ph");
        manager.cancel(Integer.parseInt(ph));
        context.sendBroadcast(new Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS));
    }

    public void phoneCall(String phoneNum){
        PhoneCallListener phoneListener = new PhoneCallListener();
        TelephonyManager telephonyManager = (TelephonyManager) this.getSystemService(TELEPHONY_SERVICE);
        telephonyManager.listen(phoneListener, PhoneStateListener.LISTEN_CALL_STATE);
        Intent make_call_intent = new Intent(Intent.ACTION_CALL);
        make_call_intent.setData(Uri.parse("tel:" + ""+phoneNum));
        startActivity(make_call_intent);
        finish();
    }


    //monitor phone call activities
    private class PhoneCallListener extends PhoneStateListener {

        private boolean isPhoneCalling = false;

        String LOG_TAG = "LOGGING 123";

        @Override
        public void onCallStateChanged(int state, String incomingNumber) {

            if (TelephonyManager.CALL_STATE_RINGING == state) {
                // phone ringing
                Log.i(LOG_TAG, "RINGING, number: " + incomingNumber);
            }

            if (TelephonyManager.CALL_STATE_OFFHOOK == state) {
                // active
                Log.i(LOG_TAG, "OFFHOOK");

                isPhoneCalling = true;
            }

            if (TelephonyManager.CALL_STATE_IDLE == state) {
                // run when class initial and phone call ended,
                // need detect flag from CALL_STATE_OFFHOOK
                Log.i(LOG_TAG, "IDLE");

                if (isPhoneCalling) {

                    Log.i(LOG_TAG, "restart app");

                    // restart app
                    Intent i = getBaseContext().getPackageManager()
                            .getLaunchIntentForPackage(
                                    getBaseContext().getPackageName());
                    i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//                    startActivity(i);

                    isPhoneCalling = false;
                }

            }
        }
    }

}
