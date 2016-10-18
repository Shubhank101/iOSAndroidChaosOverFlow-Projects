package com.shubhank.xmppdemo;

import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;

import org.jivesoftware.smack.AbstractXMPPConnection;
import org.jivesoftware.smack.ConnectionConfiguration;
import org.jivesoftware.smack.MessageListener;
import org.jivesoftware.smack.chat.Chat;
import org.jivesoftware.smack.chat.ChatManager;
import org.jivesoftware.smack.chat.ChatManagerListener;
import org.jivesoftware.smack.chat.ChatMessageListener;
import org.jivesoftware.smack.packet.Message;
import org.jivesoftware.smack.tcp.XMPPTCPConnection;
import org.jivesoftware.smack.tcp.XMPPTCPConnectionConfiguration;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        MyLoginTask task = new MyLoginTask();
        task.execute("");
    }


    private class MyLoginTask extends AsyncTask<String, String, String> {


        @Override
        protected String doInBackground(String... params) {
            // Create a connection to the jabber.org server.
            XMPPTCPConnectionConfiguration config = XMPPTCPConnectionConfiguration.builder()
                    .setUsernameAndPassword("user1", "123")
                    .setHost("10.0.2.2")
                    .setSecurityMode(ConnectionConfiguration.SecurityMode.disabled)
                    .setServiceName("localhost")
                    .setPort(5222)
                    .setDebuggerEnabled(true) // to view what's happening in detail
                    .build();

            AbstractXMPPConnection conn1 = new XMPPTCPConnection(config);
            try {
                conn1.connect();
                if(conn1.isConnected())
                {
                    Log.w("app", "conn done");
                }
                conn1.login();
                if(conn1.isAuthenticated())
                {
                    Log.w("app", "Auth done");
                    ChatManager chatManager = ChatManager.getInstanceFor(conn1);
                    chatManager.addChatListener(
                            new ChatManagerListener() {
                                @Override
                                public void chatCreated(Chat chat, boolean createdLocally)
                                {

                                    chat.addMessageListener(new ChatMessageListener()
                                    {
                                        @Override
                                        public void processMessage(Chat chat, Message message) {
                                            System.out.println("Received message: "
                                                    + (message != null ? message.getBody() : "NULL"));

                                        }


                                    });

                                    Log.w("app", chat.toString());
                                }
                            });

                }
            }
            catch (Exception e) {
                Log.w("app", e.toString());
            }

            return "";
        }


        @Override
        protected void onPostExecute(String result) {
            // execution of result of Long time consuming operation
        }

    }
}


