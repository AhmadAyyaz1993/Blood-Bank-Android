package net.net76.mannan.bloodbank.activity;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.support.v7.app.AppCompatActivity;
import android.app.LoaderManager.LoaderCallbacks;

import android.content.CursorLoader;
import android.content.Loader;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;

import android.os.Build;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

import net.net76.mannan.bloodbank.R;
import net.net76.mannan.bloodbank.datatypes.Donnors;
import net.net76.mannan.bloodbank.network.Http_Request;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONObject;


/**
 * A login screen that offers login via email/password.
 */
public class RegisterActivity extends AppCompatActivity implements LoaderCallbacks<Cursor> {

    /**
     * A dummy authentication store containing known user names and passwords.
     * TODO: remove after connecting to a real authentication system.
     */
    private static final String[] DUMMY_CREDENTIALS = new String[]{
            "foo@example.com:hello", "bar@example.com:world"
    };
    /**
     * Keep track of the login task to ensure we can cancel it if requested.
     */
    private UserRegisterTask mAuthTask = null;

    // UI references.
    private AutoCompleteTextView mEmailView;
    private Spinner bloodGroupSpinner;
    private EditText mPasswordView,nameET,numberET,confirmPasswordET,cityET,countryET;
    private View mProgressView;
    private View mRegisterFormView;

