package com.firebase.realtimeDB;

import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.MutableData;
import com.google.firebase.database.Transaction;
import com.google.firebase.database.ValueEventListener;

public class FirebaseChat {
	boolean isStop = false;
	Logger logger = Logger.getLogger(FirebaseChat.class);
	private FirebaseDatabase database = null;
	private String chatRoomUid; //채팅방 하나 id
	private String myuid = "바나나";       //나의 id
	private String destUid = "파인애플";     //상대방 uid

	public static void main(String[] args) throws Exception {
		FirebaseChat fchat = new FirebaseChat();
		FirebaseController fc = new FirebaseController();
		Scanner sc = new Scanner(System.in);
		fc.initialize();
		fchat.database = FirebaseDatabase.getInstance();
		fc.readErrand(37.1234567, 126.4567891);
		sc.next();
		fchat.checkChatRoom();
		sc.next();
		fchat.sendMsg();
		sc.next();
	}


	public FirebaseChat() throws Exception { 
		if(database==null) {
			initialize();
			this.database = FirebaseDatabase.getInstance();
			hits();
		}
	}
	
	public void initialize() {
		try {
			// Fetch the service account key JSON file contents
			FileInputStream serviceAccount = new FileInputStream("D:\\portfolio_kosmo\\lab_spring4\\spring4_1_1\\src\\com\\firebase\\realtimeDB\\serviceAccountKey.json");
	
			// Initialize the app with a service account, granting admin privileges
			FirebaseOptions options = new FirebaseOptions.Builder()
					.setCredentials(GoogleCredentials.fromStream(serviceAccount))
					.setDatabaseUrl("https://memowebapp-4e9f3-default-rtdb.firebaseio.com").build();
			FirebaseApp.initializeApp(options);
			System.out.println("init성공");
		} catch (Exception e) {
			e.printStackTrace();
		}
			
	}

	public void hits() {
		Date date = new Date();
        SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat format2 = new SimpleDateFormat("HH");
        String time1 = format1.format(date);
        String hour = format2.format(date);
		DatabaseReference ref = database.getReference("hits/"+time1);
		DatabaseReference upvotesRef = ref.child(hour);
		upvotesRef.runTransaction(new Transaction.Handler() {
		  @Override
		  public Transaction.Result doTransaction(MutableData mutableData) {
		    Integer currentValue = mutableData.getValue(Integer.class);
		    if (currentValue == null) {
		      mutableData.setValue(1);
		    } else {
		      mutableData.setValue(currentValue + 1);
		    }

		    return Transaction.success(mutableData);
		  }

		  @Override
		  public void onComplete(
		      DatabaseError databaseError, boolean committed, DataSnapshot dataSnapshot) {
		    System.out.println("hits updated");
		  }
		});
		System.out.println("hits");
	}
	
	public void readErrand(double loc_x, double loc_y) {
		final FirebaseDatabase database = FirebaseDatabase.getInstance();
		DatabaseReference ref = database.getReference("errand");
		System.out.println("readErrand시작");
		// Attach a listener to read the data at our posts reference
		ref.orderByChild("loc_x")
		   .startAt(loc_x-0.005).endAt(loc_x+0.005)
		   //.startAt(loc_y-0.005).endAt(loc_y+0.005)
		   .addValueEventListener(new ValueEventListener() {
		  @Override
		  public void onDataChange(DataSnapshot dataSnapshot) {
			//BoardVO board = dataSnapshot.getValue(BoardVO.class);
			  for(DataSnapshot snapshot : dataSnapshot.getChildren()) {
				  ErrandVO user = snapshot.getValue(ErrandVO.class);
				  if(user.getLoc_y()>=loc_y-0.005 && user.getLoc_y()<=loc_y+0.005)
					  System.out.println("key:"+snapshot.getKey()+", X:"+user.getLoc_x()+", Y:"+user.getLoc_y());
			  }
		  }

		  @Override
		  public void onCancelled(DatabaseError databaseError) {
		    System.out.println("The read failed: " + databaseError.getCode());
		  }
		});
	}
	
