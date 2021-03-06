package net.net76.mannan.bloodbank.activity;

import android.app.Dialog;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.SwitchCompat;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.Window;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;

import net.net76.mannan.bloodbank.R;
import net.net76.mannan.bloodbank.network.Http_Request;
import net.net76.mannan.bloodbank.utils.PrefManager;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class UserProfileActivity extends AppCompatActivity {

    TextView user_profile_name, user_profile_email, user_profile_blood_group;
    TextView user_profile_city, user_profile_country, user_profile_mobile, user_profile_lastdonated;
    TextView last_donated_text_view;
    SwitchCompat availabilitySwitch;
    FloatingActionButton fab;
    ProgressBar lastDonatedprogressBar;
    ProgressBar lastDonatedListprogressBar;
    PrefManager prefManager;
    ListView lastDonatedHistoryList;
    InterstitialAd mInterstitialAd;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_profile);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        mInterstitialAd = new InterstitialAd(this);

        // set the ad unit ID
        mInterstitialAd.setAdUnitId(getString(R.string.interstitial_full_screen));

        AdRequest adRequest = new AdRequest.Builder()
                .build();

        // Load ads into Interstitial Ads
        mInterstitialAd.loadAd(adRequest);

        mInterstitialAd.setAdListener(new AdListener() {
            public void onAdLoaded() {
                showInterstitial();
            }
        });
        initializeViews();
        new MyAsyncTaskLastDonatedHistory(getApplicationContext()).execute();
    }
    private void showInterstitial() {
        if (mInterstitialAd.isLoaded()) {
            mInterstitialAd.show();
        }
    }

    private void initializeViews() {
        prefManager = new PrefManager(getApplicationContext());
        fab = (FloatingActionButton) findViewById(R.id.fab);
        user_profile_name = (TextView) findViewById(R.id.user_profile_name);
        user_profile_email = (TextView) findViewById(R.id.user_profile_email);
        user_profile_mobile = (TextView) findViewById(R.id.user_profile_mobile);
        user_profile_blood_group = (TextView) findViewById(R.id.user_profile_blood_group);
        user_profile_city = (TextView) findViewById(R.id.user_profile_city);
        last_donated_text_view = (TextView) findViewById(R.id.last_donated_text_view);
        availabilitySwitch = (SwitchCompat) findViewById(R.id.available_switch);
        user_profile_country = (TextView) findViewById(R.id.user_profile_country);
        user_profile_lastdonated = (TextView) findViewById(R.id.user_profile_lastdonated);
        lastDonatedprogressBar = (ProgressBar) findViewById(R.id.lastDonatedprogressBar);
        lastDonatedListprogressBar = (ProgressBar) findViewById(R.id.lastDonatedListprogressBar);
        lastDonatedHistoryList = (ListView) findViewById(R.id.last_donated_lv);
        lastDonatedprogressBar.setVisibility(View.GONE);
        lastDonatedListprogressBar.setVisibility(View.GONE);
        fabClickListner();
        textViewSetTexts();
        availabilityToggleClick();
    }

    private void availabilityToggleClick() {
        if (prefManager.getAvaialability().equals("true")
                || prefManager.getAvaialability().equals("")) {
            availabilitySwitch.setChecked(true);
        } else {
            availabilitySwitch.setChecked(false);
        }
        availabilitySwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    new availabilityTask("true").execute();
                } else {
                    new availabilityTask("false").execute();
                }
            }
        });
    }

    public void availabilityHTTP(String availability) {

        final String FEED_URL = "https://fierce-plateau-60116.herokuapp.com/updateavailability";
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("id", prefManager.getUserId()));
        params.add(new BasicNameValuePair("isavailable", availability));

        String resultServer = Http_Request.getHttpPost(FEED_URL, params);
        JSONObject jObj;
        try {
            jObj = new JSONObject(resultServer);

            String code = jObj.getString("code");
            String response = jObj.getString("response");
            if (code.equals("200")) {
                prefManager.setAvaialability(availability);
            } else {
                Toast.makeText(this, "" + response, Toast.LENGTH_SHORT).show();
            }
        } catch (Exception e) {
            Toast.makeText(this, "Exception:" + e, Toast.LENGTH_SHORT).show();
        }
    }

    private void fabClickListner() {
/*
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });
*/
    }

    private void textViewSetTexts() {
        user_profile_name.setText(prefManager.getUserName());
        user_profile_email.setText(prefManager.getEmail());
        user_profile_mobile.setText(prefManager.getPhoneNumber());
        user_profile_blood_group.setText(prefManager.getBloodGroup());
        user_profile_city.setText(prefManager.getCity() + "," + prefManager.getCountry());
        user_profile_country.setText(prefManager.getCountry());
        if (prefManager.getLastDonatedAt().equals("") || prefManager.getLastDonatedAt().equals("")){
            user_profile_lastdonated.setText("Never Donated.");
        }else {
            user_profile_lastdonated.setText(prefManager.getLastDonatedDate() + " @ " + prefManager.getLastDonatedAt());
        }
    }

    public void addLastDonatedDateClick(View view) {
        final Dialog dialog2 = new Dialog(UserProfileActivity.this);
        dialog2.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog2.getWindow().setFeatureInt(Window.FEATURE_CUSTOM_TITLE, R.string.app_name);
        dialog2.setContentView(R.layout.date_picker);
        final DatePicker datePicker = (DatePicker) dialog2.findViewById(R.id.datePicker);
        final EditText etLocation = (EditText) dialog2.findViewById(R.id.locEditText);
        final Button btnDone = (Button) dialog2.findViewById(R.id.btnDone);
        final Button btnCancel = (Button) dialog2.findViewById(R.id.btnCancel);
        btnDone.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SimpleDateFormat df = new SimpleDateFormat("dd MMMM yyyy");
                String formatedDate = "";
                formatedDate = df.format(new Date(datePicker.getYear() - 1900, datePicker.getMonth(), datePicker.getDayOfMonth()));
                String location = "";
                location = etLocation.getText().toString();
                if (!formatedDate.equals("") && !location.equals("")) {
                    new MyAsyncTaskAddLastDonated(getApplicationContext(), formatedDate, location).execute();
                    dialog2.dismiss();
                } else {
                    Toast.makeText(getApplicationContext(), "Please fill all values.", Toast.LENGTH_SHORT).show();
                }

            }
        });
        btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog2.dismiss();
            }
        });
        //Bind Array Adapter to ListView

        dialog2.show();

    }

    private class MyAsyncTaskAddLastDonated extends AsyncTask<Void, Void, Void> {

        Context context;
        String lastDonated;
        String donationPlace;
        String resultServer;

        MyAsyncTaskAddLastDonated(Context context, String lastDonated, String donationPlace) {
            this.context = context;
            this.lastDonated = lastDonated;
            this.donationPlace = donationPlace;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            lastDonatedprogressBar.setVisibility(View.VISIBLE);
        }

        @Override
        protected Void doInBackground(Void... params) {

            try {
                final String FEED_URL = "https://fierce-plateau-60116.herokuapp.com/addlastdonated";
                List<NameValuePair> param = new ArrayList<NameValuePair>();
                param.add(new BasicNameValuePair("id", prefManager.getUserId()));
                param.add(new BasicNameValuePair("lastdonated", lastDonated));
                param.add(new BasicNameValuePair("donationplace", donationPlace));

                resultServer = Http_Request.getHttpPost(FEED_URL, param);
            } catch (Exception e) {
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);

            JSONObject jObj;
            String response;
            try {

                jObj = new JSONObject(resultServer);

                response = "" + jObj.getString("response");
                if (response.equals("Last Donated Added")) {
                    Toast.makeText(getApplicationContext(), "Saved Successfully.", Toast.LENGTH_SHORT).show();
                    prefManager.setLastDonatedAt(lastDonated);
                    prefManager.setLastDonatedDate(donationPlace);

                    user_profile_lastdonated.setText(prefManager.getLastDonatedAt() + " @ " + prefManager.getLastDonatedDate());

                    new MyAsyncTaskLastDonatedHistory(getApplicationContext()).execute();
                } else {
                    Toast.makeText(getApplicationContext(), "" + response, Toast.LENGTH_SHORT).show();
                }

                lastDonatedprogressBar.setVisibility(View.GONE);

            } catch (Exception e) {
//            Log.d("TAG", e.getLocalizedMessage());
//            Toast.makeText(context, "lead sync catch:"+e.getLocalizedMessage(), Toast.LENGTH_SHORT).show();
            }
        }
    }

    public class availabilityTask extends AsyncTask<Void, Void, Boolean> {

        private final String availavility;

        availabilityTask(String availavility) {
            this.availavility = availavility;
        }

        @Override
        protected Boolean doInBackground(Void... params) {
            // TODO: attempt authentication against a network service.

            try {
                // Simulate network access.
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                return false;
            }

            try {
                availabilityHTTP(availavility);
            } catch (Exception e) {
            }

            // TODO: register the new account here.
            return true;
        }

        @Override
        protected void onPostExecute(final Boolean success) {
            super.onPostExecute(success);
        }

    }

    private class MyAsyncTaskLastDonatedHistory extends AsyncTask<Void, Void, Void> {

        Context context;
        String resultServer;

        MyAsyncTaskLastDonatedHistory(Context context) {
            this.context = context;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            lastDonatedListprogressBar.setVisibility(View.VISIBLE);
        }

        @Override
        protected Void doInBackground(Void... params) {

            try {
                final String FEED_URL = "https://fierce-plateau-60116.herokuapp.com/lastdonatedlist";
                List<NameValuePair> param = new ArrayList<NameValuePair>();
                param.add(new BasicNameValuePair("userid", prefManager.getUserId()));

                resultServer = Http_Request.getHttpPost(FEED_URL, param);
            } catch (Exception e) {
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);

            JSONArray jsonArray;

            List<String> lastDonatedList = new ArrayList<>();

            try {

                jsonArray = new JSONArray(resultServer);
                JSONObject jsonObject;

                for (int i = 0; i < jsonArray.length(); i++) {
                    jsonObject = jsonArray.getJSONObject(i);
                    lastDonatedList.add(0, jsonObject.getString("lastdonated")
                            + "\n@ " + jsonObject.getString("donationplace"));
                }

                ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),
                        R.layout.text, lastDonatedList);
                lastDonatedHistoryList.setAdapter(adapter);

                if (lastDonatedList.size() == 0) {
                    last_donated_text_view.setVisibility(View.GONE);
                }
                lastDonatedListprogressBar.setVisibility(View.GONE);


            } catch (Exception e) {
//            Log.d("TAG", e.getLocalizedMessage());
//            Toast.makeText(context, "lead sync catch:"+e.getLocalizedMessage(), Toast.LENGTH_SHORT).show();
            }
        }
    }

}
