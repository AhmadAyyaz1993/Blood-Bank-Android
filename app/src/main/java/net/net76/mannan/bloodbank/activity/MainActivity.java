package net.net76.mannan.bloodbank.activity;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.GridView;
import android.widget.ProgressBar;
import android.widget.TextView;

import net.net76.mannan.bloodbank.adapters.DonnorsListAdapter;
import net.net76.mannan.bloodbank.datatypes.Donnors;
import net.net76.mannan.bloodbank.R;
import net.net76.mannan.bloodbank.network.Http_Request;

import org.apache.http.NameValuePair;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    ProgressBar grid_progress_bar;
    GridView donnorsGridView;
    TextView no_record_text_view;
    ArrayList<Donnors> array_donnors_data ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
//        fab.hide();
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
                Intent intent = new Intent(getApplicationContext(), HomeActivity.class);
                startActivity(intent);
            }
        });

    }

    @Override
    protected void onResume() {
        super.onResume();
        new MyAsyncTask(getApplicationContext()).execute();
    }

    private  void initializeViews(){
        array_donnors_data = new ArrayList<Donnors>();
        grid_progress_bar = (ProgressBar) findViewById(R.id.grid_progress_bar);
        donnorsGridView = (GridView) findViewById(R.id.donners_grid_view);
        no_record_text_view = (TextView) findViewById(R.id.no_record_text_view);
    }

    private void startInsertingInListView(){
//        List<Donnors> donnorsList = Donnors.listAll(Donnors.class);

//        for (Donnors donnors:donnorsList) {
//            getArrayValues(donnors.name, donnors.number);
//            getArrayValues("Abdul Mannan", "03044422122", "AB+");
//        }
    }

    public void getArrayValues(String name,String number,String bloodGroup){

        List<Donnors> DONNERS_LIST = new ArrayList<Donnors>();

        Donnors donnors = new Donnors();

        donnors.name = name;
        donnors.number = number;
        donnors.bloodGroup = bloodGroup;

        DONNERS_LIST.add(donnors);

        array_donnors_data.addAll(0, DONNERS_LIST);
//        Collections.sort(array_donnors_data, new ListDescComparator());
    }

    class ListDescComparator implements Comparator<Donnors> {

        public int compare(Donnors app1, Donnors app2) {

            if(Integer.parseInt(app1.getLastDonated()) < Integer.parseInt(app2.getLastDonated())){
                return 1;
            }
            else
                return -1;
        }
    };

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

        } catch (Exception e) {
//            Log.d("TAG", e.getLocalizedMessage());
//            Toast.makeText(context, "lead sync catch:"+e.getLocalizedMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    private class MyAsyncTask extends AsyncTask<Void,Void,Void>{

        Context context;
        MyAsyncTask(Context context){
            this.context = context;
        }


        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            initializeViews();
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
