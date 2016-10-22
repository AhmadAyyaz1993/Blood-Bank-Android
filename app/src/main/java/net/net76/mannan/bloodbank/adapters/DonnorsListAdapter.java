package net.net76.mannan.bloodbank.adapters;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;

import net.net76.mannan.bloodbank.activity.PhoneCallActivity;
import net.net76.mannan.bloodbank.datatypes.Donnors;
import net.net76.mannan.bloodbank.R;

import java.util.ArrayList;

/**
 * Created by MANNAN on 5/17/2016.
 */
public class DonnorsListAdapter extends BaseAdapter implements Filterable {


    Context context;
    private ArrayList<Donnors> array_donnors_data;
    private ArrayList<Donnors> new_array_donnors_data;

    DonnorsListAdapter(){
    }

    public DonnorsListAdapter(Context context, ArrayList<Donnors> array_donnors_data) {
        this.context = context;
        this.array_donnors_data = array_donnors_data;
        this.new_array_donnors_data = array_donnors_data;
    }


    @Override
    public int getCount() {
        return new_array_donnors_data.size();
    }

    @Override
    public Object getItem(int position) {
        return position;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    static class ViewHolder {
        TextView nameTV, numberTV, bloodGroupTv, cityTv;
        ImageView callButtonIV;
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, final ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            LayoutInflater layoutInflater = ((Activity) context).getLayoutInflater();
            convertView = layoutInflater.inflate(R.layout.donnors_list_item, null);
            holder = new ViewHolder();

            holder.bloodGroupTv = (TextView) convertView.findViewById(R.id.donnor_blood_group);
            holder.callButtonIV = (ImageView) convertView.findViewById(R.id.donnor_call_icon);
            holder.nameTV = (TextView) convertView.findViewById(R.id.donnor_name);
            holder.numberTV = (TextView) convertView.findViewById(R.id.donnor_number);
            holder.cityTv = (TextView) convertView.findViewById(R.id.donnor_city);

            convertView.setTag(holder);
        }else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.nameTV.setText(new_array_donnors_data.get(position).name);
        holder.numberTV.setText(new_array_donnors_data.get(position).number);
        holder.bloodGroupTv.setText(new_array_donnors_data.get(position).bloodGroup);
        holder.cityTv.setText(new_array_donnors_data.get(position).city+", "+
                              new_array_donnors_data.get(position).country);

        holder.bloodGroupTv.setBackgroundColor(Color.GREEN);
        holder.bloodGroupTv.setBackground(parent.getResources().getDrawable(R.drawable.circle_background));

        holder.callButtonIV.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String ph;
                Intent i = new Intent(parent.getContext(), PhoneCallActivity.class);
                if ((new_array_donnors_data.get(position).number.substring(0, 1).contains("+")
                        || new_array_donnors_data.get(position).number.substring(0, 1).contains("0"))
                        && new_array_donnors_data.get(position).number.length() > 2) {
                    ph = new_array_donnors_data.get(position).number.substring(
                            4, new_array_donnors_data.get(position).number.length());
                } else ph = new_array_donnors_data.get(position).number;
                ph = ph.replaceAll("[^1-9]", "1");
                i.putExtra("ph", ph);
                i.putExtra("phNumber", new_array_donnors_data.get(position).number);
                parent.getContext().startActivity(i);
            }
        });

        return convertView;
    }

    @Override
    public Filter getFilter() {
        Filter filter = new Filter() {
            @SuppressWarnings("unchecked")
            @Override
            protected void publishResults(CharSequence constraint,FilterResults results) {
                new_array_donnors_data = (ArrayList<Donnors>) results.values; // has the filtered values
                notifyDataSetChanged();  // notifies the data with new filtered values
            }
            @Override
            protected FilterResults performFiltering(CharSequence constraint) {
                FilterResults results = new FilterResults();        // Holds the results of a filtering operation in values
                ArrayList<Donnors> FilteredArrList = new ArrayList<Donnors>();
                if (new_array_donnors_data == null) {
                    new_array_donnors_data = new ArrayList<Donnors>(new_array_donnors_data); // saves the original data in mOriginalValues
                }
                /********
                 *
                 *  If constraint(CharSequence that is received) is null returns the mOriginalValues(Original) values
                 *  else does the Filtering and returns FilteredArrList(Filtered)
                 *
                 ********/
                if (constraint == null || constraint.length() == 0) {
                    // set the Original result to return
                    results.count = new_array_donnors_data.size();
                    results.values = new_array_donnors_data;
                } else {
                    constraint = constraint.toString().toLowerCase();
                    for (int i = 0; i < new_array_donnors_data.size(); i++) {
                        String data_blood_group = new_array_donnors_data.get(i).bloodGroup;
                        if (data_blood_group.toLowerCase().equals(constraint.toString())) {
                            FilteredArrList.add(
                                    new Donnors(new_array_donnors_data.get(i).name,
                                            new_array_donnors_data.get(i).number,
                                            new_array_donnors_data.get(i).email,
                                            new_array_donnors_data.get(i).bloodGroup,
                                            new_array_donnors_data.get(i).city,
                                            new_array_donnors_data.get(i).country,
                                            new_array_donnors_data.get(i).lastDonated,
                                            new_array_donnors_data.get(i).availability)
                            );
                        }else {
                        }
                    }
                    // set the Filtered result to return
                    results.count = FilteredArrList.size();
                    results.values = FilteredArrList;
                }
                return results;
            }
        };
        return filter;
    }

}
