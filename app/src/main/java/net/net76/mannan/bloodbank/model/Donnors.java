package net.net76.mannan.bloodbank.model;

import com.orm.SugarRecord;

/**
 * Created by MANNAN on 5/17/2016.
 */
public class Donnors extends SugarRecord {

    public String _id;
    public String name;
    public String number;
    public String email;
    public String bloodGroup;
    public String city;
    public String country;
    public String lastDonated;
    public String availability;

    public Donnors() {
    }

    public Donnors(String name, String number, String email, String bloodGroup,
                   String city, String country, String lastDonated, String availability) {
        this.name = name;
        this.number = number;
        this.email = email;
        this.bloodGroup = bloodGroup;
        this.city = city;
        this.country = country;
        this.lastDonated = lastDonated;
        this.availability = availability;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String phone) {
        this.number = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getBloodGroup() {
        return bloodGroup;
    }

    public void setBloodGroup(String bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getLastDonated() {
        return lastDonated;
    }

    public void setLastDonated(String lastDonated) {
        this.lastDonated = lastDonated;
    }

    public String get_id() {
        return _id;
    }

    public void set_id(String _id) {
        this._id = _id;
    }

    public String getAvailability() {
        return availability;
    }

    public void setAvailability(String availability) {
        this.availability = availability;
    }
}
