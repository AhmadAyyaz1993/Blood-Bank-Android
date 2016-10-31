package net.net76.mannan.bloodbank.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

/**
 * Created by MANNAN on 10/19/2015.
 */
public class PrefManager {
    SharedPreferences pref;
    Editor editor;
    Context _context;

    // Shared pref mode
    int PRIVATE_MODE = 0;

    // Shared pref file name
    private static final String PREF_NAME = "BloodBank";
    private static final String IS_LOGIN = "IsLoggedIn";
    private static final String KEY_HASH_SESSION = "hashSessionKey";
    private static final String USER_ID = "userID";
    private static final String USER_NAME = "username";
    private static final String PHONE_NUMBER = "phonenumber";
    private static final String BLOOD_GROUP = "bloodgroup";
    private static final String CITY = "city";
    private static final String COUNTRY = "country";
    private static final String EMAIL = "email";
    private static final String LAST_DONATED_DATE = "lastDonatedDate";
    private static final String LAST_DONATED_AT = "lastDonatedAt";
    private static final String AVAIALABILITY = "availability";

    // Constructor
    public PrefManager(Context context) {
        this._context = context;
        pref = _context.getSharedPreferences(PREF_NAME, PRIVATE_MODE);
        editor = pref.edit();
    }

    /**
     * Create login session
     */
    public void createLoginSession(String session_key) {
        // Storing login value as TRUE
        editor.putBoolean(IS_LOGIN, true);

        // Storing session key in pref
        editor.putString(KEY_HASH_SESSION, session_key);

        // commit changes
        editor.commit();
    }

    public void setUserId(String userId) {
        editor.putString(USER_ID, userId);
        editor.commit();
    }
    public String getUserId(){
        return pref.getString(USER_ID, "");
    }

    public void setUserName(String userName) {
        editor.putString(USER_NAME, userName);
        editor.commit();
    }
    public String getUserName(){
        return pref.getString(USER_NAME, "");
    }

    public void setPhoneNumber(String phoneNumber) {
        editor.putString(PHONE_NUMBER, phoneNumber);
        editor.commit();
    }
    public String getPhoneNumber(){
        return pref.getString(PHONE_NUMBER, "");
    }

    public void setBloodGroup(String bloodGroup) {
        editor.putString(BLOOD_GROUP, bloodGroup);
        editor.commit();
    }
    public String getBloodGroup(){
        return pref.getString(BLOOD_GROUP, "");
    }

    public void setCity(String city) {
        editor.putString(CITY, city);
        editor.commit();
    }
    public String getCity(){
        return pref.getString(CITY, "");
    }

    public void setCountry(String country) {
        editor.putString(COUNTRY, country);
        editor.commit();
    }
    public String getCountry(){
        return pref.getString(COUNTRY, "");
    }

    public void setEmail(String email) {
        editor.putString(EMAIL, email);
        editor.commit();
    }

    public String getEmail(){
        return pref.getString(EMAIL, "");
    }

    public void setLastDonatedDate(String last_donatedDate) {
        editor.putString(LAST_DONATED_DATE, last_donatedDate);
        editor.commit();
    }

    public String getLastDonatedDate(){
        return pref.getString(LAST_DONATED_DATE, "");
    }

    public void setLastDonatedAt(String last_donatedDonatedAt) {
        editor.putString(LAST_DONATED_AT, last_donatedDonatedAt);
        editor.commit();
    }

    public String getAvaialability(){
        return pref.getString(AVAIALABILITY, "");
    }

    public void setAvaialability(String avaialability) {
        editor.putString(AVAIALABILITY, avaialability);
        editor.commit();
    }

    public String getLastDonatedAt(){
        return pref.getString(LAST_DONATED_AT, "");
    }

    public void setHashKey(String hashKey) {
        editor.putString(KEY_HASH_SESSION, hashKey);
        editor.commit();
    }
    public String getHashKey(){
        return pref.getString(KEY_HASH_SESSION, "");
    }

    public boolean isLoggedIn() {
        return pref.getBoolean(IS_LOGIN, false);
    }

    public void logout() {
        editor.clear();
//        editor.putBoolean(IS_LOGED_IN, false);
        editor.commit();
    }
}
