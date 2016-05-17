package net.net76.mannan.bloodbank.Adapters;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

/**
 * Created by MANNAN on 5/17/2016.
 */
public class DonnorsListAdapter extends BaseAdapter {

    Context context;

    DonnorsListAdapter(){
    }

    public DonnorsListAdapter(Context context){
        this.context = context;
    }


    @Override
    public int getCount() {
        return 0;
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        return null;
    }
}