	public void sendMsg() {
		
		
        ChatModel chatModel = new ChatModel();
        chatModel.users.put(myuid,true);
        chatModel.users.put(destUid,true);

        //push() 데이터가 쌓이기 위해 채팅방 key가 생성
        if(chatRoomUid == null){
        	System.out.println("채팅방 생성");
            database.getReference()
            .child("chatrooms")
            .push()
            .setValue(chatModel, new DatabaseReference.CompletionListener() {
      		  @Override
      		  public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
      		    if (databaseError != null) {
      		      System.out.println("Data could not be saved " + databaseError.getMessage());
      		    } else {
      		    	System.out.println("insert성공");
                    checkChatRoom();
      		    }
      		  }
      		});
        }else{
            sendMsgToDataBase();
        	System.out.println("이미 챗방있음");
        }
		System.out.println("성공2");
	}
	private void sendMsgToDataBase()
    {
        ChatModel.Comment comment = new ChatModel.Comment();
        Date time = new Date();
        SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss");
        String time1 = format1.format(time);
        comment.uid = myuid;
        comment.message = "네넵~기다리고 있습니다!";
        comment.timestamp = time1;
        database.getReference()
        .child("chatrooms")
        .child(chatRoomUid)
        .child("comments")
        .push()
        .setValue(comment, new DatabaseReference.CompletionListener() {
    		  @Override
    		  public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
    		    if (databaseError != null) {
    		      System.out.println("Data could not be saved " + databaseError.getMessage());
    		    } else {
    		    	System.out.println("sendMsg성공");
                  //checkChatRoom();
    		    }
    		  }
    		});
    }
	private void checkChatRoom()
    {
        //자신 key == true 일때 chatModel 가져온다.
        /* chatModel
        public Map<String,Boolean> users = new HashMap<>(); //채팅방 유저
        public Map<String, ChatModel.Comment> comments = new HashMap<>(); //채팅 메시지
        */
        database.getReference().child("chatrooms").orderByChild("users/"+myuid).equalTo(true).addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {
            	System.out.println("onDataChange snapshot:"+snapshot);
                for(DataSnapshot dataSnapshot:snapshot.getChildren()) //나, 상대방 id 가져온다.
                {
                    ChatModel chatModel = dataSnapshot.getValue(ChatModel.class);
                    System.out.println("chatModel="+chatModel);
                    if(chatModel.users.containsKey(destUid)){           //상대방 id 포함돼 있을때 채팅방 key 가져옴
                        chatRoomUid = dataSnapshot.getKey();
                        System.out.println("chatRoomUid="+chatRoomUid);
                        //sendMsgToDataBase();
                    }
                }
            }

            @Override
            public void onCancelled(DatabaseError error) {
            }
        });
    }
	
	public void getMsg(Map<String, Object> chatRoom) {
		DatabaseReference db = database.getReference().child("chatrooms").child(chatRoomUid).child("comments");
		db.addValueEventListener(new ValueEventListener() {

			@Override
			public void onDataChange(DataSnapshot snapshot) {
				for (DataSnapshot dataSnapshot : snapshot.getChildren()) {
					ChatModel.Comment lastMsg = dataSnapshot.getValue(ChatModel.Comment.class);
					chatRoom.put("message", lastMsg.message);
					chatRoom.put("timestamp", lastMsg.timestamp);
					if (lastMsg != null)
						break;
				}
				isStop = true;
			}

			@Override
			public void onCancelled(DatabaseError arg0) {
			}

		});
	}

	public void getUser(Map<String, Object> chatRoom, String nickname) {
		DatabaseReference db = database.getReference().child("chatrooms").child(chatRoomUid).child("users");
		db.addValueEventListener(new ValueEventListener() {

			@Override
			public void onDataChange(DataSnapshot snapshot) {
				for (DataSnapshot dataSnapshot : snapshot.getChildren()) {
					String userName = dataSnapshot.getKey();
					if (!nickname.equals(userName)) {
						chatRoom.put("user", userName);
						break;
					}
				}
				getMsg(chatRoom);
			}

			@Override
			public void onCancelled(DatabaseError arg0) {
			}

		});
	}

	public List<Map<String, Object>> getChatList(String nickname) {
		int cnt = 0;
		List<Map<String,Object>> chatList = new ArrayList<>();
		Map<String,Object> chatRoom = new HashMap<>();
		database.getReference().child("chatrooms").orderByChild("users/"+nickname).equalTo(true).addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {
                for(DataSnapshot dataSnapshot:snapshot.getChildren()) //나, 상대방 id 가져온다.
                {
                    ChatModel chatModel = dataSnapshot.getValue(ChatModel.class);
                    if(chatModel.users.containsKey(destUid)){           //상대방 id 포함돼 있을때 채팅방 key 가져옴
                        chatRoomUid = dataSnapshot.getKey();
                        chatRoom.put("RoomId", chatRoomUid);
                		getUser(chatRoom, nickname);
                        //sendMsgToDataBase();
                    }
                }
            }
            
            @Override
            public void onCancelled(DatabaseError error) {
            }
        });
		Date date = new Date();
		logger.info("start");
		System.out.println(date.getTime());
		while(!isStop) {
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if(cnt++>10) {
				System.out.println("데이터 요청 시간을 초과했습니다.");
				break;
			}
		}
		logger.info("end");
		System.out.println(date.getTime());
		chatList.add(chatRoom);
		isStop = false;
		return chatList;
	}

	public List<Map<String, Object>> enterChatroom(String RoomUid) {
		int cnt = 0;
		List<Map<String,Object>> chatMsgList = new ArrayList<>();
		DatabaseReference db = database.getReference().child("chatrooms").child(RoomUid).child("comments");
		db.addValueEventListener(new ValueEventListener() {

			@Override
			public void onDataChange(DataSnapshot snapshot) {
				for (DataSnapshot dataSnapshot : snapshot.getChildren()) {
					ChatModel.Comment lastMsg = dataSnapshot.getValue(ChatModel.Comment.class);
					Map<String,Object> chatMsg = new HashMap<>();
					chatMsg.put("message", lastMsg.message);
					chatMsg.put("timestamp", lastMsg.timestamp);
					chatMsg.put("sender", lastMsg.uid);
					chatMsgList.add(chatMsg);
				}
				isStop = true;
			}

			@Override
			public void onCancelled(DatabaseError arg0) {
			}

		});
		while(!isStop) {
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if(cnt++>10) {
				System.out.println("데이터 요청 시간을 초과했습니다.");
				break;
			}
		}
		isStop = false;
		return chatMsgList;
	}
}
