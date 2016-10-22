package net.net76.mannan.bloodbank.application;

import android.app.Application;

import com.orm.SugarContext;
import com.splunk.mint.Mint;

import net.net76.mannan.bloodbank.R;

/**
 * Created by MANNAN on 7/30/2016.
 */
public class BloodApp extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        SugarContext.init(this);

        Mint.initAndStartSession(getApplicationContext(), getResources().getString(R.string.splunkKey));
        // /MintSplunkKey.splunkKey);

    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        SugarContext.terminate();
    }

}
