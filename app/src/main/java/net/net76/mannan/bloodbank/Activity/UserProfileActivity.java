package net.net76.mannan.bloodbank.activity;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.TextView;

import net.net76.mannan.bloodbank.utils.PrefManager;
import net.net76.mannan.bloodbank.R;

public class UserProfileActivity extends AppCompatActivity {

    TextView user_profile_name, user_profile_email, user_profile_blood_group;
    TextView user_profile_city, user_profile_country, user_profile_mobile;
    FloatingActionButton fab;
    PrefManager prefManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_profile);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        initializeViews();
    }

    private void initializeViews() {
        prefManager = new PrefManager(getApplicationContext());
        fab = (FloatingActionButton) findViewById(R.id.fab);
        user_profile_name = (TextView) findViewById(R.id.user_profile_name);
        user_profile_email = (TextView) findViewById(R.id.user_profile_email);
        user_profile_mobile = (TextView) findViewById(R.id.user_profile_mobile);
        user_profile_blood_group = (TextView) findViewById(R.id.user_profile_blood_group);
        user_profile_city = (TextView) findViewById(R.id.user_profile_city);
        user_profile_country = (TextView) findViewById(R.id.user_profile_country);
        fabClickListner();
        textViewSetTexts();
    }

    private void fabClickListner() {
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });
    }

    private void textViewSetTexts() {
        user_profile_name.setText(prefManager.getUserName());
        user_profile_email.setText(prefManager.getEmail());
        user_profile_mobile.setText(prefManager.getPhoneNumber());
        user_profile_blood_group.setText(prefManager.getBloodGroup());
        user_profile_city.setText(prefManager.getCity());
        user_profile_country.setText(prefManager.getCountry());
    }

}
