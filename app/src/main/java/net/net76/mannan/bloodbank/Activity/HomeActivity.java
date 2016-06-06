package net.net76.mannan.bloodbank.activity;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.GridView;
import android.widget.ProgressBar;
import android.widget.TextView;

import net.net76.mannan.bloodbank.PrefManager;
import net.net76.mannan.bloodbank.R;
import net.net76.mannan.bloodbank.adapters.DonnorsListAdapter;
import net.net76.mannan.bloodbank.datatypes.Donnors;
import net.net76.mannan.bloodbank.network.Http_Request;

import org.apache.http.NameValuePair;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class HomeActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    Toolbar toolbar;
    PrefManager prefManager;
    FloatingActionButton fab;
    ProgressBar grid_progress_bar;
    GridView donnorsGridView;
    DrawerLayout drawer;
    ActionBarDrawerToggle toggle;
    NavigationView navigationView;
    TextView no_record_text_view;
    ArrayList<Donnors> array_donnors_data ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        initializeViews();
        setSupportActionBar(toolbar);
        setDrawerMenu();
        fabButtonListner();
    }

    private  void initializeViews(){
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        prefManager = new PrefManager(getApplicationContext());
        array_donnors_data = new ArrayList<Donnors>();
        fab = (FloatingActionButton) findViewById(R.id.fab);
        grid_progress_bar = (ProgressBar) findViewById(R.id.grid_progress_bar);
        donnorsGridView = (GridView) findViewById(R.id.donners_grid_view);
        no_record_text_view = (TextView) findViewById(R.id.no_record_text_view);
        drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        navigationView = (NavigationView) findViewById(R.id.nav_view);
    }

    private void setDrawerMenu() {
        drawer.setDrawerListener(toggle);
        toggle.syncState();
        navigationView.setNavigationItemSelectedListener(this);
    }

    private void fabButtonListner() {
        fab.hide();
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        new MyAsyncTask(getApplicationContext()).execute();
    }

    public void getArrayAdapter(){
        DonnorsListAdapter donnorsListAdapter = new DonnorsListAdapter(
                this,array_donnors_data);
        donnorsGridView.setAdapter(donnorsListAdapter);
    }

    public void donnersListFetchingHTTP() {

        final String FEED_URL = "https://fierce-plateau-60116.herokuapp.com/userlist";
        List<NameValuePair> params = new ArrayList<NameValuePair>();
//        params.add(new BasicNameValuePair("agent_num", "03044422122"));

        String resultServer = Http_Request.getHttpGet(FEED_URL);
//        String resultServer = Http_Request.getHttpPost(FEED_URL, params);
        JSONArray jArray;
        try {
            // Create Apache HttpClient
            jArray = new JSONArray(resultServer);
            JSONObject donnerObj;
//            int error = jobj.getInt("error");

//            String email,name,bloodgroup,phonenum,city,country,_id;
//            List<Donnors> DONNERS_LIST = new ArrayList<Donnors>();
            Donnors donnors;
//            donnersList = jobj.getJSONArray("leads");
            for (int i =0; i<jArray.length(); i++){
                donnors = new Donnors();
                donnerObj = jArray.getJSONObject(i);
                donnors.email = donnerObj.getString("email");
                donnors.name = donnerObj.getString("username");
                donnors.bloodGroup = donnerObj.getString("bloodgroup");
                donnors.number = donnerObj.getString("phonenum");
                donnors.city = donnerObj.getString("city");
                donnors.country = donnerObj.getString("country");
                donnors._id = donnerObj.getString("_id");

//                DONNERS_LIST.add(donnors);
                array_donnors_data.add(donnors);
            }
//            array_donnors_data.addAll(0, DONNERS_LIST);

        }
        catch (Exception e) {
//            Log.d("TAG", e.getLocalizedMessage());
//            Toast.makeText(context, "lead sync catch:"+e.getLocalizedMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.home, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_ab_positive) {
            return true;
        }
        if (id == R.id.action_b_negative) {
            return true;
        }
        if (id == R.id.action_a_positive) {
            return true;
        }
        if (id == R.id.action_a_negative) {
            return true;
        }
        if (id == R.id.action_b_positive) {
            return true;
        }
        if (id == R.id.action_b_negative) {
            return true;
        }
        if (id == R.id.action_o_positive) {
            return true;
        }
        if (id == R.id.action_o_negative) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.nav_register) {
            Intent intent  = new Intent(getApplicationContext(), RegisterActivity.class);
            startActivity(intent);
        } else if (id == R.id.nav_login) {
            Intent intent  = new Intent(getApplicationContext(), LoginActivity.class);
            startActivity(intent);
        } else if (id == R.id.nav_logout) {
            prefManager = new PrefManager(getApplicationContext());
            prefManager.logout();
        }

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    private class MyAsyncTask extends AsyncTask<Void,Void,Void> {

        Context context;
        MyAsyncTask(Context context){
            this.context = context;
        }


        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            grid_progress_bar.setVisibility(View.VISIBLE);
        }

        @Override
        protected Void doInBackground(Void... params) {

//            startInsertingInListView();
            donnersListFetchingHTTP();
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);

            if (array_donnors_data.size() > 0){
                getArrayAdapter();
                grid_progress_bar.setVisibility(View.GONE);
                no_record_text_view.setVisibility(View.GONE);
            }else {
                donnorsGridView.setVisibility(View.GONE);
                grid_progress_bar.setVisibility(View.GONE);
                no_record_text_view.setVisibility(View.VISIBLE);
            }

        }
    }

}
