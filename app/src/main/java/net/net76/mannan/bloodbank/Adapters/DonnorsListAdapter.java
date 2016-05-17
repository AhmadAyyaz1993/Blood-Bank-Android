package net.net76.mannan.bloodbank.adapters;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import net.net76.mannan.bloodbank.activity.PhoneCallActivity;
import net.net76.mannan.bloodbank.datatypes.Donnors;
import net.net76.mannan.bloodbank.R;

import java.util.ArrayList;

/**
 * Created by MANNAN on 5/17/2016.
 */
public class DonnorsListAdapter extends BaseAdapter {


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
        TextView name, number, blood_group;
        ImageView call_button;
    }

    @Override
    public View getView(final int position, View convertView, final ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            LayoutInflater layoutInflater = ((Activity) context).getLayoutInflater();
            convertView = layoutInflater.inflate(R.layout.donnors_list_item, null);
            holder = new ViewHolder();

            holder.blood_group = (TextView) convertView.findViewById(R.id.donnor_blood_group);
            holder.call_button = (ImageView) convertView.findViewById(R.id.donnor_call_icon);
            holder.name = (TextView) convertView.findViewById(R.id.donnor_name);
            holder.number = (TextView) convertView.findViewById(R.id.donnor_number);

            convertView.setTag(holder);
        }else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.name.setText(new_array_donnors_data.get(position).name);
        holder.number.setText(new_array_donnors_data.get(position).number);
        holder.blood_group.setText(new_array_donnors_data.get(position).bloodGroup);
        holder.blood_group.setBackgroundColor(Color.GREEN);
        holder.blood_group.setBackground(parent.getResources().getDrawable(R.drawable.circle_backgroud));

        holder.call_button.setOnClickListener(new View.OnClickListener() {
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
}
