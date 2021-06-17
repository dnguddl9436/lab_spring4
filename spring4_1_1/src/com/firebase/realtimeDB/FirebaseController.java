package com.firebase.realtimeDB;

import java.io.FileInputStream;
import java.util.HashMap;
import java.util.Map;

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

public class FirebaseController {

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

	public static void test() {
		DatabaseReference ref = FirebaseDatabase.getInstance().getReference("restricted_access/secret_document");
		ref.addListenerForSingleValueEvent(new ValueEventListener() {
			@Override
			public void onDataChange(DataSnapshot dataSnapshot) {
				Object document = dataSnapshot.getValue();
				System.out.println(document);
			}

			@Override
			public void onCancelled(DatabaseError error) {

			}
		});
	}

	public static class User {
		public String date_of_birth;
		public String full_name;
		public String nickname;

		public User(String dateOfBirth, String fullName) {
			this.date_of_birth = dateOfBirth;
			this.full_name = fullName;
		}

		public User(String dateOfBirth, String fullName, String nickname) {
			this.date_of_birth = dateOfBirth;
			this.full_name = fullName;
			this.nickname = nickname;
		}
	}

	public static void writeData() {
		final FirebaseDatabase database = FirebaseDatabase.getInstance();
		DatabaseReference ref = database.getReference("server/saving-data/fireblog");

		DatabaseReference usersRef = ref.child("users");

		Map<String, User> users = new HashMap<String, User>();
		users.put("alanisawesome", new User("June 23, 1912", "Alan Turing"));
		users.put("gracehop", new User("December 9, 1906", "Grace Hopper"));
		
		usersRef.setValueAsync(users);
		System.out.println("성공2");
	}

	public static void writeBoard() {
		final FirebaseDatabase database = FirebaseDatabase.getInstance();
		DatabaseReference ref = database.getReference();

		DatabaseReference usersRef = ref.child("board");

		Map<String, Object> boards = new HashMap<String, Object>();
		boards.put("1", new BoardVO(1, "title", 0, "202106072359", 1, "content", 50000, false, "email@gmail.com", 1));
		
		usersRef.setValueAsync(boards);
		System.out.println("성공2");
	}

	public static void insertErrand(String mem_nickname, double loc_x, double loc_y) {
		final FirebaseDatabase database = FirebaseDatabase.getInstance();
		DatabaseReference ref = database.getReference();

		DatabaseReference usersRef = ref.child("errand");

		//Map<String, Object> errand = new HashMap<>();
		//errand.put(mem_nickname, new ErrandVO(mem_nickname, loc_x, loc_y));
		
		//usersRef.setValueAsync(errand);
		usersRef.child(mem_nickname).setValueAsync(new ErrandVO(mem_nickname, loc_x, loc_y));
		System.out.println("성공2");
	}
	
	public static void updateData() {
		final FirebaseDatabase database = FirebaseDatabase.getInstance();
		DatabaseReference ref = database.getReference("server/saving-data/fireblog");

		DatabaseReference usersRef = ref.child("users");
		DatabaseReference hopperRef = usersRef.child("gracehop");
		Map<String, Object> hopperUpdates = new HashMap<String, Object>();
		hopperUpdates.put("nickname", "Amazing Grace");

		hopperRef.updateChildrenAsync(hopperUpdates);
	}
	
	public static void completeCB() {
		final FirebaseDatabase database = FirebaseDatabase.getInstance();
		DatabaseReference ref = database.getReference("server/saving-data/fireblog");

		DatabaseReference dataRef = ref.child("data");
		dataRef.setValue("I'm writing data", new DatabaseReference.CompletionListener() {
		  @Override
		  public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
		    if (databaseError != null) {
		      System.out.println("Data could not be saved " + databaseError.getMessage());
		    } else {
		      System.out.println("Data saved successfully.");
		    }
		  }
		});
		System.out.println("completeCB");
	}
	
	public static void transactionData() {
		final FirebaseDatabase database = FirebaseDatabase.getInstance();
		DatabaseReference ref = database.getReference();

		DatabaseReference upvotesRef = ref.child("board/1/bm_like");
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
		    System.out.println("Transaction completed");
		  }
		});
		System.out.println("transactionData");
	}
	
	public static void readData() {
		final FirebaseDatabase database = FirebaseDatabase.getInstance();
		DatabaseReference ref = database.getReference();

		// Attach a listener to read the data at our posts reference
		ref.addValueEventListener(new ValueEventListener() {
		  @Override
		  public void onDataChange(DataSnapshot dataSnapshot) {
			//BoardVO board = dataSnapshot.getValue(BoardVO.class);
			  for(DataSnapshot snapshot : dataSnapshot.getChildren()) {
				  System.out.println("key:"+snapshot.getKey()+", value:"+snapshot.getValue());
			  }
		  }

		  @Override
		  public void onCancelled(DatabaseError databaseError) {
		    System.out.println("The read failed: " + databaseError.getCode());
		  }
		});
	}
}
