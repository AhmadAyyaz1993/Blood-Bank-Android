package net.net76.mannan.bloodbank;

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
    private static final String KEY_CLIENT_ID = "clientID";
    private static final String KEY_AGENT_ID = "agentID";
    private static final String KEY_MOBILE = "mobile";
    private static final String KEY_CLIENT_NAME = "name";

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

    public void setAgentId(String agentId) {
        editor.putString(KEY_AGENT_ID, agentId);
        editor.commit();
    }
    public String getAgentId(){
        return pref.getString(KEY_AGENT_ID, "");
    }

    public void setClientId(String clientId) {
        editor.putString(KEY_CLIENT_ID, clientId);
        editor.commit();
    }
    public String getClientId(){
        return pref.getString(KEY_CLIENT_ID, "");
    }

    public void setKEY_MOBILE(String mobile) {
        editor.putString(KEY_MOBILE, mobile);
        editor.commit();
    }
    public String getKEY_MOBILE(){
        return pref.getString(KEY_MOBILE, "");
    }

    public void setHashKey(String hashKey) {
        editor.putString(KEY_HASH_SESSION, hashKey);
        editor.commit();
    }
    public String getHashKey(){
        return pref.getString(KEY_HASH_SESSION, "");
    }

    public void setKeyClientName(String clientName) {
        editor.putString(KEY_CLIENT_NAME, clientName);
        editor.commit();
    }

    public String getKeyClientName() {

        return pref.getString(KEY_CLIENT_NAME, "");
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