    private String registerResponse;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);
        setupActionBar();
        // Set up the login form.
        mEmailView = (AutoCompleteTextView) findViewById(R.id.email);
        populateAutoComplete();

        nameET = (EditText) findViewById(R.id.register_name);
        bloodGroupSpinner = (Spinner) findViewById(R.id.register_blood_group);
        numberET = (EditText) findViewById(R.id.register_number);
        cityET = (EditText) findViewById(R.id.register_city);
        countryET = (EditText) findViewById(R.id.register_country);
        confirmPasswordET = (EditText) findViewById(R.id.register_confirm_password);
        mPasswordView = (EditText) findViewById(R.id.register_password);
        mPasswordView.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView textView, int id, KeyEvent keyEvent) {
                if (id == R.id.login || id == EditorInfo.IME_NULL) {
                    attemptRegister();
                    return true;
                }
                return false;
            }
        });

        Button mEmailSignInButton = (Button) findViewById(R.id.register_button);
        mEmailSignInButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                attemptRegister();
            }
        });

        mRegisterFormView = findViewById(R.id.register_form);
        mProgressView = findViewById(R.id.register_progress);
    }

    private void populateAutoComplete() {
        getLoaderManager().initLoader(0, null, this);
    }

    /**
     * Set up the {@link android.app.ActionBar}, if the API is available.
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    private void setupActionBar() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            // Show the Up button in the action bar.
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }
    }

    /**
     * Attempts to sign in or register the account specified by the login form.
     * If there are form errors (invalid email, missing fields, etc.), the
     * errors are presented and no actual login attempt is made.
     */
    private void attemptRegister() {
        if (mAuthTask != null) {
            return;
        }

        // Reset errors.
        mEmailView.setError(null);
        mPasswordView.setError(null);

        // Store values at the time of the login attempt.
        String userName = nameET.getText().toString();
        String email = mEmailView.getText().toString();
        String phoneNum = numberET.getText().toString();
        final String[] bloodGroup = {""};
        String city  = cityET.getText().toString();
        String country  = countryET.getText().toString();
        String password = mPasswordView.getText().toString();
        String confirm_password = confirmPasswordET.getText().toString();

        bloodGroupSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position1, long id) {
                bloodGroup[0] = bloodGroupSpinner.getSelectedItem().toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });

        boolean cancel = false;
        View focusView = null;

        if (userName.equals("") && email.equals("") && phoneNum.equals("") && city.equals("")
                && country.equals("") && password.equals("") && confirm_password.equals("")) {
            nameET.setError(getString(R.string.error_field_required));
            mEmailView.setError(getString(R.string.error_field_required));
            numberET.setError(getString(R.string.error_field_required));
            cityET.setError(getString(R.string.error_field_required));
            countryET.setError(getString(R.string.error_field_required));
            mPasswordView.setError(getString(R.string.error_field_required));
            confirmPasswordET.setError(getString(R.string.error_field_required));
            focusView = nameET;
            cancel = true;
        } else if (userName.equals("")) {
            nameET.setError("Enter Name");
            focusView = nameET;
            cancel = true;
        } else if (email.equals("")) {
            mEmailView.setError(getString(R.string.error_field_required));
            focusView = mEmailView;
            cancel = true;
        } else if (phoneNum.equals("")) {
            numberET.setError("Enter Phone Number");
            focusView = numberET;
            cancel = true;
        } else if (bloodGroup.equals("")) {
            Toast.makeText(getApplicationContext(), "Select Blood Group", Toast.LENGTH_LONG).show();
        } else if (city.equals("")) {
            cityET.setError("Mention your City");
            focusView = cityET;
            cancel = true;
        } else if (country.equals("")) {
            cityET.setError("Mention your City");
            focusView = cityET;
            cancel = true;
            Toast.makeText(getApplicationContext(), "Mention your Country", Toast.LENGTH_LONG).show();
        }else if (password.isEmpty() && confirm_password.isEmpty()) {
            mPasswordView.setError("Enter Password & Confirm Password");
            focusView = mPasswordView;
            cancel = true;
        } else if (!password.equals(confirm_password)) {
            mPasswordView.setError("Password & Confirm Password doesn't match");
            focusView = mPasswordView;
            cancel = true;
        } else if (!isEmailValid(email)) {
            mEmailView.setError(getString(R.string.error_invalid_email));
            focusView = mEmailView;
            cancel = true;
        } /*else {
            registerUser(userName, psswrd, emailid, firstname, lastname, uType, position1, city1, description1);
        }*/

        if (cancel) {
            // There was an error; don't attempt login and focus the first
            // form field with an error.
            focusView.requestFocus();
        } else {
            // Show a progress spinner, and kick off a background task to
            // perform the user login attempt.
            showProgress(true);
            mAuthTask = new UserRegisterTask(email,userName,phoneNum, bloodGroup[0],password,confirm_password,city,country);
            mAuthTask.execute((Void) null);
        }
    }

    private boolean isEmailValid(String email) {
        return !TextUtils.isEmpty(email) && android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    private boolean isPasswordValid(String password) {
        //TODO: Replace this with your own logic
        return password.length() > 4;
    }

    /**
     * Shows the progress UI and hides the login form.
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB_MR2)
    private void showProgress(final boolean show) {
        // On Honeycomb MR2 we have the ViewPropertyAnimator APIs, which allow
        // for very easy animations. If available, use these APIs to fade-in
        // the progress spinner.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR2) {
            int shortAnimTime = getResources().getInteger(android.R.integer.config_shortAnimTime);

            mRegisterFormView.setVisibility(show ? View.GONE : View.VISIBLE);
            mRegisterFormView.animate().setDuration(shortAnimTime).alpha(
                    show ? 0 : 1).setListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    mRegisterFormView.setVisibility(show ? View.GONE : View.VISIBLE);
                }
            });

            mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
            mProgressView.animate().setDuration(shortAnimTime).alpha(
                    show ? 1 : 0).setListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
                }
            });
        } else {
            // The ViewPropertyAnimator APIs are not available, so simply show
            // and hide the relevant UI components.
            mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
            mRegisterFormView.setVisibility(show ? View.GONE : View.VISIBLE);
        }
    }

    @Override
    public Loader<Cursor> onCreateLoader(int i, Bundle bundle) {
        return new CursorLoader(this,
                // Retrieve data rows for the device user's 'profile' contact.
                Uri.withAppendedPath(ContactsContract.Profile.CONTENT_URI,
                        ContactsContract.Contacts.Data.CONTENT_DIRECTORY), ProfileQuery.PROJECTION,

                // Select only email addresses.
                ContactsContract.Contacts.Data.MIMETYPE +
                        " = ?", new String[]{ContactsContract.CommonDataKinds.Email
                .CONTENT_ITEM_TYPE},

                // Show primary email addresses first. Note that there won't be
                // a primary email address if the user hasn't specified one.
                ContactsContract.Contacts.Data.IS_PRIMARY + " DESC");
    }

    @Override
    public void onLoadFinished(Loader<Cursor> cursorLoader, Cursor cursor) {
        List<String> emails = new ArrayList<>();
        cursor.moveToFirst();
        while (!cursor.isAfterLast()) {
            emails.add(cursor.getString(ProfileQuery.ADDRESS));
            cursor.moveToNext();
        }

        addEmailsToAutoComplete(emails);
    }

    @Override
    public void onLoaderReset(Loader<Cursor> cursorLoader) {

    }

    private void addEmailsToAutoComplete(List<String> emailAddressCollection) {
        //Create adapter to tell the AutoCompleteTextView what to show in its dropdown list.
        ArrayAdapter<String> adapter =
                new ArrayAdapter<>(RegisterActivity.this,
                        android.R.layout.simple_dropdown_item_1line, emailAddressCollection);

        mEmailView.setAdapter(adapter);
    }


    private interface ProfileQuery {
        String[] PROJECTION = {
                ContactsContract.CommonDataKinds.Email.ADDRESS,
                ContactsContract.CommonDataKinds.Email.IS_PRIMARY,
        };

        int ADDRESS = 0;
        int IS_PRIMARY = 1;
    }

    /**
     * Represents an asynchronous login/registration task used to authenticate
     * the user.
     */
    public class UserRegisterTask extends AsyncTask<Void, Void, Boolean> {

        private final String email;
        private final String password;
        private final String confirm_password;
        private final String userName;
        private final String bloodGroup;
        private final String phoneNum;
        private final String country;
        private final String city;

        UserRegisterTask(String email, String userName, String phoneNum,
                         String bloodGroup, String password, String confirm_password,
                         String city, String country) {
            this.email = email;
            this.password = password;
            this.confirm_password = confirm_password;
            this.userName = userName;
            this.bloodGroup = bloodGroup;
            this.phoneNum = phoneNum;
            this.country = country;
            this.city = city;
        }

        @Override
        protected Boolean doInBackground(Void... params) {
            // TODO: attempt authentication against a network service.

            try {
                // Simulate network access.
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                return false;
            }

            registerDonnerHTTP(email,userName,phoneNum,
                    bloodGroup,password,city, country);

            // TODO: register the new account here.
            return true;
        }

        @Override
        protected void onPostExecute(final Boolean success) {
            mAuthTask = null;
            showProgress(false);

            Toast.makeText(getApplicationContext(), ""+registerResponse, Toast.LENGTH_SHORT).show();

            if (success && registerResponse.equals("Successfully Registered")) {
                finish();
            } else if (success && registerResponse.equals("Password Weak")){
                mPasswordView.setError("Must be Uppercase,lowercase,numeric & special character");
                mPasswordView.requestFocus();
            }else if (success && registerResponse.equals("Email Not Valid")){
                mEmailView.setError(getString(R.string.error_invalid_email));
                mEmailView.requestFocus();            }
            else {
                mPasswordView.setError(getString(R.string.error_incorrect_password));
                mPasswordView.requestFocus();
            }
        }

        @Override
        protected void onCancelled() {
            mAuthTask = null;
            showProgress(false);
        }
    }

    public void registerDonnerHTTP(String email,String user_name,String phone_num,
                                   String blood_group,String password,String city, String country) {

        final String FEED_URL = "https://fierce-plateau-60116.herokuapp.com/register";
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("email", email));
        params.add(new BasicNameValuePair("username", user_name));
        params.add(new BasicNameValuePair("phonenum", phone_num));
        params.add(new BasicNameValuePair("bloodgroup", blood_group));
        params.add(new BasicNameValuePair("password", password));
        params.add(new BasicNameValuePair("city", city));
        params.add(new BasicNameValuePair("country", country));

        String resultServer = Http_Request.getHttpPost(FEED_URL, params);
        JSONObject jObj;
        try {

            jObj = new JSONObject(resultServer);

            registerResponse = ""+jObj.getString("response");
//            Toast.makeText(getApplicationContext(), ""+registerResponse, Toast.LENGTH_SHORT).show();

        } catch (Exception e) {
//            Log.d("TAG", e.getLocalizedMessage());
//            Toast.makeText(context, "lead sync catch:"+e.getLocalizedMessage(), Toast.LENGTH_SHORT).show();
        }
    }

}

